import 'package:flutter/foundation.dart';
import 'package:gatekeep/locator.dart';
import 'package:gatekeep/model/visitor.dart';
import 'package:gatekeep/services/api_exception.dart';
import 'package:gatekeep/services/api_service.dart';

// Shared visitor list. Every page provider listens to it (see BaseProvider).
class VisitorStore extends ChangeNotifier {
  final ApiService api = locator<ApiService>();

  List<Visitor> visitors = [];
  bool isLoading = false;
  String? errorMessage;
  bool isLocalData = false;

  Future<void> loadVisitors() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final result = await api.getVisitors();
      result.sort((a, b) => (b.createdAt ?? DateTime(2000)).compareTo(a.createdAt ?? DateTime(2000)));
      visitors = result;
      isLocalData = api.usingLocalData;
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = 'Something went wrong while loading visitors';
    }
    isLoading = false;
    notifyListeners();
  }

  Visitor? findById(String id) {
    for (final visitor in visitors) {
      if (visitor.id == id) return visitor;
    }
    return null;
  }

  void save(Visitor visitor) {
    isLocalData = api.usingLocalData;
    final index = visitors.indexWhere((v) => v.id == visitor.id);
    if (index == -1) {
      visitors.insert(0, visitor);
    } else {
      visitors[index] = visitor;
    }
    notifyListeners();
  }

  void remove(String id) {
    visitors.removeWhere((v) => v.id == id);
    notifyListeners();
  }
}
