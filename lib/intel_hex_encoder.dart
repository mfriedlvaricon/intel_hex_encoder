library intel_hex_encoder;

import 'dart:convert';
import 'dart:math';
import 'package:convert/convert.dart';

class IntelHexRecord {
  int length;
  int address;
  //00 = more lines to come; 01 = eof
  int type;
  String data;

  IntelHexRecord(this.length, this.address, this.type, this.data);

  static IntelHexRecord eOF() {
    return IntelHexRecord(0, 0, 1, "");
  }

  String _toHex(var value, int padWidth) {
    List<int> bytes = utf8.encode(value.toString());
    print(value.toString() + " to: ");
    print(bytes);
    HexEncoder hexEnc;
    var hexValue = hex.encode(bytes);
    return hexValue.toString().padLeft(padWidth, "0");
  }

  String _getChecksum() {
    int addressValue = address - ((address % 255) * 255);
    int sum = length + addressValue;

    utf8.encode(data).forEach((element) {
      sum += element;
    });

    String checkSum = sum.toRadixString(2);
    //2nd compl.
    checkSum = checkSum.replaceAll("0", "5");
    checkSum = checkSum.replaceAll("1", "0");
    checkSum = checkSum.replaceAll("5", "1");
    //adding one
    int overflow = 1;
    int checkSumValue = 0;
    for (int i = checkSum.length-1; i >= 0; i--) {
      if (overflow == 1) {
        if (checkSum[i] == "1") {
          checkSum = checkSum.replaceRange(i, i+1, "0");
          overflow = 1;
        } else {
          checkSum = checkSum.replaceRange(i, i+1, "1");
          overflow = 0;
        }
      }
      //print("i: " + i.toString() + " > " + checkSum[i] + " pow: " + (checkSum.length - i - 1).toString());
      if (checkSum[i] == "1") {
        checkSumValue += pow(2, checkSum.length - i - 1);
      }
    }
    return checkSumValue.toRadixString(16).padLeft(10, "0").substring(8, 10);
  }

  List<int> _byteAddition(List<int> bytes, List<int> bytesToAdd) {
    List<int> longBytes = bytes.length > bytesToAdd.length ? bytes : bytesToAdd;
    List<int> shortBytes =
        bytes.length > bytesToAdd.length ? bytesToAdd : bytes;

    for (int i = 0; i < longBytes.length; i++) {}
  }

  String getIntelHex() {
    return ":" +
        length.toRadixString(16).padLeft(2, "0") +
        address.toRadixString(16).padLeft(4, "0") +
        type.toRadixString(16).padLeft(2, "0") +
        _toHex(data, length * 2) +
        _getChecksum();
  }
}
