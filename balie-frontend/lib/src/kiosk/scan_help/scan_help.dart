import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmabalie/src/theme/theme.dart';
import 'package:irmabalie/src/kiosk/widgets/kiosk_title.dart';
import 'package:irmabalie/src/util/platform_svg.dart';
import 'package:irmabalie/src/widgets/irma_outlined_button.dart';
import 'package:irmabalie/src/widgets/irma_themed_button.dart';

// 1920, 1080

class ScanHelp extends StatelessWidget {
  static const routeName = '/scan_help';

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: <Widget>[
            KioskTitle(
              text: FlutterI18n.translate(context, 'kiosk.scan_help.title'),
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(60.0),
                  child: PlatformSvg.asset(
                    'assets/kiosk/question.svg',
                    excludeFromSemantics: true,
                    width: 180,
                  ),
                ),
                Text(
                  FlutterI18n.translate(context, 'kiosk.scan_help.header'),
                  style: IrmaTheme.of(context).kioskBodyHigh.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  FlutterI18n.translate(context, 'kiosk.scan_help.body1'),
                  style: IrmaTheme.of(context).kioskBodyHigh,
                  textAlign: TextAlign.center,
                ),
                RichText(
                  text: TextSpan(
                    style: IrmaTheme.of(context).kioskBodyHigh,
                    children: <TextSpan>[
                      TextSpan(
                        text: FlutterI18n.translate(context, 'kiosk.scan_help.body2'),
                        style: IrmaTheme.of(context).kioskBodyHigh.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: FlutterI18n.translate(context, 'kiosk.scan_help.bullet1'),
                      ),
                      TextSpan(
                        text: FlutterI18n.translate(context, 'kiosk.scan_help.bullet1_bold'),
                        style: IrmaTheme.of(context).kioskBodyHigh.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: '\n',
                      ),
                      TextSpan(
                        text: FlutterI18n.translate(context, 'kiosk.scan_help.bullet2'),
                      ),
                      TextSpan(
                        text: FlutterI18n.translate(context, 'kiosk.scan_help.bullet2_bold'),
                        style: IrmaTheme.of(context).kioskBodyHigh.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: IrmaOutlinedButton(
                    minWidth: 725,
                    size: IrmaButtonSize.kioskBig,
                    label: 'kiosk.scan_help.button',
                    textStyle: IrmaTheme.of(context).kioskButtonTextDark,
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      );
}
