import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmabalie/src/theme/theme.dart';
import 'package:irmabalie/src/kiosk/widgets/kiosk_title.dart';

class Submitting extends StatelessWidget {
  static const routeName = '/submitting';

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: <Widget>[
            KioskTitle(
              text: FlutterI18n.translate(context, 'kiosk.submitting.title'),
            ),
            Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(126.0),
                    child: Image.asset(
                      "assets/generic/loading_indicator.webp",
                    )),
                Text(
                  FlutterI18n.translate(context, 'kiosk.submitting.body'),
                  style: IrmaTheme.of(context).kioskBody,
                ),
              ],
            )
          ],
        ),
      );
}
