// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kiosk_events.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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

DriversLicenseReadEvent _$DriversLicenseReadEventFromJson(Map<String, dynamic> json) {
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

PingEvent _$PingEventFromJson(Map<String, dynamic> json) {
  return PingEvent()..type = json['type'] as String;
}

Map<String, dynamic> _$PingEventToJson(PingEvent instance) => <String, dynamic>{
      'type': instance.type,
    };

MrzEvent _$MrzEventFromJson(Map<String, dynamic> json) {
  return MrzEvent()..type = json['type'] as String;
}

ErrorEvent _$ErrorEventFromJson(Map<String, dynamic> json) {
  return ErrorEvent(
    errorCode: json['errorCode'] as String,
    message: json['message'] as String,
  )..type = json['type'] as String;
}
