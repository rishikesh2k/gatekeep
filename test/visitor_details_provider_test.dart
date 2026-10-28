import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatekeep/helper/dio_client.dart';
import 'package:gatekeep/locator.dart';
import 'package:gatekeep/model/visitor.dart';
import 'package:gatekeep/model/visitor_status.dart';
import 'package:gatekeep/provider/dashboard_provider.dart';
import 'package:gatekeep/provider/visitor_details_provider.dart';
import 'package:gatekeep/provider/visitor_list_provider.dart';
import 'package:gatekeep/services/api_exception.dart';
import 'package:gatekeep/services/api_service.dart';
import 'package:gatekeep/services/local_data_service.dart';
import 'package:gatekeep/services/visitor_store.dart';

/// Keeps visitors in memory instead of calling the real API.
class FakeApiService extends ApiService {
  final Map<String, Map<String, dynamic>> records = {};

  void add(String id, String status) {
    records[id] = {
      'id': id,
      'name': 'Visitor $id',
      'mobile': '9876543210',
      'visitor_type': 'Customer',
      'project': 'Project A',
      'purpose': 'Site Visit',
      'status': status,
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  @override
  Future<List<Visitor>> getVisitors() async {
    return records.values.map(Visitor.fromJson).toList();
  }

  @override
  Future<Visitor> getVisitor(String id) async {
    final record = records[id];
    if (record == null) {
      throw ApiException('Visitor not found', statusCode: 404);
    }
    return Visitor.fromJson(record);
  }

  @override
  Future<Visitor> updateVisitor(String id, Map<String, dynamic> data) async {
    records[id]!.addAll(data);
    return Visitor.fromJson(records[id]!);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeApiService api;
  late DashboardProvider dashboard;

  /// Details provider for one visitor, same as opening the details page.
  VisitorDetailsProvider details(String id) => locator<VisitorDetailsProvider>()..configure(id);

  setUp(() async {
    await locator.reset();
    locator.registerLazySingleton<Dio>(() => Dio());
    locator.registerLazySingleton<DioClient>(() => DioClient());
    locator.registerLazySingleton<LocalDataService>(() => LocalDataService());
    api = FakeApiService();
    api.add('1', 'Registered');
    api.add('2', 'Checked In');
    api.add('3', 'Checked Out');
    locator.registerSingleton<ApiService>(api);
    locator.registerLazySingleton<VisitorStore>(() => VisitorStore());
    locator.registerFactory(() => DashboardProvider());
    locator.registerFactory(() => VisitorListProvider());
    locator.registerFactory(() => VisitorDetailsProvider());

    await locator<VisitorStore>().loadVisitors();
    dashboard = locator<DashboardProvider>();
  });

  test('Dashboard counts come from the loaded list', () {
    expect(dashboard.totalVisitorsToday, 3);
    expect(dashboard.currentlyCheckedIn, 1);
  });

  test('Check-in moves Registered to Checked In and updates the dashboard', () async {
    await details('1').checkIn();
    final visitor = locator<VisitorStore>().findById('1')!;
    expect(visitor.status, VisitorStatus.checkedIn);
    expect(visitor.checkInTime, isNotNull);
    expect(dashboard.currentlyCheckedIn, 2);
  });

  test('Cannot check in twice', () async {
    expect(() => details('2').checkIn(), throwsA(isA<ApiException>()));
  });

  test('Cannot check out before check-in', () async {
    expect(() => details('1').checkOut(), throwsA(isA<ApiException>()));
  });

  test('Completed visit cannot be checked in again', () async {
    expect(() => details('3').checkIn(), throwsA(isA<ApiException>()));
  });

  test('Check-out updates the checked out today count', () async {
    await details('2').checkOut();
    expect(dashboard.currentlyCheckedIn, 0);
    expect(dashboard.checkedOutToday, 1);
  });

  test('Search works by name and mobile', () {
    final list = locator<VisitorListProvider>();
    list.setSearchQuery('Visitor 2');
    expect(list.filteredVisitors.length, 1);
    list.setSearchQuery('98765');
    expect(list.filteredVisitors.length, 3);
  });
}
