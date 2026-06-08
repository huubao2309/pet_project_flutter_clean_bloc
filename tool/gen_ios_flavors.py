#!/usr/bin/env python3
"""Generate per-flavor Xcode build configurations and schemes.

Idempotent: running it twice will not duplicate configs/schemes because it
keys everything off deterministic identifiers and bails if they already exist.

It clones the project's existing Debug/Release/Profile build configurations
into `<Mode>-<flavor>` variants for the PBXProject, the Runner target and the
RunnerTests target, registers them in the matching XCConfigurationList, and
writes one xcscheme per flavor.
"""
from __future__ import annotations

import hashlib
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PBXPROJ = os.path.join(ROOT, "ios", "Runner.xcodeproj", "project.pbxproj")
SCHEMES_DIR = os.path.join(
    ROOT, "ios", "Runner.xcodeproj", "xcshareddata", "xcschemes"
)

# Base bundle identifier of the Runner app target (camelCase, as generated).
BASE_BUNDLE_ID = "com.clean.bloc.petProjectFlutterCleanBloc"
BASE_DISPLAY_NAME = "Pet Project"

# (flavor, bundle-id suffix, display name)
FLAVORS = [
    ("staging", ".stg", "Pet Project Staging"),
    ("uat", ".uat", "Pet Project UAT"),
    ("prod", "", "Pet Project"),
]
MODES = ["Debug", "Release", "Profile"]

# Existing base config object ids, per target/list.
RUNNER_CFG = {
    "Debug": "97C147061CF9000F007C117D",
    "Release": "97C147071CF9000F007C117D",
    "Profile": "249021D4217E4FDB00AE95B9",
}
PROJECT_CFG = {
    "Debug": "97C147031CF9000F007C117D",
    "Release": "97C147041CF9000F007C117D",
    "Profile": "249021D3217E4FDB00AE95B9",
}
TESTS_CFG = {
    "Debug": "331C8088294A63A400263BE5",
    "Release": "331C8089294A63A400263BE5",
    "Profile": "331C808A294A63A400263BE5",
}
RUNNER_LIST = "97C147051CF9000F007C117D"
PROJECT_LIST = "97C146E91CF9000F007C117D"
TESTS_LIST = "331C8087294A63A400263BE5"


def gen_id(seed: str, existing: set[str]) -> str:
    """Deterministic, collision-free 24-char uppercase hex id."""
    base = hashlib.md5(seed.encode()).hexdigest()[:24].upper()
    candidate = base
    salt = 0
    while candidate in existing:
        salt += 1
        candidate = hashlib.md5(f"{seed}{salt}".encode()).hexdigest()[:24].upper()
    existing.add(candidate)
    return candidate


def extract_block(text: str, obj_id: str) -> str:
    """Return the full `<id> ... };` XCBuildConfiguration object block."""
    start = text.index(f"\t\t{obj_id} ")
    end = text.index("\n\t\t};\n", start) + len("\n\t\t};\n")
    return text[start:end]


def comment_of(block: str) -> str:
    # `\t\t<id> /* Debug */ = {`
    return re.search(r"/\* (.+?) \*/", block).group(1)


def main() -> int:
    with open(PBXPROJ, "r", encoding="utf-8") as fh:
        text = original = fh.read()

    if "Debug-staging" in text:
        print("Flavor configs already present; nothing to do.")
        return 0

    existing_ids = set(re.findall(r"\b([0-9A-F]{24})\b", text))

    # --- 1. Add APP_DISPLAY_NAME to base Runner configs (fallback name). ---
    for mode, cid in RUNNER_CFG.items():
        block = extract_block(text, cid)
        if "APP_DISPLAY_NAME" not in block:
            new_block = block.replace(
                "\t\t\tbuildSettings = {\n",
                f'\t\t\tbuildSettings = {{\n\t\t\t\tAPP_DISPLAY_NAME = "{BASE_DISPLAY_NAME}";\n',
                1,
            )
            text = text.replace(block, new_block, 1)

    # --- 2. Clone configs for every flavor x mode across the three lists. ---
    new_objects: list[str] = []
    # list id -> list of "<id> /* name */," lines to append
    list_additions: dict[str, list[str]] = {
        RUNNER_LIST: [],
        PROJECT_LIST: [],
        TESTS_LIST: [],
    }

    targets = [
        (RUNNER_CFG, RUNNER_LIST, True),  # Runner target: override bundle id
        (PROJECT_CFG, PROJECT_LIST, False),
        (TESTS_CFG, TESTS_LIST, False),
    ]

    for flavor, suffix, display in FLAVORS:
        for mode in MODES:
            new_name = f"{mode}-{flavor}"
            for cfg_map, list_id, is_runner in targets:
                base_block = extract_block(text, cfg_map[mode])
                new_oid = gen_id(f"{list_id}:{new_name}", existing_ids)
                block = base_block

                # Replace object id (first occurrence is the declaration).
                block = block.replace(cfg_map[mode], new_oid, 1)
                # Rename the leading comment + the `name = X;` field.
                old_comment = comment_of(base_block)
                block = block.replace(
                    f"/* {old_comment} */", f"/* {new_name} */", 1
                )
                block = re.sub(
                    r"\n\t\t\tname = [^;]+;\n\t\t\};\n$",
                    f'\n\t\t\tname = "{new_name}";\n\t\t}};\n',
                    block,
                )

                if is_runner:
                    block = block.replace(
                        f"PRODUCT_BUNDLE_IDENTIFIER = {BASE_BUNDLE_ID};",
                        f"PRODUCT_BUNDLE_IDENTIFIER = {BASE_BUNDLE_ID}{suffix};",
                        1,
                    )
                    block = block.replace(
                        f'APP_DISPLAY_NAME = "{BASE_DISPLAY_NAME}";',
                        f'APP_DISPLAY_NAME = "{display}";',
                        1,
                    )

                new_objects.append(block)
                list_additions[list_id].append(
                    f"\t\t\t\t{new_oid} /* {new_name} */,"
                )

    # Insert new objects before end of XCBuildConfiguration section.
    marker = "/* End XCBuildConfiguration section */"
    text = text.replace(marker, "".join(new_objects) + marker, 1)

    # Append new ids into each XCConfigurationList's buildConfigurations array.
    for list_id, lines in list_additions.items():
        anchor = f"{list_id} /* Build configuration list"
        idx = text.index(anchor)
        bc_open = text.index("buildConfigurations = (\n", idx)
        bc_close = text.index("\t\t\t);\n", bc_open)
        insertion = "\n".join(lines) + "\n"
        text = text[:bc_close] + insertion + text[bc_close:]

    with open(PBXPROJ, "w", encoding="utf-8") as fh:
        fh.write(text)

    # --- 3. Write one scheme per flavor. ---
    os.makedirs(SCHEMES_DIR, exist_ok=True)
    for flavor, _suffix, _display in FLAVORS:
        with open(
            os.path.join(SCHEMES_DIR, f"{flavor}.xcscheme"), "w", encoding="utf-8"
        ) as fh:
            fh.write(scheme_xml(flavor))

    print(
        f"Added {len(new_objects)} build configurations and "
        f"{len(FLAVORS)} schemes."
    )
    print(f"pbxproj grew {len(original)} -> {len(text)} bytes.")
    return 0


def scheme_xml(flavor: str) -> str:
    return f"""<?xml version="1.0" encoding="UTF-8"?>
<Scheme
   LastUpgradeVersion = "1510"
   version = "1.3">
   <BuildAction
      parallelizeBuildables = "YES"
      buildImplicitDependencies = "YES">
      <BuildActionEntries>
         <BuildActionEntry
            buildForTesting = "YES"
            buildForRunning = "YES"
            buildForProfiling = "YES"
            buildForArchiving = "YES"
            buildForAnalyzing = "YES">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "97C146ED1CF9000F007C117D"
               BuildableName = "Runner.app"
               BlueprintName = "Runner"
               ReferencedContainer = "container:Runner.xcodeproj">
            </BuildableReference>
         </BuildActionEntry>
      </BuildActionEntries>
   </BuildAction>
   <TestAction
      buildConfiguration = "Debug-{flavor}"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      customLLDBInitFile = "$(SRCROOT)/Flutter/ephemeral/flutter_lldbinit"
      shouldUseLaunchSchemeArgsEnv = "YES">
      <MacroExpansion>
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "97C146ED1CF9000F007C117D"
            BuildableName = "Runner.app"
            BlueprintName = "Runner"
            ReferencedContainer = "container:Runner.xcodeproj">
         </BuildableReference>
      </MacroExpansion>
      <Testables>
         <TestableReference
            skipped = "NO"
            parallelizable = "YES">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "331C8080294A63A400263BE5"
               BuildableName = "RunnerTests.xctest"
               BlueprintName = "RunnerTests"
               ReferencedContainer = "container:Runner.xcodeproj">
            </BuildableReference>
         </TestableReference>
      </Testables>
   </TestAction>
   <LaunchAction
      buildConfiguration = "Debug-{flavor}"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      customLLDBInitFile = "$(SRCROOT)/Flutter/ephemeral/flutter_lldbinit"
      launchStyle = "0"
      useCustomWorkingDirectory = "NO"
      ignoresPersistentStateOnLaunch = "NO"
      debugDocumentVersioning = "YES"
      debugServiceExtension = "internal"
      enableGPUValidationMode = "1"
      allowLocationSimulation = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "97C146ED1CF9000F007C117D"
            BuildableName = "Runner.app"
            BlueprintName = "Runner"
            ReferencedContainer = "container:Runner.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </LaunchAction>
   <ProfileAction
      buildConfiguration = "Profile-{flavor}"
      shouldUseLaunchSchemeArgsEnv = "YES"
      savedToolIdentifier = ""
      useCustomWorkingDirectory = "NO"
      debugDocumentVersioning = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "97C146ED1CF9000F007C117D"
            BuildableName = "Runner.app"
            BlueprintName = "Runner"
            ReferencedContainer = "container:Runner.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </ProfileAction>
   <AnalyzeAction
      buildConfiguration = "Debug-{flavor}">
   </AnalyzeAction>
   <ArchiveAction
      buildConfiguration = "Release-{flavor}"
      revealArchiveInOrganizer = "YES">
   </ArchiveAction>
</Scheme>
"""


if __name__ == "__main__":
    sys.exit(main())
