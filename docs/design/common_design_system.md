# Common Design System — Mobile App UI Guide

> A senior-designer's reference for what a mobile Design System needs: how many
> colors, how many type sizes, how many button variants/sizes, spacing, radius,
> and the component set. Industry conventions (Material 3, Apple HIG, IBM
> Carbon, Shopify Polaris, Ant Design Mobile) are cross-referenced against the
> values **actually implemented** in this repo's `benny_style` package, so the
> doc is a spec you can build to — not theory.

---

## 0. What a Design System actually is

A Design System is **not** a color palette and a font. It is three layers:

| Layer | What it holds | Example here |
|-------|---------------|--------------|
| **1. Design Tokens** | The atomic decisions: color ramps, type scale, spacing, radius, elevation, motion. Named, not hard-coded. | `BennyDesignData`, `BennySpacing`, `BennyBorderRadius` |
| **2. Components** | Reusable widgets that consume tokens: button, text field, card, chip, snackbar… | `BennyPrimaryButton`, `BennyTextField`, `BennyCard` |
| **3. Patterns & Guidelines** | How components combine into flows: forms, empty states, loading, errors, navigation. | screen specs in `benny_design_system.html` |

**Golden rule:** a screen should never use a raw value (`Color(0xFF1A3C5E)`,
`fontSize: 14`, `EdgeInsets.all(16)`). It uses a **token**. Tokens are the
single source of truth; change once, propagate everywhere. This is exactly why
`benny_style` exposes everything through `ThemeState` / `BennyDesignData`.

Tokens come in two tiers (the industry standard, from Material 3 & Carbon):

- **Primitive / global tokens** — raw scale values: `navy/600 = #1A3C5E`, `spacing.medium = 16`.
- **Semantic / alias tokens** — meaning-based: `color.primary`, `color.danger`,
  `text.body`, `surface.background`. Semantic tokens *point at* primitives.
  Screens consume **semantic** tokens so a rebrand only re-points aliases.

---

## 1. Color — how many colors do you need?

### The market answer
A modern mobile palette is **not** "5 nice colors". It is a small set of
**roles**, each expanded into a **ramp of ~10 shades** (25→900). This is the
shared convention across Material 3 (tonal palettes), Tailwind, Carbon, and
Ant Design.

**You need ~6 color roles:**

| Role | Purpose | Min shades |
|------|---------|-----------|
| **Primary / Brand** | Main actions, headers, brand identity | 10–11 |
| **Secondary / Accent** | Highlights, secondary CTAs, emphasis | 10 |
| **Neutral / Gray** | Text, borders, backgrounds, dividers, disabled | 10–11 |
| **Success** | Positive feedback, confirmation | 10 |
| **Warning** | Caution, pending states | 10 |
| **Error / Danger** | Errors, destructive actions | 10 |
| _(optional)_ Info | Informational banners | 10 |

**Total raw colors:** ~6 roles × ~10 shades ≈ **60–70 primitive color tokens**.
That sounds like a lot, but you only *design* ~6 base hues; the ramps are
generated. Each ramp follows the same index meaning:

- `25–100` → subtle tinted **backgrounds / surfaces**
- `200–300` → **borders, dividers, disabled** fills
- `400–500` → **resting / default** interactive color
- `600–700` → **hover / pressed / emphasis**
- `800–900` → **text on light**, deep contrast

### What THIS project uses (`benny_style`)
Already implemented — use these, don't invent new ones:

**Brand — Navy** (`BennyDesignData.brandColor`), signature `#1A3C5E` at `600`:
```
25 #F3F6F9 · 50 #E9EFF4 · 100 #D2DFEA · 200 #A6BFD3 · 300 #7A9EBD
400 #3E6B92 · 500 #27557D · 600 #1A3C5E ← brand · 700 #142F49
800 #0E2234 · 900 #081521
```

**Secondary — Amber** (`#E8A020` at `500`) — highlights, the prominent center
action, money figures.

**Neutral / Success / Warning / Error** — full 25→900 ramps in
`colors/data_source_color.dart`.

### Semantic mapping (build screens against these, not raw hex)
| Semantic role | Token source |
|---------------|--------------|
| Primary action bg | `brand/600` |
| Primary pressed | `brand/700` |
| Accent / money | `secondary/500` |
| Body text | `neutral/700–900` |
| Secondary text | `neutral/500` |
| Border / divider | `neutral/200–300` |
| Disabled fill | `neutral/100–200` |
| Page background | `neutral/25–50` + white |
| Success / Warning / Error | `*/500` fill, `*/700` text, `*/50` bg |

> **Dark mode:** this app intentionally **removed dark mode** (branch
> `feature/remove_dark_mode`). The system is **single light theme** today.
> If reintroduced later, the right approach is a *second semantic mapping*
> (same components, alias tokens re-pointed), never duplicated components.

---

## 2. Typography — how many sizes?

### The market answer
A mobile type scale needs **~6–8 roles**, not dozens. Material 3 ships 5
roles × 3 sizes (Display, Headline, Title, Body, Label = 15 styles). Apple HIG
ships ~11 text styles. The practical sweet spot is **5–7 named roles**, each
with weight + line-height baked in.

### What THIS project uses
A compact **5-role scale**, each available in 3 device sizes (`sm` / `md` / `lg`
— responsive breakpoints), font **Figtree**:

| Role | sm | md | lg | Line height (md) | Weight | Use |
|------|----|----|----|------------------|--------|-----|
| **H1** | 24 | 28 | 32 | 40 | 600 | Screen titles, hero |
| **H2** | 18 | 20 | 22 | 32 | 600 | Section headers |
| **H3** | 14 | 15 | 16 | 22 | 600 | Card titles, sub-headers |
| **P (paragraph)** | 13 | 14 | 15 | 22 | 400–500 | Body, labels, links |
| **Caption** | 11 | 12 | 13 | 18 | 400 | Helper text, timestamps, meta |

Source: `font/font_size.dart`, `font/line_height.dart`.

**Weights:** only **3** are defined — `w400` (regular), `w500` (medium),
`w600` (semibold). That is deliberate and correct: most mature systems ship
2–4 weights. Don't add more.

**Paragraph has 4 variants** (`paragraph/`): `defaultPrimary`, `label`,
`labelLink`, `inlineLink` — same size, different weight/role. This is how you
get link vs. body vs. form-label without new sizes.

**Rules of thumb:**
- Line-height ≈ **1.4–1.5×** font size for body, **~1.25×** for headings (matches the values above).
- Never more than ~2 type sizes visible in one component.
- Size encodes hierarchy; **weight and color** do the fine-tuning.

---

## 3. Spacing — the 4-point / 8-point grid

### The market answer
Every serious system uses a **base unit** (4px) and a geometric-ish scale.
Material, Apple, Carbon all align to a **4pt/8pt grid**. You need roughly
**8–12 spacing steps**.

### What THIS project uses (`spacing/benny_spacing.dart`)
A 4-based scale, 12 steps:

```
zero 0 · superTiny 2 · tiny 4 · small 8 · smallX 12 · medium 16
mediumX 20 · large 24 · largeX 28 · largeXX 32 · extraLarge 36 · extraLargeX 40
```

**Usage convention:**
| Step | Typical use |
|------|-------------|
| 2–4 | Icon-to-label gap, chip internal |
| 8–12 | Inside buttons/inputs, list row padding |
| 16 | **Default** screen gutter & card padding |
| 20–24 | Between sections |
| 32–40 | Major blocks, top/bottom of screens |

> Default button padding in code = `H 12 / V 8`. Default text field height = `36`.

---

## 4. Corner radius (border radius)

### The market answer
**3–5 radius tokens** is enough: none, small (chips/tags), medium (buttons/
inputs/cards), large (sheets/modals), full (pills/avatars).

### What THIS project uses (`border_radius/benny_border_radius.dart`)
```
zero 0 · small 4 · medium 8 · large 16
```
- **8 (medium)** is the default for **buttons, inputs, cards** (confirmed in `benny_button_style.dart`).
- **4 (small)** for tags/chips.
- **16 (large)** for bottom sheets / dialogs.
- Add a `full` (999) only if you introduce pill buttons or avatars.

---

## 5. Buttons — how many variants & sizes?

This is the most-asked question, so it gets the most detail.

### The market answer — two independent axes
1. **Hierarchy / emphasis** (visual weight) — usually **4–5**:
   Primary (filled) · Secondary (tonal/outlined) · Tertiary · Ghost/Text · _(Destructive as a color, not a 5th shape)_.
2. **Size** — usually **3**: Small · Medium (default) · Large.
   Plus full-width and icon-only as modifiers.

So a complete button matrix ≈ **4 hierarchies × 3 sizes + icon variants**.

### What THIS project uses
**Hierarchy — 4 variants** (each its own widget):
| Variant | Widget | Look | Use |
|---------|--------|------|-----|
| **Primary** | `BennyPrimaryButton` | Filled brand | The one main action per screen |
| **Secondary** | `BennySecondaryButton` | Tonal / lighter fill | Alternative action |
| **Tertiary** | `BennyTertiaryButton` | Subtle, optional shadow | Low-emphasis action |
| **Ghost** | `BennyGhostButton` | Text / transparent | Inline, cancel, links |

**Color types — 4** (`BaseButtonType`): `brand` · `success` · `neutral` ·
`error`. This is how you express a **destructive** (error) or **confirm**
(success) button without inventing new shapes — hierarchy × color type.

**Icon buttons — 4 matching variants** (`buttons/icon_button/`): primary /
secondary / tertiary / ghost icon buttons.

**Modifiers:**
- **Full-width vs. wrap** — `isWrapContain` (`false` → stretches to `double.infinity`).
- **States** — every variant resolves `active` / `disabled` / `overlay`
  (pressed) via `WidgetState`. Default radius `8`, padding `H12/V8`, elevation `0`.

**Size note:** the current system drives size primarily through **padding +
text style + tap target** rather than 3 named size enums. If you need formal
S/M/L, add a `BennyButtonSize { small, medium, large }` enum mapping to
heights ~**32 / 40 / 48** and padding `H12/H16/H20` — that matches market norms
and the existing spacing scale. **Minimum tap target = 44×44 (iOS) / 48×48 (Android)** — never smaller, regardless of visual size.

### Button guidelines
- **One** primary button per screen/section.
- Destructive = `error` color type, usually on Secondary/Ghost hierarchy (avoid a big red filled button unless it's *the* action).
- Disabled buttons keep layout size; never remove them from the tree.
- Label = verb ("Save", "Continue"), Title Case or sentence case — pick one and keep it.

---

## 6. The component inventory (what `benny_style` ships)

A mobile design system typically needs **~20–30 components**. This repo already
has a strong set — **reuse these, don't rebuild**:

**Actions:** Primary/Secondary/Tertiary/Ghost buttons · icon buttons ·
`BennySelectionDial`.

**Inputs & selection:** `BennyTextField` · `BennyPhoneTextField` ·
`BennySearchTextField` · `BennyTextArea` · `BennyCheckBox` · `BennyRadio` ·
`BennySwitch` / `BennyLabelSwitch` · `BennyChoiceChip`.

**Containment:** `BennyCard` · `BennyBottomSheet` · `BennyDialog` · `BennyListItem`.

**Feedback & status:** `BennySnackbar` · `BennyInforBar` (timed progress) ·
`SnqdMessage` · `BennyTag` · `BennyCircleProgress` · `BennySpinner` ·
shimmer (`shimmer_helper`).

**Foundations:** colors · typography · spacing · radius · theme state.

### Gaps to consider adding (common in market systems, not yet here)
Avatar · Badge / notification dot · Tab bar / segmented control · Bottom
navigation bar · App bar / top bar · Stepper · Slider · Tooltip · Accordion ·
Skeleton variants · Empty-state template · Pull-to-refresh.

---

## 7. Elevation, shadow & motion

| Token group | Market norm | Guidance for this app |
|-------------|-------------|-----------------------|
| **Elevation** | 4–6 levels (0/1/2/4/8/16) | Mostly flat (buttons elevation `0`). Use shadow for cards, sheets, dialogs only. |
| **Shadow** | 2–3 named shadows (sm/md/lg) | Tertiary button already exposes `isHasShadow`. Define `shadow.sm/md/lg`. |
| **Motion** | Durations 100/200/300ms; standard easing | Default **200ms ease-in-out** for state changes; **300ms** for sheets/dialogs; respect reduce-motion. |

---

## 8. Iconography & imagery

- **Icon grid:** 24×24 base, single stroke weight, 2 sizes (16 / 24) min, optionally 20 & 32.
- Icons inherit text color via `iconColor` (already wired in button styles).
- **Asset pipeline:** `generated/assets.gen.dart` + `fonts.gen.dart` (flutter_gen). Add new icons/fonts through generation, never raw paths.

---

## 9. Accessibility (non-negotiable)

- **Contrast:** body text ≥ **4.5:1**, large text/icons ≥ **3:1** against background. Check Navy/Amber on white especially.
- **Tap targets:** ≥ **44×44** (iOS) / **48×48** (Android).
- **Text scaling:** support OS font scaling up to ~130%; the `sm/md/lg` scale helps but test reflow.
- **Don't rely on color alone** for state (pair error color with icon/text).
- **Semantics:** every interactive widget needs a label for screen readers.

---

## 10. Governance — keeping the system alive

1. **Single source of truth:** all tokens live in `benny_style` / `BennyDesignData`. Screens import, never redefine.
2. **Naming:** primitive (`navy/600`) → semantic (`color.primary`). New tokens go through review.
3. **Versioning:** `benny_style` is a versioned package (`packages/benny_style`); breaking token changes bump the version.
4. **Contribution rule:** need a new color/size? First check the ramp/scale — 95% of the time the value already exists.
5. **Documentation:** visual reference lives in `docs/design/benny_design_system.html`; this file is the written spec.

---

## Quick-reference cheat sheet

| Dimension | Recommended count | This project |
|-----------|-------------------|--------------|
| Color roles | 6 (+1 info) | 6 (Brand, Secondary, Neutral, Success, Warning, Error) |
| Shades per ramp | ~10 (25→900) | 11 (25→900) |
| Total color tokens | ~60–70 | ~66 |
| Type roles | 5–7 | 5 (H1, H2, H3, P, Caption) × 3 sizes |
| Font weights | 2–4 | 3 (400/500/600) |
| Spacing steps | 8–12 (4pt grid) | 12 (0→40) |
| Radius tokens | 3–5 | 4 (0/4/8/16) |
| Button hierarchies | 4–5 | 4 (Primary/Secondary/Tertiary/Ghost) |
| Button color types | n/a | 4 (brand/success/neutral/error) |
| Button sizes | 3 (S/M/L) | padding-driven (add enum if needed) |
| Components | 20–30 | ~25 shipped |
| Min tap target | 44/48 dp | enforce |

---

_Reference systems: Material Design 3 · Apple Human Interface Guidelines · IBM
Carbon · Shopify Polaris · Ant Design Mobile · Atlassian Design System.
Implemented values verified against `packages/benny_style` (June 2026)._
