import 'package:flutter_test/flutter_test.dart';

import 'package:intel_hex_encoder/intel_hex_encoder.dart';

void main() {
  test('Testing String to Intel_hex_encoding', () {
    IntelHexRecord record = IntelHexRecord(4, 0, 0, "Test");
    print(record.getIntelHex());
  });
}
