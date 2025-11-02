import 'package:flutter_test/flutter_test.dart';
import 'package:lenco_flutter/src/utils/msisdn.dart';

void main() {
  group('MsisdnUtils', () {
    test('toMsisdn normalizes various formats to digits-only MSISDN', () {
      expect(MsisdnUtils.toMsisdn('0971234567'), '260971234567');
      expect(MsisdnUtils.toMsisdn('+260971234567'), '260971234567');
      expect(MsisdnUtils.toMsisdn('+260 971 234 567'), '260971234567');
      expect(MsisdnUtils.toMsisdn('097-123-4567'), '260971234567');
    });

    test('detectOperator returns carrier based on prefix where possible', () {
      final op = MsisdnUtils.detectOperator('0971234567');
      expect(op, isNotNull);
    });
  });
}
