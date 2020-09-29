import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:irmabalie/src/models/kiosk_events.dart';

class IdState extends ChangeNotifier {
  static final IdState _instance = IdState._internal();
  ScanPayload _payload;
  Id _idType = Id.passport;

  factory IdState() {
    return _instance;
  }

  IdState._internal();

  setPayload(ScanPayload payload) {
    _payload = payload;
    _idType = payload.kind;
    notifyListeners();
  }

  ScanPayload getPayload() {
    return _payload;
  }

  setIdType(Id idType) {
    _idType = idType;
  }

  Id getIdType() {
    return _idType;
  }

  String getCode() {
    String result;
    switch (_idType) {
      case Id.idCard:
        result = "idCard";
        break;
      case Id.passport:
        result = "passport";
        break;
      case Id.driversLicense:
        result = "driversLicense";
        break;
    }
    return result;
  }
}

enum Id { idCard, passport, driversLicense }
