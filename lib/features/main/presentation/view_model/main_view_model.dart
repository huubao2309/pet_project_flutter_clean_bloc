import '../../../../core/presentation/view_model.dart';
import '../main_tab.dart';

/// Holds the currently selected bottom-navigation tab index.
class MainViewModel extends ViewModel<int> {
  MainViewModel() : super(0);

  final List<MainTab> tabs = const [
    MainTab.home,
    MainTab.history,
    MainTab.qr,
    MainTab.promotion,
    MainTab.profile,
  ];

  void changeTab(int index) {
    if (index < 0 || index >= tabs.length) return;
    setState(index);
  }
}
