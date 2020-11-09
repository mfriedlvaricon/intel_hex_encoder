import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:intel_hex_encoder/intel_hex_encoder.dart';
import 'dart:math';

void main() {
  test('Testing String to Intel_hex_encoding', () {
    IntelHexRecord record;

    print("Testing hexed Data...");

    //Example with 30 x 4 Bytes of Data creating a sequence of 30 parts separated with type 55
    for (int s = 0; s < 30; s++) {
      record = IntelHexRecord.hexed(0);
      for (int i = 0; i < 30; i++) {
        if (i == 25) {
          print(record.getIntelHex(false));
          record = IntelHexRecord.hexed(record.address + record.length);
        }

        if (s == i) {
          record.addHexedData("FF000000");
        } else {
          record.addHexedData("00000000");
        }
      }
      print(record.getIntelHex(false));
      //Adding Type 0x55 -> decimal 85
      if (s != 29) print(IntelHexRecord.typed(85).getIntelHex(false));
    }
    print(IntelHexRecord.eOF().getIntelHex(false));
  });

  print(
      "----------------------------------------------------Rainbowtest----------------------------------------------------");

  IntelHexRecord record;

  //0-255
  int wheelPos = 0;

  for (int s = 0; s < 30; s++) {
    record = IntelHexRecord.hexed(0);
    for (int i = 0; i < 30; i++) {
      if (i == 25) {
        print(record.getIntelHex(true));
        record = IntelHexRecord.hexed(record.address + record.length);
      }

      String color = "";
      wheelPos = wheelPos > 255 ? 0 : wheelPos;

      if (wheelPos < 85) {
        color = ((wheelPos) * 1).toRadixString(16).padLeft(2,"0");
        color += ((255 - wheelPos) * 1).toRadixString(16).padLeft(2,"0");
        color += "00";
      } else if (wheelPos < 170) {
        color = ((255 - wheelPos) * 1).toRadixString(16).padLeft(2,"0");
        color += "00";
        color += ((wheelPos) * 1).toRadixString(16).padLeft(2,"0");
      } else {
        color = "00";
        color += ((wheelPos) * 1).toRadixString(16).padLeft(2,"0");
        color += ((255 - wheelPos) * 1).toRadixString(16).padLeft(2,"0");
      }

      //Adding white to RGBW
      color += "00";
      if(color.length != 8) print("SOMETHING IS WRONG " + color);
      wheelPos++;

      record.addHexedData(color);
    }
    print(record.getIntelHex(false));
    if (s != 29) print(IntelHexRecord.typed(85).getIntelHex(false));
  }
  print(IntelHexRecord.eOF().getIntelHex(false));
}
