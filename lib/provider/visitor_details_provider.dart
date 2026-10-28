import 'package:gatekeep/helper/app_message.dart';
import 'package:gatekeep/helper/date_helper.dart';
import 'package:gatekeep/model/visitor.dart';
import 'package:gatekeep/model/visitor_status.dart';
import 'package:gatekeep/provider/base_provider.dart';
import 'package:gatekeep/services/api_exception.dart';
import 'package:gatekeep/services/navigation_service.dart';
import 'package:gatekeep/utils/app_routes.dart';

class VisitorDetailsProvider extends BaseProvider {
  String visitorId = '';

  bool isUpdating = false;

  Visitor? get visitor => store.findById(visitorId);

  void configure(String id) {
    visitorId = id;
  }

  Future<void> refresh() async {
    try {
      store.save(await api.getVisitor(visitorId));
    } on ApiException catch (e) {
      AppMessage.error(e.message);
    }
  }

  Future<void> updateStatus() async {
    final current = visitor;
    if (current == null) return;
    try {
      if (current.status == VisitorStatus.registered) {
        await checkIn();
        AppMessage.success('${current.name} checked in');
      } else if (current.status == VisitorStatus.checkedIn) {
        await checkOut();
        AppMessage.success('${current.name} checked out');
      }
    } on ApiException catch (e) {
      AppMessage.error(e.message);
    }
  }

  Future<Visitor> checkIn() {
    return changeStatus(
      allowedFrom: VisitorStatus.registered,
      newStatus: VisitorStatus.checkedIn,
      timeField: 'check_in_time',
    );
  }

  Future<Visitor> checkOut() {
    return changeStatus(
      allowedFrom: VisitorStatus.checkedIn,
      newStatus: VisitorStatus.checkedOut,
      timeField: 'check_out_time',
    );
  }

  // Reads the latest status from the server first, so a visitor already
  // checked in on another phone can't be checked in again.
  Future<Visitor> changeStatus({
    required VisitorStatus allowedFrom,
    required VisitorStatus newStatus,
    required String timeField,
  }) async {
    if (isUpdating) {
      throw ApiException('Please wait, update already in progress');
    }
    isUpdating = true;
    customNotify();

    try {
      final latest = await api.getVisitor(visitorId);
      if (latest.status != allowedFrom) {
        store.save(latest);
        throw ApiException(statusErrorMessage(latest.status, newStatus));
      }
      final updated = await api.updateVisitor(visitorId, {
        'status': newStatus.label,
        timeField: DateHelper.nowForApi(),
      });
      store.save(updated);
      return updated;
    } finally {
      isUpdating = false;
      customNotify();
    }
  }

  String statusErrorMessage(VisitorStatus current, VisitorStatus wanted) {
    if (wanted == VisitorStatus.checkedIn) {
      if (current == VisitorStatus.checkedIn) return 'Visitor is already checked in';
      return 'This visit is already completed';
    }
    if (current == VisitorStatus.registered) return 'Visitor must check in before checking out';
    return 'Visitor is already checked out';
  }

  void openEdit() {
    NavigationService.navigateTo(AppRoutes.visitorFormPage, arguments: visitor);
  }

  Future<void> delete() async {
    final current = visitor;
    if (current == null) return;
    final deleted = await deleteVisitor(current);
    if (deleted) NavigationService.goBack();
  }
}
