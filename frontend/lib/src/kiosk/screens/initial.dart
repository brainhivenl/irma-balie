import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmabalie/src/theme/theme.dart';
import 'package:irmabalie/src/kiosk/widgets/kiosk_title.dart';
import 'package:irmabalie/src/util/platform_svg.dart';

// 1920, 1080

class Initial extends StatelessWidget {
  static const routeName = '/initial';

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: <Widget>[
            KioskTitle(
              text: FlutterI18n.translate(context, 'kiosk.initial.title'),
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(60.0),
                  child: PlatformSvg.asset(
                    'assets/kiosk/no_internet.svg',
                    excludeFromSemantics: true,
                  ),
                ),
                Text(
                  FlutterI18n.translate(context, 'kiosk.initial.header'),
                  style: IrmaTheme.of(context)
                      .kioskBodyHigh
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  FlutterI18n.translate(context, 'kiosk.initial.body'),
                  style: IrmaTheme.of(context).kioskBodyHigh,
                  textAlign: TextAlign.center,
                ),
              ],
            )
          ],
        ),
      );
}
