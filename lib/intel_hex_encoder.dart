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
  bool isHexData = false;

  IntelHexRecord(this.length, this.address, this.type, this.data);

  IntelHexRecord.eOF() : this(0,0,1,"");

  IntelHexRecord.hexed(this.address){
    this.length = 0;
    this.address = address;
    this.type = 0;
    this.data = "";
    this.isHexData = true;
  }

  IntelHexRecord.typed(type) : this(0,0,type,"");

  IntelHexRecord.custom(this.length, this.address, this.type, this.data, this.isHexData);

  String _toHex(var value, int padWidth) {
    //No Conversion needed when already hexed
    if(isHexData)
      return data;

    List<int> bytes = utf8.encode(value.toString());
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

  String getIntelHex(bool seperated) {
    return ":" +
        (length.toRadixString(16).padLeft(2, "0") + (seperated ? " " : "") +
        address.toRadixString(16).padLeft(4, "0") + (seperated ? " " : "") +
        type.toRadixString(16).padLeft(2, "0") + (seperated ? " " : "") +
        _toHex(data, length * 2) + (seperated ? " " : "") +
        _getChecksum()).toUpperCase();
  }

  addHexedData(String hexedData){
    data += hexedData;
    length += hexedData.length~/2;
  }
}
