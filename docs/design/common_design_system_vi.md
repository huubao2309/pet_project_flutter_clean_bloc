# Common Design System — Hướng dẫn UI cho App Mobile

> Tài liệu tham chiếu dưới góc nhìn senior designer: một Design System cho mobile
> cần những gì — bao nhiêu màu, bao nhiêu cỡ chữ, button có bao nhiêu kiểu/kích
> thước, spacing, bo góc, và bộ component. Các quy ước thị trường (Material 3,
> Apple HIG, IBM Carbon, Shopify Polaris, Ant Design Mobile) được đối chiếu với
> giá trị **thực tế đang triển khai** trong package `benny_style` của repo này,
> nên đây là một bản spec để build theo — không phải lý thuyết suông.

---

## 0. Design System thực chất là gì?

Design System **không phải** chỉ là một bảng màu và một font chữ. Nó gồm 3 tầng:

| Tầng | Chứa gì | Ví dụ trong repo |
|------|---------|------------------|
| **1. Design Tokens** | Các quyết định nguyên tử: dải màu, type scale, spacing, radius, elevation, motion. Được đặt tên, không hard-code. | `BennyDesignData`, `BennySpacing`, `BennyBorderRadius` |
| **2. Components** | Widget tái sử dụng tiêu thụ token: button, text field, card, chip… | `BennyPrimaryButton`, `BennyTextField`, `BennyCard` |
| **3. Patterns & Guidelines** | Cách ghép component thành flow: form, empty state, loading, error, navigation. | spec màn hình trong `benny_design_system.html` |

**Quy tắc vàng:** một màn hình **không bao giờ** dùng giá trị thô
(`Color(0xFF1A3C5E)`, `fontSize: 14`, `EdgeInsets.all(16)`). Nó dùng **token**.
Token là nguồn chân lý duy nhất; sửa một chỗ, lan ra mọi nơi. Đây chính là lý do
`benny_style` expose mọi thứ qua `ThemeState` / `BennyDesignData`.

Token có hai cấp (chuẩn thị trường, từ Material 3 & Carbon):

- **Primitive / global token** — giá trị scale thô: `navy/600 = #1A3C5E`, `spacing.medium = 16`.
- **Semantic / alias token** — theo ý nghĩa: `color.primary`, `color.danger`,
  `text.body`, `surface.background`. Semantic token *trỏ tới* primitive.
  Màn hình tiêu thụ **semantic token** để khi rebrand chỉ cần trỏ lại alias.

---

## 1. Màu sắc — cần bao nhiêu màu?

### Câu trả lời từ thị trường
Một bảng màu mobile hiện đại **không phải** "5 màu đẹp". Nó là một tập nhỏ các
**vai trò (role)**, mỗi vai trò mở rộng thành một **dải ~10 sắc độ** (25→900).
Đây là quy ước chung của Material 3 (tonal palette), Tailwind, Carbon và Ant Design.

**Bạn cần ~6 vai trò màu:**

| Vai trò | Mục đích | Số sắc độ tối thiểu |
|---------|----------|---------------------|
| **Primary / Brand** | Hành động chính, header, nhận diện thương hiệu | 10–11 |
| **Secondary / Accent** | Điểm nhấn, CTA phụ, nhấn mạnh | 10 |
| **Neutral / Gray** | Chữ, viền, nền, divider, disabled | 10–11 |
| **Success** | Phản hồi tích cực, xác nhận | 10 |
| **Warning** | Cảnh báo, trạng thái chờ | 10 |
| **Error / Danger** | Lỗi, hành động phá hủy | 10 |
| _(tùy chọn)_ Info | Banner thông tin | 10 |

**Tổng số màu thô:** ~6 vai trò × ~10 sắc độ ≈ **60–70 primitive color token**.
Nghe nhiều, nhưng bạn chỉ *thiết kế* ~6 màu gốc; các dải được sinh ra theo công
thức. Mỗi dải có ý nghĩa index giống nhau:

- `25–100` → **nền / surface** nhạt có tông màu
- `200–300` → **viền, divider, disabled**
- `400–500` → màu **tương tác mặc định (resting)**
- `600–700` → **hover / pressed / nhấn mạnh**
- `800–900` → **chữ trên nền sáng**, tương phản sâu

### Repo này dùng gì (`benny_style`)
Đã triển khai sẵn — hãy dùng, đừng tự chế thêm:

**Brand — Navy** (`BennyDesignData.brandColor`), màu thương hiệu `#1A3C5E` tại `600`:
```
25 #F3F6F9 · 50 #E9EFF4 · 100 #D2DFEA · 200 #A6BFD3 · 300 #7A9EBD
400 #3E6B92 · 500 #27557D · 600 #1A3C5E ← brand · 700 #142F49
800 #0E2234 · 900 #081521
```

**Secondary — Amber** (`#E8A020` tại `500`) — điểm nhấn, nút center action nổi
bật, các con số tiền.

**Neutral / Success / Warning / Error** — đầy đủ dải 25→900 trong
`colors/data_source_color.dart`.

### Ánh xạ semantic (build màn hình theo cái này, không dùng hex thô)
| Vai trò semantic | Nguồn token |
|------------------|-------------|
| Nền nút primary | `brand/600` |
| Primary pressed | `brand/700` |
| Accent / tiền | `secondary/500` |
| Chữ body | `neutral/700–900` |
| Chữ phụ | `neutral/500` |
| Viền / divider | `neutral/200–300` |
| Nền disabled | `neutral/100–200` |
| Nền trang | `neutral/25–50` + trắng |
| Success / Warning / Error | nền `*/500`, chữ `*/700`, nền nhạt `*/50` |

> **Dark mode:** app này **cố ý gỡ bỏ dark mode** (branch
> `feature/remove_dark_mode`). Hệ thống hiện là **single light theme**.
> Nếu sau này thêm lại, cách đúng là tạo một *bản ánh xạ semantic thứ hai*
> (cùng component, trỏ lại alias token), tuyệt đối không nhân đôi component.

---

## 2. Typography — cần bao nhiêu cỡ chữ?

### Câu trả lời từ thị trường
Một type scale mobile cần **~6–8 vai trò**, không phải hàng chục. Material 3 có
5 vai trò × 3 size (Display, Headline, Title, Body, Label = 15 style). Apple HIG
có ~11 text style. Điểm cân bằng thực tế là **5–7 role có tên**, mỗi role gắn sẵn
weight + line-height.

### Repo này dùng gì
Một scale gọn **5 vai trò**, mỗi vai trò có 3 size theo thiết bị (`sm` / `md` /
`lg` — breakpoint responsive), font **Figtree**:

| Vai trò | sm | md | lg | Line height (md) | Weight | Dùng cho |
|---------|----|----|----|------------------|--------|----------|
| **H1** | 24 | 28 | 32 | 40 | 600 | Tiêu đề màn hình, hero |
| **H2** | 18 | 20 | 22 | 32 | 600 | Header section |
| **H3** | 14 | 15 | 16 | 22 | 600 | Tiêu đề card, sub-header |
| **P (paragraph)** | 13 | 14 | 15 | 22 | 400–500 | Body, label, link |
| **Caption** | 11 | 12 | 13 | 18 | 400 | Helper text, timestamp, meta |

Nguồn: `font/font_size.dart`, `font/line_height.dart`.

**Weight:** chỉ định nghĩa **3** — `w400` (regular), `w500` (medium),
`w600` (semibold). Đây là chủ ý đúng: hầu hết hệ thống trưởng thành dùng 2–4
weight. Đừng thêm.

**Paragraph có 4 biến thể** (`paragraph/`): `defaultPrimary`, `label`,
`labelLink`, `inlineLink` — cùng size, khác weight/vai trò. Đây là cách để có
link vs. body vs. form-label mà không cần thêm cỡ chữ mới.

**Mẹo nguyên tắc:**
- Line-height ≈ **1.4–1.5×** cỡ chữ cho body, **~1.25×** cho heading (khớp các giá trị trên).
- Không bao giờ hiện quá ~2 cỡ chữ trong cùng một component.
- Cỡ chữ mã hóa thứ bậc; **weight và màu** lo phần tinh chỉnh.

---

## 3. Spacing — lưới 4-point / 8-point

### Câu trả lời từ thị trường
Mọi hệ thống nghiêm túc đều dùng một **đơn vị gốc** (4px) và một scale gần hình
học. Material, Apple, Carbon đều canh theo **lưới 4pt/8pt**. Cần khoảng
**8–12 bước** spacing.

### Repo này dùng gì (`spacing/benny_spacing.dart`)
Scale gốc 4, 12 bước:

```
zero 0 · superTiny 2 · tiny 4 · small 8 · smallX 12 · medium 16
mediumX 20 · large 24 · largeX 28 · largeXX 32 · extraLarge 36 · extraLargeX 40
```

**Quy ước sử dụng:**
| Bước | Dùng điển hình |
|------|----------------|
| 2–4 | Khoảng cách icon–label, padding trong chip |
| 8–12 | Bên trong button/input, padding hàng list |
| 16 | Gutter màn hình & padding card **mặc định** |
| 20–24 | Giữa các section |
| 32–40 | Khối lớn, đầu/cuối màn hình |

> Padding button mặc định trong code = `H 12 / V 8`. Chiều cao text field mặc định = `36`.

---

## 4. Bo góc (border radius)

### Câu trả lời từ thị trường
**3–5 token radius** là đủ: none, small (chip/tag), medium (button/input/card),
large (sheet/modal), full (pill/avatar).

### Repo này dùng gì (`border_radius/benny_border_radius.dart`)
```
zero 0 · small 4 · medium 8 · large 16
```
- **8 (medium)** là mặc định cho **button, input, card** (đã xác nhận trong `benny_button_style.dart`).
- **4 (small)** cho tag/chip.
- **16 (large)** cho bottom sheet / dialog.
- Chỉ thêm `full` (999) nếu bạn dùng nút pill hoặc avatar.

---

## 5. Button — bao nhiêu kiểu & kích thước?

Đây là câu hỏi được hỏi nhiều nhất, nên phần này chi tiết nhất.

### Câu trả lời từ thị trường — hai trục độc lập
1. **Hierarchy / mức nhấn mạnh** (visual weight) — thường **4–5**:
   Primary (filled) · Secondary (tonal/outlined) · Tertiary · Ghost/Text · _(Destructive là một màu, không phải shape thứ 5)_.
2. **Kích thước** — thường **3**: Small · Medium (mặc định) · Large.
   Cộng thêm full-width và icon-only như các modifier.

Vậy ma trận button đầy đủ ≈ **4 hierarchy × 3 size + biến thể icon**.

### Repo này dùng gì
**Hierarchy — 4 biến thể** (mỗi cái là một widget riêng):
| Biến thể | Widget | Diện mạo | Dùng cho |
|----------|--------|----------|----------|
| **Primary** | `BennyPrimaryButton` | Filled brand | Hành động chính duy nhất mỗi màn hình |
| **Secondary** | `BennySecondaryButton` | Tonal / fill nhạt | Hành động thay thế |
| **Tertiary** | `BennyTertiaryButton` | Mờ nhạt, có thể có shadow | Hành động ít nhấn mạnh |
| **Ghost** | `BennyGhostButton` | Text / trong suốt | Inline, cancel, link |

**Color type — 4** (`BaseButtonType`): `brand` · `success` · `neutral` ·
`error`. Đây là cách thể hiện nút **destructive** (error) hoặc **confirm**
(success) mà không cần shape mới — hierarchy × color type.

**Icon button — 4 biến thể tương ứng** (`buttons/icon_button/`): primary /
secondary / tertiary / ghost icon button.

**Modifier:**
- **Full-width vs. wrap** — `isWrapContain` (`false` → giãn ra `double.infinity`).
- **States** — mọi biến thể resolve `active` / `disabled` / `overlay`
  (pressed) qua `WidgetState`. Radius mặc định `8`, padding `H12/V8`, elevation `0`.

**Lưu ý về kích thước:** hệ thống hiện điều khiển size chủ yếu qua **padding +
text style + tap target** thay vì 3 enum size có tên. Nếu cần S/M/L chính thức,
thêm enum `BennyButtonSize { small, medium, large }` ánh xạ tới chiều cao
~**32 / 40 / 48** và padding `H12/H16/H20` — khớp chuẩn thị trường và scale
spacing có sẵn. **Tap target tối thiểu = 44×44 (iOS) / 48×48 (Android)** — không
bao giờ nhỏ hơn, bất kể size hiển thị.

### Nguyên tắc button
- **Một** nút primary mỗi màn hình/section.
- Destructive = color type `error`, thường trên hierarchy Secondary/Ghost (tránh nút filled đỏ to trừ khi đó *chính là* hành động).
- Nút disabled giữ nguyên kích thước layout; không bao giờ gỡ khỏi tree.
- Label = động từ ("Lưu", "Tiếp tục"), Title Case hoặc sentence case — chọn một và giữ nhất quán.

---

## 6. Bộ component (những gì `benny_style` cung cấp)

Một design system mobile thường cần **~20–30 component**. Repo này đã có sẵn một
bộ mạnh — **tái sử dụng, đừng làm lại**:

**Actions:** Primary/Secondary/Tertiary/Ghost button · icon button ·
`BennySelectionDial`.

**Input & selection:** `BennyTextField` · `BennyPhoneTextField` ·
`BennySearchTextField` · `BennyTextArea` · `BennyCheckBox` · `BennyRadio` ·
`BennySwitch` / `BennyLabelSwitch` · `BennyChoiceChip`.

**Containment:** `BennyCard` · `BennyBottomSheet` · `BennyDialog` · `BennyListItem`.

**Feedback & status:** `BennySnackbar` · `BennyInforBar` (timed progress) ·
`SnqdMessage` · `BennyTag` · `BennyCircleProgress` · `BennySpinner` ·
shimmer (`shimmer_helper`).

**Foundations:** colors · typography · spacing · radius · theme state.

### Khoảng trống nên cân nhắc bổ sung (phổ biến ở các hệ thống thị trường, chưa có ở đây)
Avatar · Badge / chấm thông báo · Tab bar / segmented control · Bottom
navigation bar · App bar / top bar · Stepper · Slider · Tooltip · Accordion ·
biến thể Skeleton · template Empty-state · Pull-to-refresh.

---

## 7. Elevation, shadow & motion

| Nhóm token | Chuẩn thị trường | Hướng dẫn cho app này |
|------------|------------------|------------------------|
| **Elevation** | 4–6 cấp (0/1/2/4/8/16) | Chủ yếu phẳng (button elevation `0`). Chỉ dùng shadow cho card, sheet, dialog. |
| **Shadow** | 2–3 shadow có tên (sm/md/lg) | Tertiary button đã expose `isHasShadow`. Định nghĩa `shadow.sm/md/lg`. |
| **Motion** | Duration 100/200/300ms; easing chuẩn | Mặc định **200ms ease-in-out** cho đổi state; **300ms** cho sheet/dialog; tôn trọng reduce-motion. |

---

## 8. Iconography & hình ảnh

- **Lưới icon:** gốc 24×24, một độ dày nét, tối thiểu 2 size (16 / 24), tùy chọn thêm 20 & 32.
- Icon kế thừa màu chữ qua `iconColor` (đã wire sẵn trong button style).
- **Pipeline asset:** `generated/assets.gen.dart` + `fonts.gen.dart` (flutter_gen). Thêm icon/font qua generation, không bao giờ dùng path thô.

---

## 9. Accessibility (không thể thương lượng)

- **Tương phản:** chữ body ≥ **4.5:1**, chữ lớn/icon ≥ **3:1** so với nền. Đặc biệt kiểm tra Navy/Amber trên nền trắng.
- **Tap target:** ≥ **44×44** (iOS) / **48×48** (Android).
- **Co giãn chữ:** hỗ trợ scale font của OS tới ~130%; scale `sm/md/lg` giúp được nhưng phải test reflow.
- **Không chỉ dựa vào màu** để báo state (ghép màu error với icon/chữ).
- **Semantics:** mọi widget tương tác cần label cho screen reader.

---

## 10. Governance — giữ cho hệ thống sống

1. **Nguồn chân lý duy nhất:** mọi token nằm trong `benny_style` / `BennyDesignData`. Màn hình import, không định nghĩa lại.
2. **Đặt tên:** primitive (`navy/600`) → semantic (`color.primary`). Token mới phải qua review.
3. **Versioning:** `benny_style` là package có version (`packages/benny_style`); thay đổi token gây breaking thì bump version.
4. **Quy tắc đóng góp:** cần màu/size mới? Trước tiên kiểm tra dải/scale — 95% trường hợp giá trị đã tồn tại.
5. **Tài liệu:** bản tham chiếu trực quan ở `docs/design/benny_design_system.html`; file này là bản spec dạng chữ.

---

## Bảng tra nhanh

| Hạng mục | Số lượng khuyến nghị | Repo này |
|----------|----------------------|----------|
| Vai trò màu | 6 (+1 info) | 6 (Brand, Secondary, Neutral, Success, Warning, Error) |
| Sắc độ mỗi dải | ~10 (25→900) | 11 (25→900) |
| Tổng color token | ~60–70 | ~66 |
| Vai trò chữ | 5–7 | 5 (H1, H2, H3, P, Caption) × 3 size |
| Font weight | 2–4 | 3 (400/500/600) |
| Bước spacing | 8–12 (lưới 4pt) | 12 (0→40) |
| Token radius | 3–5 | 4 (0/4/8/16) |
| Hierarchy button | 4–5 | 4 (Primary/Secondary/Tertiary/Ghost) |
| Color type button | n/a | 4 (brand/success/neutral/error) |
| Size button | 3 (S/M/L) | điều khiển bằng padding (thêm enum nếu cần) |
| Component | 20–30 | ~25 đã có |
| Tap target tối thiểu | 44/48 dp | cần enforce |

---

_Các hệ thống tham chiếu: Material Design 3 · Apple Human Interface Guidelines ·
IBM Carbon · Shopify Polaris · Ant Design Mobile · Atlassian Design System.
Giá trị triển khai đã đối chiếu với `packages/benny_style` (tháng 6/2026)._
