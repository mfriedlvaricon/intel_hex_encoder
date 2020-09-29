import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:intel_hex_encoder/intel_hex_encoder.dart';
import 'dart:math';

void main() {
  test('Testing String to Intel_hex_encoding', () {
    IntelHexRecord record = IntelHexRecord(4, 0, 0, "Test");
    print(record.getIntelHex(true));

    print("Testing hexed Data...");

    record = IntelHexRecord.hexed(0);


    for(int i = 0; i < 250; i++){
      if(record.length + 6 >= 31*6){
        print(record.getIntelHex(true));
        record = IntelHexRecord.hexed(record.address + record.length);
        record.addHexedData((Random().nextDouble() * 0xFFFFFF).toInt().toRadixString(16).toString().padLeft(6,"0"));
      }
      else{
        record.addHexedData((Random().nextDouble() * 0xFFFFFF).toInt().toRadixString(16).toString().padLeft(6,"0"));
      }
    }
    print(record.getIntelHex(true));
    print(IntelHexRecord.eOF().getIntelHex(true));
  });
}
