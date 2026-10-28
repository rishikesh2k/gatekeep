import 'package:gatekeep/provider/base_provider.dart';

class HomeProvider extends BaseProvider {
  static const int dashboardTab = 0;
  static const int visitorsTab = 1;
  static const int scanTab = 2;

  int currentIndex = dashboardTab;

  void init() {
    store.loadVisitors();
  }

  void openTab(int index) {
    if (currentIndex == index) return;
    currentIndex = index;
    customNotify();
  }
}
