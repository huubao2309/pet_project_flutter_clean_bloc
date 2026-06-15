import 'package:benny_style/benny_style.dart';
import 'package:benny_style/theme/theme_state.dart';

import '../di/injection.dart';
import 'benny_design_data.dart';

/// Bootstraps the `benny_style` design system.
///
/// Must run during app startup (in [configureDependencies]) before any
/// benny_style widget is built:
///  1. feeds the brand tokens into [BennyStyle.initData];
///  2. registers a [ThemeState] in the shared [getIt] so benny_style widgets
///     can resolve it via `bennyLocator<ThemeState>()`.
abstract final class BennyStyleInitializer {
  static void ensureInitialized() {
    BennyStyle.instance.initData(
      brandSourceColor: BennyDesignData.brandColor,
      dataSourceHeading: BennyDesignData.dataSourceHeading,
      dataSourceParagraph: BennyDesignData.dataSourceParagraph,
      dataSourceCaption: BennyDesignData.dataSourceCaption,
    );

    if (!getIt.isRegistered<ThemeState>()) {
      getIt.registerLazySingleton<ThemeState>(AppTheme.new);
    }
  }
}
