import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmabalie/src/kiosk/screens/welcome.dart';
import 'package:irmabalie/src/kiosk/state/id_state.dart';
import 'package:irmabalie/src/kiosk/widgets/toast.dart';
import 'package:irmabalie/src/theme/theme.dart';
import 'package:irmabalie/src/kiosk/widgets/kiosk_title.dart';
import 'package:irmabalie/src/util/platform_svg.dart';
import 'package:irmabalie/src/widgets/irma_outlined_button.dart';
import 'package:irmabalie/src/widgets/irma_themed_button.dart';
import 'package:provider/provider.dart';

// 1920, 1080

class Transferred extends StatelessWidget {
  static const routeName = '/transferred';

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Consumer<IdState>(
          builder: (context, idState, child) {
            return Column(
              children: <Widget>[
                KioskTitle(
                  text: FlutterI18n.translate(
                      context, 'kiosk.transferred.title',
                      translationParams: {
                        "id": FlutterI18n.translate(context,
                            'kiosk.id_type.${idState.getCode()}.propertyCapitalized')
                      }),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(78.0),
                      child: PlatformSvg.asset(
                        'assets/generic/check.svg',
                        excludeFromSemantics: true,
                      ),
                    ),
                    Text(
                      FlutterI18n.translate(context, 'kiosk.transferred.body',
                          translationParams: {
                            "id": FlutterI18n.translate(context,
                                'kiosk.id_type.${idState.getCode()}.property')
                          }),
                      style: IrmaTheme.of(context).kioskBody,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(78.0),
                      child: IrmaOutlinedButton(
                        minWidth: 420,
                        size: IrmaButtonSize.kioskBig,
                        label: 'kiosk.transferred.button',
                        textStyle:
                            IrmaTheme.of(context).kioskButtonTextLargeDark,
                        onPressed: () {
                          Navigator.pushNamed(context, Welcome.routeName);
                        },
                      ),
                    ),
                    KioskToast(
                      text: FlutterI18n.translate(context,
                          'kiosk.transferred.warning', translationParams: {
                        "id": FlutterI18n.translate(
                            context, 'kiosk.id_type.${idState.getCode()}.name')
                      }),
                    )
                  ],
                )
              ],
            );
          },
        ),
      );
}
