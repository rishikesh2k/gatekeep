import 'package:gatekeep/helper/date_helper.dart';
import 'package:gatekeep/model/visitor.dart';
import 'package:gatekeep/model/visitor_status.dart';
import 'package:gatekeep/provider/base_provider.dart';
import 'package:gatekeep/services/navigation_service.dart';
import 'package:gatekeep/utils/app_routes.dart';

class DashboardProvider extends BaseProvider {
  bool get isLoading => store.isLoading;
  String? get errorMessage => store.errorMessage;
  bool get isLocalData => store.isLocalData;

  // Counts are worked out from the list each time, so they never go out of sync.
  int get totalVisitorsToday => store.visitors.where((v) => DateHelper.isToday(v.createdAt)).length;

  int get currentlyCheckedIn => store.visitors.where((v) => v.status == VisitorStatus.checkedIn).length;

  int get checkedOutToday => store.visitors
      .where((v) => v.status == VisitorStatus.checkedOut && DateHelper.isToday(v.checkOutTime))
      .length;

  List<Visitor> get recentVisitors => store.visitors.take(4).toList();

  Future<void> refresh() => store.loadVisitors();

  void openRegister() {
    NavigationService.navigateTo(AppRoutes.visitorFormPage);
  }

  void openDetails(Visitor visitor) {
    NavigationService.navigateTo(AppRoutes.visitorDetailsPage, arguments: visitor.id);
  }
}
