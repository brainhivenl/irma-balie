import 'package:irmabalie/src/models/event.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kiosk_events.g.dart';

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

  factory PassportReadEvent.fromJson(Map<String, dynamic> json) => _$PassportReadEventFromJson(json);

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

  factory IdCardReadEvent.fromJson(Map<String, dynamic> json) => _$IdCardReadEventFromJson(json);

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

  factory DriversLicenseReadEvent.fromJson(Map<String, dynamic> json) => _$DriversLicenseReadEventFromJson(json);

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

// PingEvent is only for testing, for triggering the backend
@JsonSerializable()
class PingEvent extends WebsocketEvent {
  PingEvent() : super(PingEvent);

  Map<String, dynamic> toJson() => _$PingEventToJson(this);
}

@JsonSerializable(createToJson: false)
class MrzEvent extends WebsocketEvent {
  MrzEvent() : super(MrzEvent);

  factory MrzEvent.fromJson(Map<String, dynamic> json) => _$MrzEventFromJson(json);
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

  factory ErrorEvent.fromJson(Map<String, dynamic> json) => _$ErrorEventFromJson(json);
}

enum Gender {
  male,
  female,
  unknown,
  unspecified,
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
