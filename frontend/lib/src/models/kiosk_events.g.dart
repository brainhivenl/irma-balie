// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kiosk_events.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebsocketConnectedEvent _$WebsocketConnectedEventFromJson(
    Map<String, dynamic> json) {
  return WebsocketConnectedEvent();
}

DetectedEvent _$DetectedEventFromJson(Map<String, dynamic> json) {
  return DetectedEvent();
}

ReinsertEvent _$ReinsertEventFromJson(Map<String, dynamic> json) {
  return ReinsertEvent();
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
