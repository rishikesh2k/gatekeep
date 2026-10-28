import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:gatekeep/helper/app_message.dart';
import 'package:gatekeep/locator.dart';
import 'package:gatekeep/model/visitor.dart';
import 'package:gatekeep/services/api_exception.dart';
import 'package:gatekeep/services/api_service.dart';
import 'package:gatekeep/services/visitor_store.dart';
import 'package:gatekeep/widgets/app_confirm_dialog.dart';

enum ViewState { idle, busy }

class BaseProvider extends ChangeNotifier {
  final ApiService api = locator<ApiService>();
  final VisitorStore store = locator<VisitorStore>();

  ViewState state = ViewState.idle;
  bool isDisposed = false;
  bool notifyScheduled = false;

  BaseProvider() {
    store.addListener(customNotify);
  }

  bool get busy => state == ViewState.busy;

  void setState(ViewState viewState) {
    state = viewState;
    customNotify();
  }

  void setBusy(bool value) {
    if (busy == value) return;
    setState(value ? ViewState.busy : ViewState.idle);
  }

  Future<R> runBusy<R>(Future<R> Function() work) async {
    setBusy(true);
    try {
      return await work();
    } finally {
      setBusy(false);
    }
  }

  Future<bool> deleteVisitor(Visitor visitor) async {
    final confirmed = await AppConfirmDialog.show(
      title: 'Delete Visitor',
      message: 'Are you sure you want to delete ${visitor.name}? This cannot be undone.',
    );
    if (!confirmed) return false;

    try {
      await api.deleteVisitor(visitor.id);
      store.remove(visitor.id);
      AppMessage.success('Visitor deleted');
      return true;
    } on ApiException catch (e) {
      AppMessage.error(e.message);
      return false;
    }
  }

  // Waits for the next frame if called during build.
  void customNotify() {
    if (isDisposed) return;

    final phase = SchedulerBinding.instance.schedulerPhase;
    if (phase == SchedulerPhase.idle || phase == SchedulerPhase.postFrameCallbacks) {
      notifyListeners();
      return;
    }
    if (notifyScheduled) return;
    notifyScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      notifyScheduled = false;
      if (!isDisposed) notifyListeners();
    });
  }

  @override
  void dispose() {
    if (isDisposed) return;
    isDisposed = true;
    store.removeListener(customNotify);
    super.dispose();
  }
}
