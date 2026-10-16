import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:irmabalie/src/models/attributes.dart';
import 'package:irmabalie/src/models/credentials.dart';
import 'package:irmabalie/src/models/irma_configuration.dart';
import 'package:irmabalie/src/models/kiosk_events.dart';
import 'package:irmabalie/src/models/translated_value.dart';

class IrmaClientMock {
  static final String mySchemeManagerId = "mySchemeManager";
  static final SchemeManager mySchemeManager = SchemeManager(
    id: mySchemeManagerId,
    name: TranslatedValue({'nl': "My Scheme Manager"}),
    description: TranslatedValue(
        {'nl': "Mocked scheme manager using fake data to render the app."}),
  );
  static final String myIssuerId = mySchemeManagerId + ".myIssuer";
  static final myIssuer = Issuer(
    id: myIssuerId,
    shortName: TranslatedValue({'nl': "MI"}),
    name: TranslatedValue({'nl': "My Issuer"}),
  );
  static final String myCredentialTypeId = myIssuerId + ".myCredentialType";

  static final myPassportCredentialType = CredentialType(
    id: myCredentialTypeId,
    name: TranslatedValue({'nl': "Paspoort", 'en': "Passport"}),
    shortName: TranslatedValue({'nl': "MCT"}),
    description: TranslatedValue({'nl': 'My Credential Type'}),
    schemeManagerId: mySchemeManagerId,
    issuerId: myIssuerId,
    foregroundColor: const Color(0xFF15222E),
    backgroundGradientStart: const Color(0xFFcfeadb),
    backgroundGradientEnd: const Color(0xFFf7e6ac),
  );

  static final myIdCardCredentialType = CredentialType(
    id: myCredentialTypeId,
    name: TranslatedValue({'nl': "Identiteitsbewijs", 'en': "Identity card"}),
    shortName: TranslatedValue({'nl': "MCT"}),
    description: TranslatedValue({'nl': 'My Credential Type'}),
    schemeManagerId: mySchemeManagerId,
    issuerId: myIssuerId,
    foregroundColor: const Color(0xFF15222E),
    backgroundGradientStart: const Color(0xFFcfeadb),
    backgroundGradientEnd: const Color(0xFFf7e6ac),
  );

  static final myDriversLicenseCredentialType = CredentialType(
    id: myCredentialTypeId,
    name: TranslatedValue({'nl': "Rijbewijs", 'en': "Driving licence"}),
    shortName: TranslatedValue({'nl': "MCT"}),
    description: TranslatedValue({'nl': 'My Credential Type'}),
    schemeManagerId: mySchemeManagerId,
    issuerId: myIssuerId,
    foregroundColor: const Color(0xFF15222E),
    backgroundGradientStart: const Color(0xFFf3b9c5),
    backgroundGradientEnd: const Color(0xFFf3b9c5),
  );

  static final String myCredentialFoo = myIssuerId + ".myCredentialFoo";

  final IrmaConfiguration irmaConfiguration = IrmaConfiguration(
    schemeManagers: {mySchemeManagerId: mySchemeManager},
    issuers: {
      myIssuerId: myIssuer,
    },
    attributeTypes: {
      myCredentialFoo + ".fullname": AttributeType(
        schemeManagerId: mySchemeManagerId,
        issuerId: myIssuerId,
        credentialTypeId: myCredentialFoo,
        displayIndex: 1,
        name: TranslatedValue({'nl': "Naam", 'en': "Name"}),
      ),
      myCredentialFoo + ".firstnames": AttributeType(
        schemeManagerId: mySchemeManagerId,
        issuerId: myIssuerId,
        credentialTypeId: myCredentialFoo,
        displayIndex: 1,
        name: TranslatedValue({'nl': "Voornamen", 'en': "Given names"}),
      ),
      myCredentialFoo + ".surname": AttributeType(
        schemeManagerId: mySchemeManagerId,
        issuerId: myIssuerId,
        credentialTypeId: myCredentialFoo,
        displayIndex: 2,
        name: TranslatedValue({'nl': "Achternaam", 'en': "Surname"}),
      ),
      myCredentialFoo + ".nationality": AttributeType(
        schemeManagerId: mySchemeManagerId,
        issuerId: myIssuerId,
        credentialTypeId: myCredentialFoo,
        displayIndex: 3,
        name: TranslatedValue({'nl': "Nationaliteit", 'en': "Nationality"}),
      ),
      myCredentialFoo + ".dateOfBirth": AttributeType(
        schemeManagerId: mySchemeManagerId,
        issuerId: myIssuerId,
        credentialTypeId: myCredentialFoo,
        displayIndex: 4,
        name: TranslatedValue({'nl': "Geboortedatum", 'en': "Date of birth"}),
      ),
      myCredentialFoo + ".personalNumber": AttributeType(
        schemeManagerId: mySchemeManagerId,
        issuerId: myIssuerId,
        credentialTypeId: myCredentialFoo,
        displayIndex: 5,
        name: TranslatedValue({'nl': "BSN", 'en': "BSN"}),
      ),
      myCredentialFoo + ".licenseNumber": AttributeType(
        schemeManagerId: mySchemeManagerId,
        issuerId: myIssuerId,
        credentialTypeId: myCredentialFoo,
        displayIndex: 5,
        name: TranslatedValue(
            {'nl': "Rijbewijsnummer", 'en': "Driving licence number"}),
      ),
      myCredentialFoo + ".gender": AttributeType(
        schemeManagerId: mySchemeManagerId,
        issuerId: myIssuerId,
        credentialTypeId: myCredentialFoo,
        displayIndex: 6,
        name: TranslatedValue({'nl': "Geslacht", 'en': "Sex"}),
      ),
      myCredentialFoo + ".signedOn": AttributeType(
        schemeManagerId: mySchemeManagerId,
        issuerId: myIssuerId,
        credentialTypeId: myCredentialFoo,
        displayIndex: 7,
        name: TranslatedValue({'nl': "Uitgiftedatum", 'en': "Date of issue"}),
      ),
      myCredentialFoo + ".expires": AttributeType(
        schemeManagerId: mySchemeManagerId,
        issuerId: myIssuerId,
        credentialTypeId: myCredentialFoo,
        displayIndex: 8,
        name: TranslatedValue({'nl': "Verloopdatum", 'en': "Expiry date"}),
      ),
      myCredentialFoo + ".portraitPhoto": AttributeType(
        schemeManagerId: mySchemeManagerId,
        issuerId: myIssuerId,
        credentialTypeId: myCredentialFoo,
        displayIndex: 9,
        displayHint: "portraitPhoto",
        name: TranslatedValue({'nl': "Foto", 'en': "Photo"}),
      )
    },
  );

  Credential getPassportCredential(ScanPayload data, String id) {
    return Credential(
      id: id,
      issuer: Issuer(
        id: id,
        name: TranslatedValue({'nl': id}),
      ),
      schemeManager: irmaConfiguration.schemeManagers[mySchemeManagerId],
      signedOn: DateTime.now(),
      expires: data.dateOfExpiry,
      attributes: Attributes({
        irmaConfiguration.attributeTypes[myCredentialFoo + ".firstnames"]:
            TranslatedValue({'nl': data.firstNames}),
        irmaConfiguration.attributeTypes[myCredentialFoo + ".surname"]:
            TranslatedValue({'nl': data.surname}),
        irmaConfiguration.attributeTypes[myCredentialFoo + ".nationality"]:
            TranslatedValue({'nl': data.nationality}),
        irmaConfiguration.attributeTypes[myCredentialFoo + ".dateOfBirth"]:
            TranslatedValue({
          'nl': DateFormat.yMMMMd('nl').format(data.dateOfBirth),
          'en': DateFormat.yMMMMd('en').format(data.dateOfBirth),
        }),
        irmaConfiguration.attributeTypes[myCredentialFoo + ".personalNumber"]:
            TranslatedValue({'nl': data.personalNumber}),
        irmaConfiguration.attributeTypes[myCredentialFoo + ".gender"]:
            TranslatedValue({'nl': data.gender.toIrmaString()}),
        irmaConfiguration.attributeTypes[myCredentialFoo + ".portraitPhoto"]:
            TranslatedValue({'nl': data.photo}),
      }),
      hash: "foobar",
      credentialType: myPassportCredentialType,
    );
  }

  Credential getIdCardCredential(ScanPayload data, String id) {
    return Credential(
      id: id,
      issuer: Issuer(
        id: id,
        name: TranslatedValue({'nl': id}),
      ),
      schemeManager: irmaConfiguration.schemeManagers[mySchemeManagerId],
      signedOn: DateTime.now(),
      expires: data.dateOfExpiry,
      attributes: Attributes({
        irmaConfiguration.attributeTypes[myCredentialFoo + ".firstnames"]:
            TranslatedValue({'nl': data.firstNames}),
        irmaConfiguration.attributeTypes[myCredentialFoo + ".surname"]:
            TranslatedValue({'nl': data.surname}),
        irmaConfiguration.attributeTypes[myCredentialFoo + ".dateOfBirth"]:
            TranslatedValue({
          'nl': DateFormat.yMMMMd('nl').format(data.dateOfBirth),
          'en': DateFormat.yMMMMd('en').format(data.dateOfBirth),
        }),
        irmaConfiguration.attributeTypes[myCredentialFoo + ".personalNumber"]:
            TranslatedValue({'nl': data.personalNumber}),
        irmaConfiguration.attributeTypes[myCredentialFoo + ".gender"]:
            TranslatedValue({'nl': data.gender.toIrmaString()}),
        irmaConfiguration.attributeTypes[myCredentialFoo + ".portraitPhoto"]:
            TranslatedValue({'nl': data.photo}),
      }),
      hash: "foobar",
      credentialType: myIdCardCredentialType,
    );
  }

  Credential getDriversLicenseCredential(ScanPayload data, String id) {
    return Credential(
      id: id,
      issuer: Issuer(
        id: id,
        name: TranslatedValue({'nl': id}),
      ),
      schemeManager: irmaConfiguration.schemeManagers[mySchemeManagerId],
      signedOn: DateTime.now(),
      expires: data.dateOfExpiry,
      attributes: Attributes({
        irmaConfiguration.attributeTypes[myCredentialFoo + ".fullname"]:
            TranslatedValue({'nl': data.firstNames}),
        irmaConfiguration.attributeTypes[myCredentialFoo + ".nationality"]:
            TranslatedValue({'nl': data.nationality}),
        irmaConfiguration.attributeTypes[myCredentialFoo + ".dateOfBirth"]:
            TranslatedValue({
          'nl': DateFormat.yMMMMd('nl').format(data.dateOfBirth),
          'en': DateFormat.yMMMMd('en').format(data.dateOfBirth),
        }),
        irmaConfiguration.attributeTypes[myCredentialFoo + ".licenseNumber"]:
            TranslatedValue({'nl': data.documentNumber}),
        irmaConfiguration.attributeTypes[myCredentialFoo + ".gender"]:
            TranslatedValue({'nl': data.gender.toIrmaString()}),
        irmaConfiguration.attributeTypes[myCredentialFoo + ".portraitPhoto"]:
            TranslatedValue({'nl': data.photo}),
      }),
      hash: "foobar",
      credentialType: myDriversLicenseCredentialType,
    );
  }
}
