import 'package:flutter/material.dart';
import 'package:gatekeep/provider/home_provider.dart';
import 'package:gatekeep/view/base_selector.dart';
import 'package:gatekeep/view/base_view.dart';
import 'package:gatekeep/view/dashboard/dashboard_page.dart';
import 'package:gatekeep/view/qr_scanner/qr_scanner_page.dart';
import 'package:gatekeep/view/visitor_list/visitor_list_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Only the selected tab is built, so the camera closes when leaving Scan.
  Widget buildTab(int index) {
    switch (index) {
      case HomeProvider.visitorsTab:
        return const VisitorListPage();
      case HomeProvider.scanTab:
        return const QrScannerPage();
      default:
        return const DashboardPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeProvider>(
      onModelReady: (provider) => provider.init(),
      builder: (context) {
        final provider = context.read<HomeProvider>();
        return BaseSelector<HomeProvider, int>(
          selector: (m) => m.currentIndex,
          builder: (context, currentIndex) => Scaffold(
            body: buildTab(currentIndex),
            bottomNavigationBar: NavigationBar(
              selectedIndex: currentIndex,
              onDestinationSelected: provider.openTab,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: 'Dashboard',
                ),
                NavigationDestination(
                  icon: Icon(Icons.people_outline),
                  selectedIcon: Icon(Icons.people),
                  label: 'Visitors',
                ),
                NavigationDestination(icon: Icon(Icons.qr_code_scanner), label: 'Scan'),
              ],
            ),
          ),
        );
      },
    );
  }
}
