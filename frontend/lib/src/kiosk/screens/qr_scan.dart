import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmabalie/src/kiosk/state/id_state.dart';
import 'package:irmabalie/src/kiosk/state/qr_state.dart';
import 'package:irmabalie/src/theme/theme.dart';
import 'package:irmabalie/src/kiosk/widgets/kiosk_title.dart';
import 'package:irmabalie/src/util/platform_svg.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

// 1920, 1080

class QrScan extends StatelessWidget {
  static const routeName = '/qr_scan';

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Consumer2<IdState, QrState>(
          builder: (context, idState, qrState, child) {
            return Column(
              children: <Widget>[
                KioskTitle(
                  text: FlutterI18n.translate(context, 'kiosk.qr_scan.title',
                      translationParams: {
                        "id": FlutterI18n.translate(context,
                            'kiosk.id_type.${idState.getCode()}.nameCapitalized')
                      }),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(80.0),
                      child: Stack(
                        children: <Widget>[
                          PlatformSvg.asset(
                            'assets/kiosk/qr_haken.svg',
                            excludeFromSemantics: true,
                            width: 580,
                            height: 580,
                          ),
                          Positioned(
                              left: 65,
                              top: 65,

                              // QR code placeholder
                              child: QrImage(
                                  data: qrState.getQrData(),
                                  version: QrVersions.auto,
                                  size: 450)),
                        ],
                      ),
                    ),
                    Text(
                      FlutterI18n.translate(
                          context, 'kiosk.qr_scan.body', translationParams: {
                        "id": FlutterI18n.translate(
                            context, 'kiosk.id_type.${idState.getCode()}.name')
                      }),
                      style: IrmaTheme.of(context).kioskBody,
                    ),
                  ],
                )
              ],
            );
          },
        ),
      );
}
