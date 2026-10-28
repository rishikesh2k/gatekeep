import 'package:flutter/material.dart';
import 'package:gatekeep/model/visitor.dart';
import 'package:gatekeep/provider/dashboard_provider.dart';
import 'package:gatekeep/provider/home_provider.dart';
import 'package:gatekeep/utils/app_colors.dart';
import 'package:gatekeep/utils/app_constants.dart';
import 'package:gatekeep/utils/app_dimensions.dart';
import 'package:gatekeep/view/base_selector.dart';
import 'package:gatekeep/view/base_view.dart';
import 'package:gatekeep/widgets/dashboard_stat_card.dart';
import 'package:gatekeep/widgets/local_data_banner.dart';
import 'package:gatekeep/widgets/quick_action_tile.dart';
import 'package:gatekeep/widgets/status_chip.dart';
import 'package:gatekeep/widgets/visitor_avatar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final home = context.read<HomeProvider>();

    return BaseView<DashboardProvider>(
      builder: (context) {
        final provider = context.read<DashboardProvider>();
        return Scaffold(
          appBar: AppBar(
            title: const AppTitle(),
            actions: [
              BaseSelector<DashboardProvider, bool>(
                selector: (m) => m.isLoading,
                builder: (context, isLoading) => IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Refresh',
                  onPressed: isLoading ? null : provider.refresh,
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: provider.refresh,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(AppDimensions.medium, 4, AppDimensions.medium, AppDimensions.large),
                children: [
                  const TodayHeader(),
                  const SizedBox(height: AppDimensions.medium),
                  BaseSelector<DashboardProvider, (bool, bool, String?)>(
                    selector: (m) => (m.isLoading, m.isLocalData, m.errorMessage),
                    builder: (context, value) {
                      final (isLoading, isLocalData, errorMessage) = value;
                      
                      if (errorMessage != null) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppDimensions.medium),
                          child: Card(
                            child: ListTile(
                              leading: const Icon(Icons.wifi_off, color: AppColors.danger),
                              title: Text(errorMessage),
                              subtitle: const Text('Numbers may be out of date'),
                              trailing: TextButton(onPressed: provider.refresh, child: const Text('Retry')),
                            ),
                          ),
                        );
                      }
                      if (isLocalData) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: AppDimensions.medium),
                          child: LocalDataBanner(),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SectionTitle(text: 'Quick actions'),
                  Row(
                    children: [
                      Expanded(
                        child: QuickActionTile(
                          label: 'Register\nVisitor',
                          icon: Icons.person_add_alt_1,
                          highlighted: true,
                          onTap: provider.openRegister,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: QuickActionTile(
                          label: 'Scan\nQR Code',
                          icon: Icons.qr_code_scanner,
                          onTap: () => home.openTab(HomeProvider.scanTab),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: QuickActionTile(
                          label: 'Visitor\nList',
                          icon: Icons.people_alt_outlined,
                          onTap: () => home.openTab(HomeProvider.visitorsTab),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.large),
                  Row(
                    children: [
                      const Expanded(child: SectionTitle(text: 'Recent visitors')),
                      TextButton(
                        onPressed: () => home.openTab(HomeProvider.visitorsTab),
                        child: const Text('See all'),
                      ),
                    ],
                  ),
                  BaseSelector<DashboardProvider, List<Visitor>>(
                    selector: (m) => m.recentVisitors,
                    builder: (context, list) {
                      if (list.isEmpty) {
                        return const Card(
                          child: Padding(
                            padding: EdgeInsets.all(AppDimensions.large),
                            child: Center(child: Text('No visitors registered yet')),
                          ),
                        );
                      }
                      return Card(
                        child: Column(
                          children: [
                            for (final visitor in list)
                              ListTile(
                                onTap: () => provider.openDetails(visitor),
                                leading: VisitorAvatar(name: visitor.name, size: 38),
                                title: Text(visitor.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                                subtitle: Text(visitor.project),
                                trailing: StatusChip(status: visitor.status),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.shield_outlined, size: 18, color: AppColors.dark),
        ),
        const SizedBox(width: 10),
        const Text(AppConstants.appName),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;

  const SectionTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
    );
  }
}

class TodayHeader extends StatelessWidget {
  const TodayHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEEE, dd MMM').format(DateTime.now());

    return Container(
      padding: const EdgeInsets.all(AppDimensions.medium),
      decoration: BoxDecoration(color: AppColors.dark, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'FRONT DESK',
            style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.5),
          ),
          const SizedBox(height: 4),
          Text(
            today,
            style: const TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppDimensions.medium),
          BaseSelector<DashboardProvider, (int, int, int)>(
            selector: (m) => (m.totalVisitorsToday, m.currentlyCheckedIn, m.checkedOutToday),
            builder: (context, value) {
              final (totalToday, checkedIn, checkedOutToday) = value;
              return Row(
                children: [
                  Expanded(
                    child: DashboardStatCard(
                      title: 'Total visitors\ntoday',
                      value: totalToday,
                      icon: Icons.groups_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DashboardStatCard(
                      title: 'Currently\nchecked in',
                      value: checkedIn,
                      icon: Icons.login,
                      color: AppColors.checkedInLight,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DashboardStatCard(
                      title: 'Checked out\ntoday',
                      value: checkedOutToday,
                      icon: Icons.logout,
                      color: AppColors.checkedOutLight,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
