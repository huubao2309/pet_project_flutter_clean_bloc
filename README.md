# pet_project_clean_bloc

Pet project demonstrating **Clean Architecture** with the **BLoC** pattern in Flutter.

## Requirements

| Tool        | Version                                         |
|-------------|-------------------------------------------------|
| Flutter     | **3.35.2** (stable) — the version pinned in CI  |
| Dart SDK    | `>=3.5.0 <4.0.0` (see `pubspec.yaml`)           |

```bash
flutter --version   # expect Flutter 3.35.2 / Dart 3.5+
flutter pub get     # install dependencies
```

State management uses `flutter_bloc`, dependency injection uses `get_it`,
navigation uses `go_router`, networking uses `dio`, and localization uses
`easy_localization`.

## Architecture

The project follows **Clean Architecture**: a feature-first layout where every
feature is split into three layers with a strict, inward-only dependency rule
(`presentation → domain ← data`). The **domain layer depends on nothing** —
`data` and `presentation` both depend on it, never the reverse.

```
lib/
├── main.dart                 # MyApp (MaterialApp.router) — shared by all flavors
├── main_staging.dart         # flavor entry points → construct the matching Env
├── main_uat.dart
├── main_prod.dart
├── environments/             # per-flavor config (baseUrl, EnvType) + bootstrap
│   ├── env.dart              #   abstract Env: init DI, style, locale, runApp()
│   ├── staging_env.dart / uat_env.dart / production_env.dart
│   └── env_type.dart
├── base/                     # app-wide constants & enums
├── core/                     # cross-cutting infrastructure (shared by features)
│   ├── di/                   #   get_it service locator (configureDependencies)
│   ├── network/              #   dio client + interceptors
│   ├── router/               #   go_router config & navigation guards
│   ├── storage/              #   secure_storage + local (hive/shared_preferences)
│   ├── error/                #   exceptions / failures
│   ├── localization/         #   language use cases (data + domain)
│   ├── security/             #   security data + domain
│   ├── theme/                #   theme mode + view model
│   ├── use_case/             #   UseCase base classes
│   └── presentation/         #   shared widgets & common UI
└── features/                 # one folder per feature, each a clean slice
    ├── auth/
    │   ├── data/             #   datasources (api/mock), models (DTOs), repository impl
    │   ├── domain/           #   entities, repository interfaces, use_cases
    │   └── presentation/     #   pages, widgets, view_model (BLoC/Cubit + state)
    ├── app_update/  commission/  home/  main/  onboarding/
    ├── profile/     qr_scan/      settings/  splash/
```

### Layer responsibilities

- **Domain** — pure Dart business rules. Contains `entities`, abstract
  `repositories` (interfaces), and `use_cases`. No Flutter/dio/storage imports.
- **Data** — implements the domain repository interfaces. Holds `datasources`
  (a real API source and a mock source), `models` (DTOs with JSON
  serialization), and `repositories` (the concrete `*_repository_imp.dart`).
- **Presentation** — `view_model` (BLoC/Cubit + immutable state classes),
  `pages`, and `widgets`. Talks to domain use cases only.

### Dependency injection

`get_it` is the service locator. `configureDependencies(env)` in
`lib/core/di/injection.dart` is called from `Env._bootstrap()` before `runApp`,
registering data sources, repositories, use cases and view models. Because
data sources are swappable in DI, tests can substitute a mock backend
(`AuthMockDataSource`) without touching the widgets.

### Design system

Shared UI components live in the local package `packages/benny_style`
(imported as `benny_style`). See `docs/design/benny_design_system.html` before
UI work.

## Build flavors

The app ships three flavors — `staging`, `uat`, `prod` — wired across Dart,
Android and iOS.

| Flavor    | Android applicationId suffix | iOS bundle id suffix | App name            | Base URL (`Env.baseUrl`)                       |
|-----------|------------------------------|----------------------|---------------------|------------------------------------------------|
| `staging` | `.stg`                       | `.stg`               | Pet Project Staging | `https://pet.project.flutter.io/staging/v1`    |
| `uat`     | `.uat`                       | `.uat`               | Pet Project UAT     | (see `lib/environments/uat_env.dart`)          |
| `prod`    | _(none)_                     | _(none)_             | Pet Project         | (see `lib/environments/production_env.dart`)   |

Each flavor has its own Dart entry point (`lib/main_<flavor>.dart`) and an
environment class in `lib/environments/` holding per-environment values
(`baseUrl`, `EnvType`).

### Run

```bash
flutter run --flavor staging -t lib/main_staging.dart
flutter run --flavor uat     -t lib/main_uat.dart
flutter run --flavor prod    -t lib/main_prod.dart
```

### Build

```bash
flutter build apk       --flavor prod --release -t lib/main_prod.dart
flutter build appbundle --flavor prod --release -t lib/main_prod.dart
flutter build ios       --flavor prod --release -t lib/main_prod.dart
```

VS Code launch configurations are provided in `.vscode/launch.json`.

### How it is wired

- **Dart** — `lib/main_<flavor>.dart` constructs the matching `Env`
  (`lib/environments/`), whose constructor runs `_bootstrap()`: init DI + design
  system + locale, then `runApp(MyApp(...))` (`lib/main.dart`).
- **Android** — `productFlavors` in `android/app/build.gradle.kts`; the app
  label comes from the `app_name` string resource per flavor.
- **iOS** — Xcode schemes `staging`/`uat`/`prod` with `<Mode>-<flavor>` build
  configurations; the display name comes from the `APP_DISPLAY_NAME` build
  setting read by `Info.plist`. The Xcode side is generated by
  `tool/gen_ios_flavors.py` (idempotent; re-run after `flutter create .`
  regenerates the iOS project).

## Testing

### Unit & widget tests (`test/`)

Fast, device-free tests that mirror the `lib/` tree. They mock at a layer
boundary (`mocktail`, `fake_async`) — use cases, repositories, view
models/BLoCs and widgets in isolation.

```bash
# Run the whole suite
flutter test test/

# With coverage (writes coverage/lcov.info)
flutter test test/ --coverage

# A single file
flutter test test/features/auth/domain/use_cases/login_use_case_test.dart

# Filter by name
flutter test test/ --name "login"
```

View the coverage report locally (requires `lcov`):

```bash
genhtml coverage/lcov.info -o coverage/html && open coverage/html/index.html
```

### Integration / end-to-end tests (`integration_test/`)

These launch the **real app** — real DI graph, real `go_router`, real
navigation guards and widgets — and drive it as a user would (splash → welcome
→ login → main). Determinism comes from the app's built-in fake backend
(`AuthMockDataSource`, wired by default in DI). They require a connected device
or emulator.

> **Gotchas** — the design system (`BennyStyle.initData`) and DI can only be
> initialized once per process, so each test file boots the app exactly once.
> Independent scenarios (e.g. the OTP branch) live in separate files so each
> gets a fresh process. Run integration tests with the **staging** flavor.

```bash
# Run a single flow (recommended — one boot per file)
flutter test integration_test/login_flow_test.dart --flavor staging

# Other flows
flutter test integration_test/login_otp_flow_test.dart      --flavor staging
flutter test integration_test/signup_flow_test.dart         --flavor staging
flutter test integration_test/signup_blocked_flow_test.dart --flavor staging
```

## CI/CD (GitHub Actions)

Workflows live in `.github/workflows/`. A reusable workflow
(`_build_flavor.yml`) builds one flavor's APK, uploads it to the run's
Artifacts, and pushes it to that flavor's Telegram channel; per-flavor caller
workflows decide *when* it runs. All jobs use Flutter **3.35.2** (stable).

| Workflow          | Trigger                                                        | What it does                                            |
|-------------------|---------------------------------------------------------------|---------------------------------------------------------|
| `test.yml`        | push to `main`; PR targeting `main`                           | `dart format` check → `flutter analyze` → `flutter test test/ --coverage`; uploads coverage; Telegram notify |
| `build_uat.yml`   | push to a branch `release/vX.Y.Z`                             | builds the **UAT** APK via `_build_flavor.yml`          |
| `build_prod.yml`  | push a tag `vX.Y.Z_RCn` (e.g. `v1.1.0_RC1`)                   | builds the **PROD** APK via `_build_flavor.yml`         |

### How to trigger each environment

- **Staging** — the reusable workflow supports `flavor: staging`, but there is
  no dedicated caller/trigger yet. To ship staging builds, add a
  `build_staging.yml` that calls `_build_flavor.yml` with `flavor: staging`
  (e.g. on push to `develop` or via `workflow_dispatch`). Locally, build with
  `flutter build apk --debug --flavor staging -t lib/main_staging.dart`.

- **UAT** — push (or open a PR that lands) a version branch:
  ```bash
  git checkout -b release/v1.1.0
  git push -u origin release/v1.1.0   # fires build_uat.yml → UAT APK
  ```

- **Production** — cut a release-candidate tag from the version branch:
  ```bash
  git tag v1.1.0_RC1
  git push origin v1.1.0_RC1          # fires build_prod.yml → PROD APK
  ```

### Required secrets

The build & test notifications post to Telegram:

- `TELEGRAM_BOT_TOKEN` — a **repository** secret (shared across flavors).
- `TELEGRAM_CHAT_ID` — an **environment** secret set per GitHub Environment
  (`staging` / `uat` / `prod`), so each flavor notifies its own channel. The
  build job binds to the Environment named after the flavor.

If either secret is missing the notification step warns and is skipped rather
than failing the build.
