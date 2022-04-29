import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmabalie/src/theme/theme.dart';
import 'package:irmabalie/src/kiosk/widgets/kiosk_title.dart';
import 'package:irmabalie/src/util/platform_svg.dart';

import 'package:irmabalie/src/kiosk/screens/initial.dart';
import 'package:irmabalie/src/widgets/irma_button.dart';
import 'package:irmabalie/src/widgets/irma_themed_button.dart';
import 'package:irmabalie/src/widgets/yubikey_otp_widget.dart';
// 1920, 1080

class Fingerprint extends StatelessWidget {
  static const routeName = '/fingerprint';

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: <Widget>[
            KioskTitle(
              text: FlutterI18n.translate(context, 'kiosk.fingerprint.title'),
            ),
            Column(
              children: <Widget>[
                YubikeyOtpWidget(),
                Padding(
                  padding: const EdgeInsets.all(60.0),
                  child: PlatformSvg.asset(
                    'assets/kiosk/question.svg',
                    excludeFromSemantics: true,
                  ),
                ),
                Text(
                  FlutterI18n.translate(context, 'kiosk.fingerprint.header'),
                  style: IrmaTheme.of(context)
                      .kioskBodyHigh
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  FlutterI18n.translate(context, 'kiosk.fingerprint.body'),
                  style: IrmaTheme.of(context).kioskBodyHigh,
                  textAlign: TextAlign.center,
                ),
                IrmaButton(
                  minWidth: 420,
                  size: IrmaButtonSize.medium,
                  label: 'nee terug',
                  textStyle: IrmaTheme.of(context).kioskButtonTextLarge,
                  onPressed: () {
                    Navigator.pushNamed(context, Initial.routeName);
                  },
                ),
              ],
            )
          ],
        ),
      );
}
