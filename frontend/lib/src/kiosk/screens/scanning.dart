import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmabalie/src/kiosk/state/id_state.dart';
import 'package:irmabalie/src/theme/theme.dart';
import 'package:irmabalie/src/kiosk/widgets/kiosk_title.dart';
import 'package:provider/provider.dart';

// 1920, 1080

class Scanning extends StatelessWidget {
  static const routeName = '/scanning';

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Consumer<IdState>(
          builder: (context, idState, child) {
            return Column(
              children: <Widget>[
                KioskTitle(
                  text: FlutterI18n.translate(context, 'kiosk.scanning.title',
                      translationParams: {
                        "id": FlutterI18n.translate(context,
                            'kiosk.id_type.${idState.getCode()}.nameCapitalized')
                      }),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(126.0),
                        child: Image.asset(
                          "assets/generic/loading_indicator.webp",
                        )),
                    Text(
                      FlutterI18n.translate(
                          context, 'kiosk.scanning.body', translationParams: {
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
