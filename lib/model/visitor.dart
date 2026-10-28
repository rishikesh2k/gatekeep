import 'package:gatekeep/helper/date_helper.dart';
import 'package:gatekeep/model/visitor_status.dart';

class Visitor {
  final String id;
  final String name;
  final String mobile;
  final String? email;
  final String visitorType;
  final String project;
  final String purpose;
  final VisitorStatus status;
  final DateTime? createdAt;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;

  const Visitor({
    required this.id,
    required this.name,
    required this.mobile,
    this.email,
    required this.visitorType,
    required this.project,
    required this.purpose,
    this.status = VisitorStatus.registered,
    this.createdAt,
    this.checkInTime,
    this.checkOutTime,
  });

  factory Visitor.fromJson(Map<String, dynamic> json) {
    return Visitor(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      mobile: json['mobile']?.toString() ?? '',
      email: readEmail(json['email']),
      visitorType: json['visitor_type'] ?? '',
      project: json['project'] ?? '',
      purpose: json['purpose'] ?? '',
      status: VisitorStatus.fromLabel(json['status']?.toString()),
      createdAt: readDate(json['created_at']),
      checkInTime: readDate(json['check_in_time']),
      checkOutTime: readDate(json['check_out_time']),
    );
  }

  // Edit sends only these fields, so status and times are never overwritten.
  Map<String, dynamic> toFormJson() {
    return {
      'name': name,
      'mobile': mobile,
      'email': email,
      'visitor_type': visitorType,
      'project': project,
      'purpose': purpose,
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      ...toFormJson(),
      'status': VisitorStatus.registered.label,
      'created_at': DateHelper.nowForApi(),
      'check_in_time': null,
      'check_out_time': null,
    };
  }

  static String? readEmail(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) {
      return null;
    }
    return value.toString();
  }

  static DateTime? readDate(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return null;
    }
    return DateTime.tryParse(value.toString())?.toLocal();
  }
}
