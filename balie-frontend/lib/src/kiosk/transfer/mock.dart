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
    description: TranslatedValue({'nl': "Mocked scheme manager using fake data to render the app."}),
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
    name: TranslatedValue({'nl': "Paspoort"}),
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
    name: TranslatedValue({'nl': "Identiteitsbewijs"}),
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
    name: TranslatedValue({'nl': "Rijbewijs"}),
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
        name: TranslatedValue({'nl': "Naam"}),
      ),
      myCredentialFoo + ".firstnames": AttributeType(
        schemeManagerId: mySchemeManagerId,
        issuerId: myIssuerId,
        credentialTypeId: myCredentialFoo,
        displayIndex: 1,
        name: TranslatedValue({'nl': "Voornamen"}),
      ),
      myCredentialFoo + ".surname": AttributeType(
        schemeManagerId: mySchemeManagerId,
        issuerId: myIssuerId,
        credentialTypeId: myCredentialFoo,
        displayIndex: 2,
        name: TranslatedValue({'nl': "Achternaam"}),
      ),
      myCredentialFoo + ".nationality": AttributeType(
        schemeManagerId: mySchemeManagerId,
        issuerId: myIssuerId,
        credentialTypeId: myCredentialFoo,
        displayIndex: 3,
        name: TranslatedValue({'nl': "Nationaliteit"}),
      ),
      myCredentialFoo + ".dateOfBirth": AttributeType(
        schemeManagerId: mySchemeManagerId,
        issuerId: myIssuerId,
        credentialTypeId: myCredentialFoo,
        displayIndex: 4,
        name: TranslatedValue({'nl': "Geboortedatum"}),
      ),
      myCredentialFoo + ".personalNumber": AttributeType(
        schemeManagerId: mySchemeManagerId,
        issuerId: myIssuerId,
        credentialTypeId: myCredentialFoo,
        displayIndex: 5,
        name: TranslatedValue({'nl': "BSN"}),
      ),
      myCredentialFoo + ".licenseNumber": AttributeType(
        schemeManagerId: mySchemeManagerId,
        issuerId: myIssuerId,
        credentialTypeId: myCredentialFoo,
        displayIndex: 5,
        name: TranslatedValue({'nl': "Rijbewijsnummer"}),
      ),
      myCredentialFoo + ".gender": AttributeType(
        schemeManagerId: mySchemeManagerId,
        issuerId: myIssuerId,
        credentialTypeId: myCredentialFoo,
        displayIndex: 6,
        name: TranslatedValue({'nl': "Geslacht"}),
      ),
      myCredentialFoo + ".signedOn": AttributeType(
        schemeManagerId: mySchemeManagerId,
        issuerId: myIssuerId,
        credentialTypeId: myCredentialFoo,
        displayIndex: 7,
        name: TranslatedValue({'nl': "Uitgiftedatum"}),
      ),
      myCredentialFoo + ".expires": AttributeType(
        schemeManagerId: mySchemeManagerId,
        issuerId: myIssuerId,
        credentialTypeId: myCredentialFoo,
        displayIndex: 8,
        name: TranslatedValue({'nl': "Verloopdatum"}),
      ),
      myCredentialFoo + ".portraitPhoto": AttributeType(
        schemeManagerId: mySchemeManagerId,
        issuerId: myIssuerId,
        credentialTypeId: myCredentialFoo,
        displayIndex: 9,
        displayHint: "portraitPhoto",
        name: TranslatedValue({'nl': "Foto"}),
      )
    },
  );

  Credential getPassportCredential(PassportReadEvent data, String id) {
    return Credential(
      id: id,
      issuer: Issuer(
        id: id,
        name: TranslatedValue({'nl': id}),
      ),
      schemeManager: irmaConfiguration.schemeManagers[mySchemeManagerId],
      signedOn: data.signedOn,
      expires: data.expires,
      attributes: Attributes({
        irmaConfiguration.attributeTypes[myCredentialFoo + ".firstnames"]: TranslatedValue({'nl': data.firstnames}),
        irmaConfiguration.attributeTypes[myCredentialFoo + ".surname"]: TranslatedValue({'nl': data.surname}),
        irmaConfiguration.attributeTypes[myCredentialFoo + ".nationality"]: TranslatedValue({'nl': data.nationality}),
        irmaConfiguration.attributeTypes[myCredentialFoo + ".dateOfBirth"]:
            TranslatedValue({'nl': DateFormat.yMMMMd('nl').format(data.dateOfBirth)}),
        irmaConfiguration.attributeTypes[myCredentialFoo + ".personalNumber"]:
            TranslatedValue({'nl': data.personalNumber}),
        irmaConfiguration.attributeTypes[myCredentialFoo + ".gender"]:
            TranslatedValue({'nl': PassportReadEvent.getGender(data.gender)}),
        irmaConfiguration.attributeTypes[myCredentialFoo + ".portraitPhoto"]: TranslatedValue({'nl': data.image}),
      }),
      hash: "foobar",
      credentialType: myPassportCredentialType,
    );
  }

  Credential getIdCardCredential(IdCardReadEvent data, String id) {
    return Credential(
      id: id,
      issuer: Issuer(
        id: id,
        name: TranslatedValue({'nl': id}),
      ),
      schemeManager: irmaConfiguration.schemeManagers[mySchemeManagerId],
      signedOn: data.signedOn,
      expires: data.expires,
      attributes: Attributes({
        irmaConfiguration.attributeTypes[myCredentialFoo + ".firstnames"]: TranslatedValue({'nl': data.firstnames}),
        irmaConfiguration.attributeTypes[myCredentialFoo + ".surname"]: TranslatedValue({'nl': data.surname}),
        irmaConfiguration.attributeTypes[myCredentialFoo + ".dateOfBirth"]:
            TranslatedValue({'nl': DateFormat.yMMMMd('nl').format(data.dateOfBirth)}),
        irmaConfiguration.attributeTypes[myCredentialFoo + ".personalNumber"]:
            TranslatedValue({'nl': data.personalNumber}),
        irmaConfiguration.attributeTypes[myCredentialFoo + ".gender"]:
            TranslatedValue({'nl': PassportReadEvent.getGender(data.gender)}),
        irmaConfiguration.attributeTypes[myCredentialFoo + ".portraitPhoto"]: TranslatedValue({'nl': data.image}),
      }),
      hash: "foobar",
      credentialType: myIdCardCredentialType,
    );
  }

  Credential getDriversLicenseCredential(DriversLicenseReadEvent data, String id) {
    return Credential(
      id: id,
      issuer: Issuer(
        id: id,
        name: TranslatedValue({'nl': id}),
      ),
      schemeManager: irmaConfiguration.schemeManagers[mySchemeManagerId],
      signedOn: data.signedOn,
      expires: data.expires,
      attributes: Attributes({
        irmaConfiguration.attributeTypes[myCredentialFoo + ".fullname"]: TranslatedValue({'nl': data.fullname}),
        irmaConfiguration.attributeTypes[myCredentialFoo + ".nationality"]: TranslatedValue({'nl': data.nationality}),
        irmaConfiguration.attributeTypes[myCredentialFoo + ".dateOfBirth"]:
            TranslatedValue({'nl': DateFormat.yMMMMd('nl').format(data.dateOfBirth)}),
        irmaConfiguration.attributeTypes[myCredentialFoo + ".licenseNumber"]:
            TranslatedValue({'nl': data.licenseNumber}),
        irmaConfiguration.attributeTypes[myCredentialFoo + ".gender"]:
            TranslatedValue({'nl': PassportReadEvent.getGender(data.gender)}),
        irmaConfiguration.attributeTypes[myCredentialFoo + ".portraitPhoto"]: TranslatedValue({'nl': data.image}),
      }),
      hash: "foobar",
      credentialType: myDriversLicenseCredentialType,
    );
  }
}
