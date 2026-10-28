import 'package:flutter/material.dart';
import 'package:gatekeep/helper/date_helper.dart';
import 'package:gatekeep/model/visitor.dart';
import 'package:gatekeep/model/visitor_status.dart';
import 'package:gatekeep/provider/visitor_details_provider.dart';
import 'package:gatekeep/utils/app_colors.dart';
import 'package:gatekeep/utils/app_dimensions.dart';
import 'package:gatekeep/view/base_selector.dart';
import 'package:gatekeep/view/base_view.dart';
import 'package:gatekeep/widgets/custom_button.dart';
import 'package:gatekeep/widgets/empty_state_widget.dart';
import 'package:gatekeep/widgets/info_row.dart';
import 'package:gatekeep/widgets/status_chip.dart';
import 'package:gatekeep/widgets/visitor_avatar.dart';
import 'package:gatekeep/widgets/visitor_qr_code.dart';
import 'package:provider/provider.dart';

class VisitorDetailsPage extends StatelessWidget {
  final String visitorId;

  const VisitorDetailsPage({super.key, required this.visitorId});

  @override
  Widget build(BuildContext context) {
    return BaseView<VisitorDetailsProvider>(
      onModelReady: (provider) => provider.configure(visitorId),
      builder: (context) {
        final provider = context.read<VisitorDetailsProvider>();
        return BaseSelector<VisitorDetailsProvider, Visitor?>(
          selector: (m) => m.visitor,
          builder: (context, visitor) {
            if (visitor == null) {
              return Scaffold(
                appBar: AppBar(title: const Text('Visitor')),
                body: EmptyStateWidget(
                  icon: Icons.person_off_outlined,
                  title: 'Visitor not found',
                  message: 'This visitor may have been deleted.',
                  buttonText: 'Try Again',
                  onPressed: provider.refresh,
                ),
              );
            }

            return Scaffold(
              appBar: AppBar(
                title: const Text('Visitor'),
                actions: [
                  IconButton(icon: const Icon(Icons.edit_outlined), tooltip: 'Edit', onPressed: provider.openEdit),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Delete',
                    color: AppColors.danger,
                    onPressed: provider.delete,
                  ),
                ],
              ),
              bottomNavigationBar: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(AppDimensions.medium, AppDimensions.small, AppDimensions.medium, AppDimensions.medium),
                  child: BaseSelector<VisitorDetailsProvider, bool>(
                    selector: (m) => m.isUpdating,
                    builder: (context, isUpdating) => StatusActionButton(
                      status: visitor.status,
                      isUpdating: isUpdating,
                      onPressed: provider.updateStatus,
                    ),
                  ),
                ),
              ),
              body: RefreshIndicator(
                onRefresh: provider.refresh,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(AppDimensions.medium, 4, AppDimensions.medium, AppDimensions.medium),
                  children: [
                    ProfileHeader(visitor: visitor),
                    const SizedBox(height: AppDimensions.medium),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimensions.medium),
                        child: Column(
                          children: [
                            const Text('VISITOR PASS', style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                            const SizedBox(height: 12),
                            VisitorQrCode(visitorId: visitor.id, size: 180),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.medium),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.medium, vertical: 6),
                        child: Column(
                          children: [
                            InfoRow(icon: Icons.email_outlined, label: 'Email', value: visitor.email ?? 'Not provided'),
                            InfoRow(icon: Icons.badge_outlined, label: 'Visitor type', value: visitor.visitorType),
                            InfoRow(icon: Icons.apartment_outlined, label: 'Project', value: visitor.project),
                            InfoRow(icon: Icons.notes_outlined, label: 'Purpose', value: visitor.purpose),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.medium),
                    VisitTimesCard(visitor: visitor),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final Visitor visitor;

  const ProfileHeader({super.key, required this.visitor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.medium),
      decoration: BoxDecoration(color: AppColors.dark, borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          VisitorAvatar(name: visitor.name, size: 54, onDark: true),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  visitor.name,
                  style: const TextStyle(color: AppColors.white, fontSize: 19, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(visitor.mobile, style: TextStyle(color: AppColors.white.withValues(alpha: 0.7))),
                const SizedBox(height: 8),
                StatusChip(status: visitor.status),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VisitTimesCard extends StatelessWidget {
  final Visitor visitor;

  const VisitTimesCard({super.key, required this.visitor});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.medium, vertical: 6),
        child: Column(
          children: [
            InfoRow(icon: Icons.event_note, label: 'Registered', value: DateHelper.display(visitor.createdAt)),
            if (visitor.checkInTime != null)
              InfoRow(icon: Icons.login, label: 'Checked in', value: DateHelper.display(visitor.checkInTime)),
            if (visitor.checkOutTime != null)
              InfoRow(icon: Icons.logout, label: 'Checked out', value: DateHelper.display(visitor.checkOutTime)),
          ],
        ),
      ),
    );
  }
}

class StatusActionButton extends StatelessWidget {
  final VisitorStatus status;
  final bool isUpdating;
  final VoidCallback onPressed;

  const StatusActionButton({super.key, required this.status, required this.isUpdating, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case VisitorStatus.registered:
        return CustomButton(
          text: 'Check In',
          icon: Icons.login,
          color: AppColors.checkedIn,
          isLoading: isUpdating,
          onPressed: onPressed,
        );
      case VisitorStatus.checkedIn:
        return CustomButton(
          text: 'Check Out',
          icon: Icons.logout,
          color: AppColors.checkOutButton,
          isLoading: isUpdating,
          onPressed: onPressed,
        );
      case VisitorStatus.checkedOut:
        return const CustomButton(text: 'Visit Completed', icon: Icons.task_alt, onPressed: null);
    }
  }
}
