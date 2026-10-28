import 'package:flutter/material.dart';
import 'package:gatekeep/model/visitor.dart';
import 'package:gatekeep/model/visitor_status.dart';
import 'package:gatekeep/provider/base_provider.dart';
import 'package:gatekeep/services/navigation_service.dart';
import 'package:gatekeep/utils/app_routes.dart';

class VisitorListProvider extends BaseProvider {
  final TextEditingController searchController = TextEditingController();

  String searchQuery = '';
  VisitorStatus? statusFilter;

  bool get isLoading => store.isLoading;
  String? get errorMessage => store.errorMessage;
  bool get isLocalData => store.isLocalData;
  bool get hasVisitors => store.visitors.isNotEmpty;

  List<Visitor> get filteredVisitors {
    final query = searchQuery.trim().toLowerCase();
    return store.visitors.where((visitor) {
      final matchesSearch =
          query.isEmpty || visitor.name.toLowerCase().contains(query) || visitor.mobile.contains(query);
      final matchesStatus = statusFilter == null || visitor.status == statusFilter;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  void setSearchQuery(String value) {
    searchQuery = value;
    customNotify();
  }

  void clearSearch() {
    searchController.clear();
    setSearchQuery('');
  }

  void setStatusFilter(VisitorStatus? status) {
    statusFilter = status;
    customNotify();
  }

  Future<void> refresh() => store.loadVisitors();

  void openDetails(Visitor visitor) {
    NavigationService.navigateTo(AppRoutes.visitorDetailsPage, arguments: visitor.id);
  }

  void openForm([Visitor? visitor]) {
    NavigationService.navigateTo(AppRoutes.visitorFormPage, arguments: visitor);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
