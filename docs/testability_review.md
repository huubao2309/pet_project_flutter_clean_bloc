# Testability & Architecture Review

> Companion notes to the unit-test suite added under `test/`. Lists where the
> code was **hard to test** and why, which parts violate **SOLID** / **Clean
> Architecture** in a way that hurts testability, and concrete fixes.
> Intended to be re-verified with Codex — every item cites `file:line`.

**Suite status:** `flutter test` → **376 passing, 0 failing**;
`flutter analyze lib test` → **No issues found**. Added dev deps: `mocktail`,
`fake_async`. `bloc_test` was intentionally NOT added — it conflicts with the
pinned `build_runner 2.15.0` (transitive `test_api` pin), so cubits are tested
directly through their `stream`.

How to reproduce:
```bash
flutter pub get
flutter test            # full suite (376 tests)
flutter analyze lib test
```

---

## Applied fixes (architecture)

Two of the findings below have since been **fixed** in code — re-verify these:

**(A) Network DIP — extracted an `HttpClient` port.** New
`lib/core/network/http_client.dart` declares the transport contract;
`DioClient implements HttpClient` (`lib/core/network/dio_client.dart`); the three
API data sources (`auth`/`user`/`app_update` `*_api_data_source.dart`) now depend
on `HttpClient` (ctor param `httpClient`), not the concrete `DioClient`; DI
registers `getIt.registerSingleton<HttpClient>(DioClient(...))`
(`lib/core/di/injection.dart`). Proof it pays off:
`test/data/datasources/auth_api_data_source_test.dart` fakes a
4-method port (no Dio, no plugins) and covers success / server-error / default-key
/ account-blocked / phone-blocked / logout branches — **9 tests**.

**(B) Localization (finding #5) — typed error codes; presentation maps code →
text.** Final design (the Clean-Architecture-correct one): the data/domain/error
layers are now **framework-free** — they raise a typed `AppErrorCode`
(`lib/core/error/app_error_code.dart`) plus an optional raw backend
`serverMessage`, and never call `.tr()`. Verified:
`grep -rl "import 'package:easy_localization" lib/features/*/data lib/core/error
lib/core/network` → **none**.

- `AppException` now carries `{AppErrorCode code, String? serverMessage}` (no
  resolved `message`); the 7 `exceptions/*.dart` set their default code.
- `ServerException.withCode` → `withStatus(int statusCode, {code, message,
  responseData})`.
- The `auth`/`user` api + mock data sources, `auth_repository_imp.dart` and
  `DioClient._mapDioError` throw `ServerException(code: AppErrorCode.loginFailed,
  message: response.message)` etc. — no `.tr()`.
- **Single** localization point: `lib/core/presentation/app_error_localizer.dart`
  → `AppErrorLocalizer.localize(e)` returns `e.serverMessage ?? e.code.localized`,
  where the exhaustive `AppErrorCode → 'errors.*'.tr()` map lives. The 7 view
  models call it (`AppErrorLocalizer.localize(e)`) when building failure state.

This also resolves error copy at **display time** (correct locale), and makes
data tests assert on a typed code instead of a string — see
`auth_api_data_source_test.dart` (asserts `e.code` / `e.serverMessage`, **no**
EasyLocalization bootstrap) and `app_exception_test.dart` (now framework-free).

The reusable `LocalizationTestHarness` (added earlier) is still the way to make
`.tr()` resolve in tests that DO localize — `useKeys()` /
`useRealTranslations()` / `useFake({...})` + `wrap(child)`. It now backs the
presentation-side tests: `app_error_localizer_test.dart` (real translations →
asserts `Đăng nhập thất bại`, `Lỗi máy chủ`) and `widget_test.dart`.

---

## Severity legend

- **H** — blocks unit testing of real logic; forced a skip or a brittle workaround.
- **M** — testable, but only via a workaround (mocking a concrete class, wall-clock delays, host-dependent assertions).
- **L** — minor smell; tests pass but are fragile or low-value.

---

## Findings

| # | Sev | Location | Principle | Problem |
|---|-----|----------|-----------|---------|
| 1 | H | `lib/environments/env.dart:16-39` | SRP / Command-Query separation | Constructor runs the whole app |
| 2 | H | `lib/core/utils/device_info_util.dart`, `package_info_util.dart` | DIP / ISP | Plugin-bound static singletons, no interface |
| 3 | H | `lib/data/repositories/app_update_repository_impl.dart:29-32,44-50` | DIP | Repo calls `PackageInfo.fromPlatform()` / `launchUrl` directly |
| 4 | H | `lib/data/datasources/scanned_property_resolver.dart` | DIP / OCP | Static-only resolver, cannot be injected/faked |
| 5 | M | `lib/core/error/**` + data sources (22 sites) | Clean Arch (layer leak) | `.tr()` localization called from data/error layers |
| 6 | M | `lib/features/home/.../home_view_model.dart`, `commission_view_model.dart` | Clean Arch / DIP | Business data hardcoded in the View-Model + `Future.delayed` |
| 7 | M | `lib/features/auth/.../otp_view_model.dart:25,_restart()` | SRP / side-effecting ctor | Timer starts inside the constructor |
| 8 | M | `lib/**/presentation/**` (52 files) | DIP (service locator) | Widgets call `getIt<ThemeState>()` inside `build()` |
| 9 | L | `lib/features/profile/.../profile_repository_impl.dart:22-32` | — | `changePassword` returns the future without `await` |
| 10 | L | `lib/data/models/app_update/app_update_config_dto.dart` (`toEntity`) | — | `toEntity()` reads `Platform.isIOS` → host-dependent test |

---

### 1. `Env` constructor bootstraps the entire app — **H**

`lib/environments/env.dart`:

```dart
Env() {
  _bootstrap();        // ← side effect in constructor
}

Future<void> _bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  ...
  await configureDependencies(this);
  ...
  runApp(MyApp(...));  // ← starts the app
}
```

**Why it hurts tests:** instantiating *any* `Env` (or a concrete
`ProductionEnv`/`StagingEnv`/`UatEnv`) triggers binding init, DI registration and
`runApp`. So the env classes cannot be unit-tested in isolation — they were
**skipped**; only `EnvType` (the pure enum) is covered.

**Principle:** a constructor should *construct*, not *execute*. Mixing object
creation with running the program violates SRP and command-query separation.

**Fix:** move bootstrapping out of the constructor into an explicit
`Future<void> start()` (or a top-level `bootstrap(Env env)` function the
`main_*.dart` entry points call). Then `ProductionEnv().baseUrl` etc. become
trivially testable.

---

### 2. `DeviceInfoUtil` / `PackageInfoUtil` are plugin-bound static singletons — **H**

`lib/core/utils/device_info_util.dart`, `lib/core/utils/package_info_util.dart`:

```dart
class DeviceInfoUtil {
  static final DeviceInfoUtil _instance = DeviceInfoUtil._();
  static DeviceInfoUtil get instance => _instance;
  final _deviceInfoPlugin = DeviceInfoPlugin();   // ← hard dependency, no seam
  ...
}
```

**Why it hurts tests:** every getter derives from `device_info_plus` /
`package_info_plus`, which need a platform under `flutter test`. No interface to
implement, and the plugin is created inline (not injected), so there is no seam.
Both util classes were **skipped**.

> Note: `DeviceSessionRepositoryImpl` *does* take `DeviceInfoUtil` via its
> constructor, so I was able to mock it with mocktail (`Mock implements
> DeviceInfoUtil`). That works, but only because mocktail can subclass a
> concrete class — it is a workaround, not a designed seam (still a DIP smell).

**Principle:** DIP — high-level code should depend on an abstraction, not a
concrete plugin wrapper. ISP — expose only what callers need.

**Fix:** define `abstract class DeviceInfo { String? get iosVendorId; ... }` and
`abstract class AppPackageInfo { Future<String> version(); ... }`; implement them
with the plugins; register the abstraction in DI. Callers (e.g.
`AppUpdateRepositoryImpl`, `DeviceSessionRepositoryImpl`) depend on the
interface.

---

### 3. `AppUpdateRepositoryImpl` calls platform APIs directly — **H**

`lib/data/repositories/app_update_repository_impl.dart`:

```dart
Future<String> currentVersion() async {
  final info = await PackageInfo.fromPlatform();   // ← not injected
  return info.version;
}

Future<void> openStore(String url) async {
  if (url.isEmpty) return;
  await launchUrl(Uri.parse(url), ...);            // ← not injected
}
```

**Why it hurts tests:** `currentVersion()` and the non-empty path of
`openStore()` reach `package_info_plus` / `url_launcher`, unavailable in plain
`flutter test`. Only `fetchConfig`, the dismissed-version storage methods and the
`url.isEmpty` early-return are covered; the two plugin paths were **skipped**.

**Principle:** DIP — the same violation as #2, leaking into a repository.

**Fix:** inject the `AppPackageInfo` abstraction (from #2) and a
`UrlLauncher`/`StoreLauncher` port; mock both in tests.

---

### 4. `ScannedPropertyResolver` is a static-only utility — **H**

`lib/data/datasources/scanned_property_resolver.dart`:

```dart
abstract final class ScannedPropertyResolver {
  static ScannedProperty resolve(String code) { ... }   // ← static, hardcoded demo data
}
```

**Why it hurts tests:** the QR-scan page calls `ScannedPropertyResolver.resolve`
statically, so a test of that page cannot substitute a fake resolver. The static
method itself is testable (and is tested), but the *consumer* is not — there is
no seam. When this becomes a real API lookup it will be untestable as written.

**Principle:** DIP / OCP — a `static` collaborator cannot be replaced; depend on
an injectable instance behind an interface instead.

**Fix:** make it an instance class implementing a
`ScannedPropertyRepository` port, registered in DI.

---

### 5. Localization (`.tr()`) in the data and error layers — **M** — ✅ ADDRESSED via test harness (see "Applied fixes (B)"); `.tr()` intentionally kept in production

22 call sites (a `grep '\.tr()'` over the data/error layers returns 23 lines —
one is the doc comment at `app_exception.dart:20`), e.g.:

- `lib/core/error/exceptions/server_exception.dart:11` — `super(message ?? 'errors.server'.tr())`
- `lib/data/repositories/auth_repository_imp.dart:75,153`
- `lib/data/datasources/auth_api_data_source.dart` (7 sites)
- `lib/data/datasources/user_api_data_source.dart:29,43`

**Why it hurts tests:** constructing a `ServerException` (or exercising any data
source / repository error path) invokes easy_localization's context-free
`.tr()`. Under `flutter test` that throws unless the binding + EasyLocalization
are initialized first — so every data/error-layer test needs this boilerplate:

```dart
TestWidgetsFlutterBinding.ensureInitialized();
SharedPreferences.setMockInitialValues({});
await EasyLocalization.ensureInitialized();
```

It also means tests can only assert that the message equals the *translation
key* (`'errors.server'`), never real copy.

**Principle:** Clean Architecture — translation is a presentation concern; the
domain/data layers should not depend on a UI localization framework. An
exception should carry a stable **error code**, and the presentation layer maps
code → localized text.

**Fix:** give `AppException` a `code` (enum/string) and resolve copy at the UI
boundary. Layers below presentation stay framework-free and need no binding setup
to test.

---

### 6. View-Models hardcode business data + simulate latency — **M**

`lib/features/home/presentation/view_model/home_view_model.dart` and
`commission_view_model.dart`:

```dart
Future<void> _load() async {
  setState(const HomeLoading());
  await Future<void>.delayed(const Duration(milliseconds: 500));  // ← wall-clock in tests
  setState(const HomeLoaded(agentName: 'Bảo Nguyễn', ... _mockListings ...));  // ← data baked into VM
}
```

**Why it hurts tests:** there are no injected use cases, so the only assertions
possible are against hardcoded literals (e.g. `agentName == 'Bảo Nguyễn'`,
commission `locationLabel == 'Quận 1'`). Those tests are **brittle** — they break
the moment the placeholder data changes, and they verify nothing about real
behavior. The `Future.delayed` also adds real time to the suite.

**Principle:** Clean Architecture / DIP — a View-Model should orchestrate
injected use cases, not own the data. Today the data layer is bypassed entirely.

**Fix:** inject `GetHomeDashboardUseCase` / `GetNearbyListingsUseCase` (even if
backed by the existing mock data source). Tests then mock the use case and assert
mapping/branching; no `Future.delayed`.

---

### 7. `OtpViewModel` starts a `Timer` in its constructor — **M**

`lib/features/auth/presentation/view_model/otp_view_model.dart:25` → `_restart()`
starts a 1-second periodic `Timer` immediately on construction.

**Why it hurts tests:** merely creating the VM schedules timers, so tests must
wrap construction in `fakeAsync` (added `fake_async` for this) and be careful to
`close()` to avoid "Timer still pending" failures. A side-effecting constructor
is a recurring testability tax.

**Fix:** start the ticker from an explicit `start()`/`initialize()` the View
calls (consistent with the other VMs' `initialize()`), keeping the constructor
pure.

---

### 8. Widgets resolve dependencies via the service locator inside `build()` — **M**

52 presentation files call `getIt<...>()` directly (mostly `getIt<ThemeState>()`),
e.g. `status_badge.dart`, `section_header.dart`, every `*_page.dart`:

```dart
@override
Widget build(BuildContext context) {
  final theme = getIt<ThemeState>();   // ← hidden global dependency
  ...
}
```

**Why it hurts tests:** the dependency is invisible in the widget's API, so any
widget test must register the global `getIt<ThemeState>()` first
(`BennyStyleInitializer.ensureInitialized()`), and tests can never inject a
different theme. This is the Service Locator anti-pattern. It is the main reason
the old `test/widget_test.dart` (which pumped the whole `MyApp`) no longer
compiles/works and had to be replaced with leaf-widget smoke tests.

**Principle:** DIP — depend on injected abstractions, not a global registry read
mid-`build`.

**Fix:** provide `ThemeState` through an `InheritedWidget` / provider at the top
of the tree (the app already uses `ViewModelProvider`); widgets read it from
`context`. Tests then wrap with a test theme.

---

### 9. `ProfileRepositoryImpl.changePassword` doesn't `await` — **L**

`lib/data/repositories/profile_repository_impl.dart:22-32`
returns `_remoteDataSource.changePassword(...)` directly. Functionally fine, but
the error surfaces as a rejected future at a different point than the `await`ed
methods. The test had to stub the throw as `thenAnswer((_) async => throw ...)`
rather than `thenThrow`. Low impact; flagged for consistency.

---

### 10. `AppUpdateConfigDto.toEntity()` is host-dependent — **L**

`toEntity()` picks the store URL via `Platform.isIOS`. The test asserts
`Platform.isIOS ? iosUrl : androidUrl` so it passes on any host, but the
assertion is **conditional on the running OS** rather than deterministic. Prefer
passing the target platform in (or testing both branches via an injected
platform flag).

---

## Honest gaps in the current test suite

These are **not yet covered** (by design, given the issues above) — list them so
Codex doesn't assume full coverage:

1. **Mock data sources** (`auth_mock_data_source.dart`, `user_mock_data_source.dart`,
   `app_update_mock_data_source.dart`) — read `assets/mock/*.json` via
   `rootBundle.loadString` with `static const` scenario switches and a hardcoded
   `Duration(seconds: 1)` latency. The static scenario constants can't be
   parametrized per test, and the 1s latency would slow the suite. Skipped; their
   *contracts* are exercised via mocks in the repository tests.
2. **API data sources** — ✅ now testable via the `HttpClient` port (Applied fix A).
   `auth_api_data_source.dart` is **covered** (9 tests). `user_api_data_source.dart`
   and `app_update_api_data_source.dart` follow the same pattern but are not yet
   written.
3. **Plugin utils** — `device_info_util`, `package_info_util`, `logger_util` (#2).
4. **Concrete `Env` subclasses** (#1).
5. **Pages and most widgets** — only two leaf widgets have smoke tests
   (`StatusBadge`, `SectionHeader`). Full page tests are blocked by #8 and the
   DI-heavy router (`AppRouter` is a concrete class resolved via `getIt`, and its
   route builders call `getIt` for each page's VM).

## Caveats in the tests that DO exist

- **Brittle literal assertions** in `home_view_model_test` / `commission_view_model_test`
  (asserting on placeholder data — see #6).
- **Key-not-copy assertions** for localized messages (see #5): tests check the
  translation *key*, not user-facing text.
- **Cubit stream timing:** `Cubit.emit` delivers to `stream` listeners
  asynchronously, so VM tests insert `await Future<void>.delayed(Duration.zero)`
  before cancelling the subscription to capture the full state sequence. Correct,
  but a pattern reviewers should be aware of (a real `bloc_test` would hide this —
  it's unavailable here due to the `build_runner` conflict).
- **Host-dependent** `app_update_config_dto` test (see #10).

---

## Recommended fix order (highest testability ROI first)

1. **#5** — give `AppException` an error code, drop `.tr()` from data/error
   layers. Removes binding boilerplate from a large swath of tests and fixes a
   real layering violation.
2. **#1** — move `Env` bootstrap out of the constructor. Makes env + (eventually)
   an app-bootstrap test possible.
3. **#2/#3** — interfaces for device/package info + url launcher; inject them.
   Unlocks `AppUpdateRepositoryImpl` and the plugin utils.
4. **#6** — route Home/Commission data through injected use cases. Turns brittle
   literal tests into real behavior tests.
5. **#8** — provide `ThemeState` via context instead of `getIt` in `build`.
   Unlocks widget/page testing.
6. **#7, #4, #9, #10** — smaller, mechanical.

## Checklist for Codex verification

- [ ] `flutter pub get && flutter test` → 367 passing, 0 failing.
- [ ] `flutter analyze test` → no issues.
- [ ] Each `file:line` reference above still matches the cited code.
- [ ] Confirm the "skipped" items (mock/api data sources, plugin utils, env,
      pages) are genuinely absent from `test/` and that the stated reason holds.
- [ ] Spot-check the brittle assertions (#6) and key-not-copy assertions (#5).
