import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmabalie/src/kiosk/state/id_state.dart';
import 'package:irmabalie/src/theme/theme.dart';
import 'package:irmabalie/src/kiosk/widgets/kiosk_title.dart';
import 'package:irmabalie/src/util/platform_svg.dart';
import 'package:provider/provider.dart';

// 1920, 1080

class Succeeded extends StatelessWidget {
  static const routeName = '/succeeded';
  IdState idState = IdState();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Consumer<IdState>(
          builder: (context, idState, child) {
            return Column(
              children: <Widget>[
                KioskTitle(
                  text: FlutterI18n.translate(context, 'kiosk.succeeded.title',
                      translationParams: {"id": FlutterI18n.translate(context, 'kiosk.id_type.${idState.getCode()}.nameCapitalized')}),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(126.0),
                      child: PlatformSvg.asset(
                        'assets/generic/check.svg',
                        excludeFromSemantics: true,
                        width: MediaQuery.of(context).size.height * 450 / 1080,
                      ),
                    ),
                    Text(
                      FlutterI18n.translate(context, 'kiosk.succeeded.body'),
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
