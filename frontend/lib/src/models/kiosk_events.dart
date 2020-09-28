import 'package:irmabalie/src/kiosk/state/id_state.dart';
import 'package:irmabalie/src/models/event.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kiosk_events.g.dart';

@JsonSerializable(createToJson: false)
class WebsocketConnectedEvent extends Event {
  WebsocketConnectedEvent();

  static String type = "connected";

  factory WebsocketConnectedEvent.fromJson(Map<String, dynamic> json) =>
      _$WebsocketConnectedEventFromJson(json);
}

class WebsocketDisconnectedEvent extends Event {}

@JsonSerializable(createToJson: false)
class SessionCreatedEvent extends Event {
  SessionCreatedEvent();

  static String type = "created";

  factory SessionCreatedEvent.fromJson(Map<String, dynamic> json) =>
      _$SessionCreatedEventFromJson(json);
}

@JsonSerializable(createToJson: false)
class ScannedEvent extends Event {
  ScannedEvent({
    this.value,
  });

  static String type = "scanned";

  @JsonKey(name: 'value')
  ScanPayload value;

  factory ScannedEvent.fromJson(Map<String, dynamic> json) =>
      _$ScannedEventFromJson(json);
}

@JsonSerializable(createToJson: false)
class ScanPayload {
  ScanPayload({
    this.kind,
    this.dateOfBirth,
    this.dateOfExpiry,
    this.firstNames,
    this.surname,
    this.gender,
    this.nationality,
    this.documentNumber,
    this.over12,
    this.over16,
    this.over18,
    this.over21,
    this.over65,
    this.personalNumber,
    this.photo,
  });

  @JsonKey(name: 'kind', fromJson: _idKindFromKey)
  final Id kind;

  @JsonKey(name: 'dateofbirth', fromJson: DateTime.parse)
  final DateTime dateOfBirth;

  @JsonKey(name: 'dateofexpiry', fromJson: DateTime.parse)
  final DateTime dateOfExpiry;

  @JsonKey(name: 'firstnames')
  final String firstNames;

  @JsonKey(name: 'surname')
  final String surname;

  @JsonKey(name: 'gender', fromJson: _genderFromKey)
  final Gender gender;

  @JsonKey(name: 'nationality')
  final String nationality;

  @JsonKey(name: 'number')
  final String documentNumber;

  @JsonKey(name: 'over12', fromJson: _stringToBool)
  final bool over12;

  @JsonKey(name: 'over16', fromJson: _stringToBool)
  final bool over16;

  @JsonKey(name: 'over18', fromJson: _stringToBool)
  final bool over18;

  @JsonKey(name: 'over21', fromJson: _stringToBool)
  final bool over21;

  @JsonKey(name: 'over65', fromJson: _stringToBool)
  final bool over65;

  @JsonKey(name: 'personalnumber')
  final String personalNumber;

  @JsonKey(name: 'photo')
  final String photo;

  factory ScanPayload.fromJson(Map<String, dynamic> json) =>
      _$ScanPayloadFromJson(json);
}

class IrmaTransferRequestedEvent extends Event {}

class IrmaSessionReceivedEvent extends Event {
  IrmaSessionReceivedEvent({this.data});

  final String data;
}

@JsonSerializable(createToJson: false)
class IrmaSessionSubmittedEvent extends Event {
  IrmaSessionSubmittedEvent();

  static String type = "submitted";

  factory IrmaSessionSubmittedEvent.fromJson(Map<String, dynamic> json) =>
      _$IrmaSessionSubmittedEventFromJson(json);
}

class IrmaSessionSubmitFailedEvent extends Event {
  IrmaSessionSubmitFailedEvent();
}

class WebsocketErrorEvent extends Event {
  WebsocketErrorEvent();
}

@JsonSerializable(createToJson: false)
class IrmaInProgressEvent extends Event {
  IrmaInProgressEvent({
    this.value,
  });

  static String type = "irma-in-progress";

  @JsonKey(name: 'value')
  IrmaStatusPayload value;

  factory IrmaInProgressEvent.fromJson(Map<String, dynamic> json) =>
      _$IrmaInProgressEventFromJson(json);
}

@JsonSerializable(createToJson: false)
class IrmaStatusPayload {
  IrmaStatusPayload({
    this.status,
  });

  @JsonKey(name: 'status')
  final String status;

  factory IrmaStatusPayload.fromJson(Map<String, dynamic> json) =>
      _$IrmaStatusPayloadFromJson(json);
}

abstract class WebsocketEvent extends Event {
  WebsocketEvent(Type type) : type = type.toString();

  @JsonKey(name: 'type')
  String type;
}

@JsonSerializable(createToJson: false)
class PassportReadEvent extends WebsocketEvent {
  PassportReadEvent({
    this.firstnames,
    this.surname,
    this.nationality,
    this.dateOfBirth,
    this.personalNumber,
    this.gender,
    this.signedOn,
    this.expires,
    this.image,
  }) : super(PassportReadEvent);

  @JsonKey(name: 'firstnames')
  final String firstnames;

  @JsonKey(name: 'surname')
  final String surname;

  @JsonKey(name: 'nationality')
  final String nationality;

  @JsonKey(name: 'dateOfBirth', fromJson: DateTime.parse)
  final DateTime dateOfBirth;

  @JsonKey(name: 'personalNumber')
  final String personalNumber;

  @JsonKey(name: 'gender', fromJson: _genderFromInt)
  final Gender gender;

  @JsonKey(name: 'signedOn', fromJson: DateTime.parse)
  final DateTime signedOn;

  @JsonKey(name: 'expires', fromJson: DateTime.parse)
  final DateTime expires;

  @JsonKey(name: 'photo')
  final String image;

  factory PassportReadEvent.fromJson(Map<String, dynamic> json) =>
      _$PassportReadEventFromJson(json);

  static String getGender(Gender gender) {
    switch (gender) {
      case Gender.male:
        return "M";
      case Gender.female:
        return "F";
      default:
        return "X";
    }
  }
}

@JsonSerializable(createToJson: false)
class IdCardReadEvent extends WebsocketEvent {
  IdCardReadEvent({
    this.firstnames,
    this.surname,
    this.dateOfBirth,
    this.personalNumber,
    this.gender,
    this.signedOn,
    this.expires,
    this.image,
  }) : super(PassportReadEvent);

  @JsonKey(name: 'firstnames')
  final String firstnames;

  @JsonKey(name: 'surname')
  final String surname;

  @JsonKey(name: 'dateOfBirth', fromJson: DateTime.parse)
  final DateTime dateOfBirth;

  @JsonKey(name: 'personalNumber')
  final String personalNumber;

  @JsonKey(name: 'gender', fromJson: _genderFromInt)
  final Gender gender;

  @JsonKey(name: 'signedOn', fromJson: DateTime.parse)
  final DateTime signedOn;

  @JsonKey(name: 'expires', fromJson: DateTime.parse)
  final DateTime expires;

  @JsonKey(name: 'photo')
  final String image;

  factory IdCardReadEvent.fromJson(Map<String, dynamic> json) =>
      _$IdCardReadEventFromJson(json);

  static String getGender(Gender gender) {
    switch (gender) {
      case Gender.male:
        return "M";
      case Gender.female:
        return "F";
      default:
        return "X";
    }
  }
}

@JsonSerializable(createToJson: false)
class DriversLicenseReadEvent extends WebsocketEvent {
  DriversLicenseReadEvent({
    this.fullname,
    this.nationality,
    this.dateOfBirth,
    this.licenseNumber,
    this.gender,
    this.signedOn,
    this.expires,
    this.image,
  }) : super(PassportReadEvent);

  @JsonKey(name: 'fullname')
  final String fullname;

  @JsonKey(name: 'nationality')
  final String nationality;

  @JsonKey(name: 'dateOfBirth', fromJson: DateTime.parse)
  final DateTime dateOfBirth;

  @JsonKey(name: 'licenseNumber')
  final String licenseNumber;

  @JsonKey(name: 'gender', fromJson: _genderFromInt)
  final Gender gender;

  @JsonKey(name: 'signedOn', fromJson: DateTime.parse)
  final DateTime signedOn;

  @JsonKey(name: 'expires', fromJson: DateTime.parse)
  final DateTime expires;

  @JsonKey(name: 'photo')
  final String image;

  factory DriversLicenseReadEvent.fromJson(Map<String, dynamic> json) =>
      _$DriversLicenseReadEventFromJson(json);

  static String getGender(Gender gender) {
    switch (gender) {
      case Gender.male:
        return "M";
      case Gender.female:
        return "F";
      default:
        return "X";
    }
  }
}

@JsonSerializable(createToJson: false)
class MrzEvent extends WebsocketEvent {
  MrzEvent() : super(MrzEvent);

  factory MrzEvent.fromJson(Map<String, dynamic> json) =>
      _$MrzEventFromJson(json);
}

@JsonSerializable(createToJson: false)
class ErrorEvent extends WebsocketEvent {
  ErrorEvent({
    this.errorCode,
    this.message,
  }) : super(ErrorEvent);

  @JsonKey(name: 'errorCode')
  final String errorCode;

  @JsonKey(name: 'message')
  final String message;

  factory ErrorEvent.fromJson(Map<String, dynamic> json) =>
      _$ErrorEventFromJson(json);
}

enum Gender {
  male,
  female,
  unknown,
  unspecified,
}

Gender _genderFromKey(String gender) {
  switch (gender) {
    case 'M':
      return Gender.male;
    case 'F':
      return Gender.female;
    case 'X':
      return Gender.unspecified;
    default:
      return Gender.unknown;
  }
}

Gender _genderFromInt(int iso19794Gender) {
  switch (iso19794Gender) {
    case 0x00:
      return Gender.unspecified;
    case 0x01:
      return Gender.male;
    case 0x02:
      return Gender.female;
    case 0xff:
      return Gender.unknown;
  }

  return Gender.unknown;
}

Id _idKindFromKey(String kind) {
  switch (kind) {
    case 'P':
      return Id.passport;
    case 'I':
      return Id.idCard;
    case 'R':
      return Id.driversLicense;
    default:
      throw new ArgumentError("Invalid id type found: $kind");
  }
}

bool _stringToBool(String b) {
  switch (b) {
    case 'yes':
      return true;
    case 'no':
      return false;
    default:
      throw new ArgumentError("Invalid string boolean: $b");
  }
}
