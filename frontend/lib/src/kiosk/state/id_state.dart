import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:irmabalie/src/models/kiosk_events.dart';

class IdState extends ChangeNotifier {
  static final IdState _instance = IdState._internal();
  Id idType = Id.idCard;
  PassportReadEvent _passportData = null;
  IdCardReadEvent _idCardData = null;
  DriversLicenseReadEvent _driversLicenseData = null;

  factory IdState() {
    return _instance;
  }

  IdState._internal() {}

  setPassportScanState(PassportReadEvent newData) {
    _passportData = newData;
    idType = Id.passport;
    notifyListeners();
  }

  PassportReadEvent getPassportScanData() {
    return _passportData;
  }

  setIdCardScanState(IdCardReadEvent newData) {
    _idCardData = newData;
    idType = Id.idCard;
    notifyListeners();
  }

  IdCardReadEvent getIdCardScanData() {
    return _idCardData;
  }

  setDriversLicenseScanState(DriversLicenseReadEvent newData) {
    _driversLicenseData = newData;
    idType = Id.driversLicense;
    notifyListeners();
  }

  DriversLicenseReadEvent getDriversLicenseScanData() {
    return _driversLicenseData;
  }

  setId(Id newId) {
    idType = newId;
    notifyListeners();
  }

  String getCode() {
    String result;
    switch (idType) {
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
