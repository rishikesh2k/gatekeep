import 'package:flutter_test/flutter_test.dart';
import 'package:gatekeep/model/visitor.dart';
import 'package:gatekeep/model/visitor_status.dart';

void main() {
  test('Visitor is read from API JSON', () {
    final visitor = Visitor.fromJson({
      'id': 'VIS001',
      'name': 'Rahul Sharma',
      'mobile': '9876543210',
      'email': 'rahul@example.com',
      'visitor_type': 'Customer',
      'project': 'Project A',
      'purpose': 'Site Visit',
      'status': 'Checked In',
      'created_at': '2026-10-26T10:00:00+05:30',
      'check_in_time': '2026-10-26T10:30:00+05:30',
      'check_out_time': null,
    });

    expect(visitor.id, 'VIS001');
    expect(visitor.status, VisitorStatus.checkedIn);
    expect(visitor.checkInTime, isNotNull);
    expect(visitor.checkOutTime, isNull);
  });

  test('Unknown faker status and time values do not crash parsing', () {
    final visitor = Visitor.fromJson({
      'id': 1,
      'name': 'Micheal Lang',
      'mobile': '1-623-743-4123',
      'email': 'Floy.Shields29@hotmail.com',
      'visitor_type': 'payment',
      'project': 'Steel',
      'purpose': 'Pants',
      'status': 505,
      'created_at': 'Africa/Lubumbashi',
      'check_in_time': 'Europe/Mariehamn',
      'check_out_time': 'Pacific/Kiritimati',
    });

    expect(visitor.id, '1');
    expect(visitor.status, VisitorStatus.registered);
    expect(visitor.createdAt, isNull);
    expect(visitor.checkInTime, isNull);
    expect(visitor.checkOutTime, isNull);
  });

  test('New visitor is created with Registered status', () {
    const visitor = Visitor(
      id: '',
      name: 'Asha',
      mobile: '9000000000',
      visitorType: 'Vendor',
      project: 'Project B',
      purpose: 'Delivery',
    );

    final json = visitor.toCreateJson();
    expect(json['status'], 'Registered');
    expect(json['email'], isNull);
    expect(json['check_in_time'], isNull);
    expect(json.containsKey('id'), isFalse);
  });
}
