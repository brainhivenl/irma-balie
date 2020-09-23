import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmabalie/src/data/kiosk_repository.dart';
import 'package:irmabalie/src/kiosk/state/id_state.dart';
import 'package:irmabalie/src/kiosk/transfer/mock.dart';
import 'package:irmabalie/src/theme/theme.dart';
import 'package:irmabalie/src/kiosk/widgets/kiosk_title.dart';
import 'package:irmabalie/src/util/platform_svg.dart';
import 'package:irmabalie/src/widgets/card/card.dart';
import 'package:irmabalie/src/widgets/irma_button.dart';
import 'package:irmabalie/src/widgets/irma_outlined_button.dart';
import 'package:provider/provider.dart';
import 'package:irmabalie/src/widgets/irma_themed_button.dart';

// 1920, 1080

class Transfer extends StatefulWidget {
  static const routeName = '/transfer';

  @override
  _TransferState createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  final id = IdState();
  IrmaCard card;

  @override
  void initState() {
    super.initState();

    switch (id.getIdType()) {
      case Id.passport:
        card = IrmaCard(
          credential: IrmaClientMock().getPassportCredential(
            id.getPayload(),
            "Amsterdam",
          ),
          largeFonts: true,
        );
        break;
      case Id.idCard:
        card = IrmaCard(
          credential: IrmaClientMock().getIdCardCredential(
            id.getPayload(),
            "Amsterdam",
          ),
          largeFonts: true,
        );
        break;
      case Id.driversLicense:
        card = IrmaCard(
          credential: IrmaClientMock().getDriversLicenseCredential(
            id.getPayload(),
            "Amsterdam",
          ),
          largeFonts: true,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Consumer<IdState>(
          builder: (context, idState, child) {
            return Column(
              children: <Widget>[
                KioskTitle(
                  text: FlutterI18n.translate(context, 'kiosk.transfer.title',
                      translationParams: {
                        "id": FlutterI18n.translate(context,
                            'kiosk.id_type.${idState.getCode()}.nameCapitalized')
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 75.0,
                    right: 75.0,
                    bottom: 70.0,
                    left: 75.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 570,
                        child: card,
                      ),
                      Column(
                        children: <Widget>[
                          PlatformSvg.asset(
                            'assets/irma_logo.svg',
                            excludeFromSemantics: true,
                            width: 220,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(75.0),
                            child: Text(
                              FlutterI18n.translate(
                                  context, 'kiosk.transfer.body',
                                  translationParams: {
                                    "id": FlutterI18n.translate(context,
                                        'kiosk.id_type.${idState.getCode()}.name')
                                  }),
                              style: IrmaTheme.of(context).kioskBody,
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              IrmaOutlinedButton(
                                minWidth: 420,
                                size: IrmaButtonSize.kioskBig,
                                label: 'kiosk.transfer.no',
                                textStyle: IrmaTheme.of(context)
                                    .kioskButtonTextLargeDark,
                                onPressed: () {
                                  Navigator.pushNamed(context, '/no_transfer');
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 60.0),
                                child: IrmaButton(
                                  minWidth: 420,
                                  size: IrmaButtonSize.kioskBig,
                                  label: 'kiosk.transfer.yes',
                                  textStyle: IrmaTheme.of(context)
                                      .kioskButtonTextLarge,
                                  onPressed: () {
                                    KioskRepository().submitId();
                                    // Navigator.pushNamed(context, '/qr_scan');
                                  },
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      );
}
