// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kiosk_events.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebsocketConnectedEvent _$WebsocketConnectedEventFromJson(
    Map<String, dynamic> json) {
  return WebsocketConnectedEvent();
}

SessionCreatedEvent _$SessionCreatedEventFromJson(Map<String, dynamic> json) {
  return SessionCreatedEvent();
}

ScannedEvent _$ScannedEventFromJson(Map<String, dynamic> json) {
  return ScannedEvent(
    value: json['value'] == null
        ? null
        : ScanPayload.fromJson(json['value'] as Map<String, dynamic>),
  );
}

ScanPayload _$ScanPayloadFromJson(Map<String, dynamic> json) {
  return ScanPayload(
    kind: _idKindFromKey(json['kind'] as String),
    dateOfBirth: DateTime.parse(json['dateofbirth'] as String),
    dateOfExpiry: DateTime.parse(json['dateofexpiry'] as String),
    firstNames: json['firstnames'] as String,
    surname: json['surname'] as String,
    gender: _genderFromKey(json['gender'] as String),
    nationality: json['nationality'] as String,
    documentNumber: json['number'] as String,
    over12: _stringToBool(json['over12'] as String),
    over16: _stringToBool(json['over16'] as String),
    over18: _stringToBool(json['over18'] as String),
    over21: _stringToBool(json['over21'] as String),
    over65: _stringToBool(json['over65'] as String),
    personalNumber: json['personalnumber'] as String,
    photo: json['photo'] as String,
  );
}

IrmaSessionSubmittedEvent _$IrmaSessionSubmittedEventFromJson(
    Map<String, dynamic> json) {
  return IrmaSessionSubmittedEvent();
}

IrmaInProgressEvent _$IrmaInProgressEventFromJson(Map<String, dynamic> json) {
  return IrmaInProgressEvent(
    value: json['value'] == null
        ? null
        : IrmaStatusPayload.fromJson(json['value'] as Map<String, dynamic>),
  );
}

IrmaStatusPayload _$IrmaStatusPayloadFromJson(Map<String, dynamic> json) {
  return IrmaStatusPayload(
    status: json['status'] as String,
  );
}

PassportReadEvent _$PassportReadEventFromJson(Map<String, dynamic> json) {
  return PassportReadEvent(
    firstnames: json['firstnames'] as String,
    surname: json['surname'] as String,
    nationality: json['nationality'] as String,
    dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
    personalNumber: json['personalNumber'] as String,
    gender: _genderFromInt(json['gender'] as int),
    signedOn: DateTime.parse(json['signedOn'] as String),
    expires: DateTime.parse(json['expires'] as String),
    image: json['photo'] as String,
  )..type = json['type'] as String;
}

IdCardReadEvent _$IdCardReadEventFromJson(Map<String, dynamic> json) {
  return IdCardReadEvent(
    firstnames: json['firstnames'] as String,
    surname: json['surname'] as String,
    dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
    personalNumber: json['personalNumber'] as String,
    gender: _genderFromInt(json['gender'] as int),
    signedOn: DateTime.parse(json['signedOn'] as String),
    expires: DateTime.parse(json['expires'] as String),
    image: json['photo'] as String,
  )..type = json['type'] as String;
}

DriversLicenseReadEvent _$DriversLicenseReadEventFromJson(
    Map<String, dynamic> json) {
  return DriversLicenseReadEvent(
    fullname: json['fullname'] as String,
    nationality: json['nationality'] as String,
    dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
    licenseNumber: json['licenseNumber'] as String,
    gender: _genderFromInt(json['gender'] as int),
    signedOn: DateTime.parse(json['signedOn'] as String),
    expires: DateTime.parse(json['expires'] as String),
    image: json['photo'] as String,
  )..type = json['type'] as String;
}

MrzEvent _$MrzEventFromJson(Map<String, dynamic> json) {
  return MrzEvent()..type = json['type'] as String;
}

ErrorEvent _$ErrorEventFromJson(Map<String, dynamic> json) {
  return ErrorEvent(
    errorCode: json['errorCode'] as String,
    message: json['message'] as String,
  )..type = json['type'] as String;
}
