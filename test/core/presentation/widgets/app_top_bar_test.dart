import 'package:benny_style/buttons/icon_button/benny_ghost_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/view_model_provider.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/widgets/app_top_bar.dart';
import 'package:pet_project_flutter_clean_bloc/core/storage/local_storage/local_storage.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/theme_view_model.dart';

class _MockLocalStorage extends Mock implements LocalStorage {}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    BennyStyleInitializer.ensureInitialized();
  });

  late _MockLocalStorage storage;

  setUp(() {
    storage = _MockLocalStorage();
    when(() => storage.getThemeMode()).thenReturn('light');
    when(() => storage.setThemeMode(value: any(named: 'value')))
        .thenAnswer((_) async {});
  });

  Future<void> pumpBar(WidgetTester tester, {VoidCallback? onBack}) =>
      tester.pumpWidget(
        MaterialApp(
          home: ViewModelProvider<ThemeViewModel>(
            create: (_) => ThemeViewModel(
              localStorage: storage,
              systemBrightness: Brightness.light,
            ),
            child: Scaffold(
              appBar: AppTopBar(onBack: onBack),
              body: const SizedBox(),
            ),
          ),
        ),
      );

  testWidgets('renders an AppBar with a single back button', (tester) async {
    await pumpBar(tester);

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(BennyGhostIconButton), findsOneWidget);
    expect(tester.widget<AppTopBar>(find.byType(AppTopBar)).preferredSize.height,
        kToolbarHeight,);
  });

  testWidgets('tapping back runs the onBack callback', (tester) async {
    var backs = 0;
    await pumpBar(tester, onBack: () => backs++);

    await tester.tap(find.byType(BennyGhostIconButton));
    await tester.pump();

    expect(backs, 1);
  });
}
