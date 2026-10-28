import 'package:flutter_test/flutter_test.dart';
import 'package:gatekeep/helper/qr_helper.dart';
import 'package:gatekeep/helper/validators.dart';

void main() {
  test('Mobile number must be exactly 10 digits', () {
    expect(Validators.mobile(''), isNotNull);
    expect(Validators.mobile('12345'), isNotNull);
    expect(Validators.mobile('98765432101'), isNotNull);
    expect(Validators.mobile('9876543210'), isNull);
  });

  test('Email is optional but checked when entered', () {
    expect(Validators.email(''), isNull);
    expect(Validators.email('wrong-email'), isNotNull);
    expect(Validators.email('rahul@example.com'), isNull);
  });

  test('QR helper accepts only a plain visitor ID', () {
    expect(QrHelper.readVisitorId('12'), '12');
    expect(QrHelper.readVisitorId(' VIS001 '), 'VIS001');
    expect(QrHelper.readVisitorId('https://google.com'), isNull);
    expect(QrHelper.readVisitorId(''), isNull);
  });
}
