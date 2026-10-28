import 'package:gatekeep/helper/date_helper.dart';

class DummyVisitors {
  static List<Map<String, dynamic>> build() {
    final now = DateTime.now();
    String at(int hoursAgo) => DateHelper.toApiFormat(now.subtract(Duration(hours: hoursAgo)));

    return [
      {
        'id': 'LV0001',
        'name': 'Rahul Sharma',
        'mobile': '9876543210',
        'email': 'rahul@example.com',
        'visitor_type': 'Customer',
        'project': 'Project A',
        'purpose': 'Site Visit',
        'status': 'Registered',
        'created_at': at(1),
        'check_in_time': null,
        'check_out_time': null,
      },
      {
        'id': 'LV0002',
        'name': 'Priya Nair',
        'mobile': '9845012345',
        'email': null,
        'visitor_type': 'Customer',
        'project': 'Project B',
        'purpose': 'Flat booking discussion',
        'status': 'Checked In',
        'created_at': at(2),
        'check_in_time': at(1),
        'check_out_time': null,
      },
      {
        'id': 'LV0003',
        'name': 'Suresh Kumar',
        'mobile': '9900112233',
        'email': 'suresh@buildmart.in',
        'visitor_type': 'Vendor',
        'project': 'Project C',
        'purpose': 'Cement delivery',
        'status': 'Checked Out',
        'created_at': at(3),
        'check_in_time': at(3),
        'check_out_time': at(2),
      },
      {
        'id': 'LV0004',
        'name': 'Anita Reddy',
        'mobile': '9123456780',
        'email': null,
        'visitor_type': 'Other',
        'project': 'Project A',
        'purpose': 'Interior consultation',
        'status': 'Registered',
        'created_at': at(26),
        'check_in_time': null,
        'check_out_time': null,
      },
    ];
  }
}
