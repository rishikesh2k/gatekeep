import 'package:flutter_test/flutter_test.dart';
import 'package:gatekeep/helper/shared_prefs.dart';
import 'package:gatekeep/model/visitor.dart';
import 'package:gatekeep/model/visitor_status.dart';
import 'package:gatekeep/services/api_exception.dart';
import 'package:gatekeep/services/local_data_service.dart';
import 'package:gatekeep/utils/dummy_visitors.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late LocalDataService local;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    SharedPrefs.prefs = null;
    await SharedPrefs.init();
    local = LocalDataService();
  });

  test('Dummy visitors are saved on first use', () async {
    final visitors = await local.getVisitors();
    expect(visitors.length, DummyVisitors.build().length);
    expect(SharedPrefs.hasVisitors, isTrue);
  });

  test('Create, update and delete work on local data', () async {
    final created = await local.createVisitor(
      const Visitor(
        id: '',
        name: 'Kiran',
        mobile: '9000000001',
        visitorType: 'Vendor',
        project: 'Project C',
        purpose: 'Delivery',
      ),
    );
    expect(created.id, isNotEmpty);
    expect(created.status, VisitorStatus.registered);

    final updated = await local.updateVisitor(created.id, {'status': 'Checked In'});
    expect(updated.status, VisitorStatus.checkedIn);

    await local.deleteVisitor(created.id);
    expect(() => local.getVisitor(created.id), throwsA(isA<ApiException>()));
  });
}
