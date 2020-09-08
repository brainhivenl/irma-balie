import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmabalie/src/kiosk/state/id_state.dart';
import 'package:irmabalie/src/theme/theme.dart';
import 'package:irmabalie/src/kiosk/widgets/kiosk_title.dart';
import 'package:irmabalie/src/util/platform_svg.dart';
import 'package:irmabalie/src/widgets/irma_button.dart';
import 'package:irmabalie/src/widgets/irma_outlined_button.dart';
import 'package:irmabalie/src/widgets/irma_themed_button.dart';
import 'package:provider/provider.dart';

// 1920, 1080

class ScanFail extends StatelessWidget {
  static const routeName = '/scan_fail';

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Consumer<IdState>(
          builder: (context, idState, child) {
            return Column(
              children: <Widget>[
                KioskTitle(
                  text: FlutterI18n.translate(context, 'kiosk.scan_fail.title'),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(78.0),
                      child: PlatformSvg.asset(
                        'assets/kiosk/error.svg',
                        excludeFromSemantics: true,
                      ),
                    ),
                    Text(
                      FlutterI18n.translate(context, 'kiosk.scan_fail.body'),
                      style: IrmaTheme.of(context).kioskBody,
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 78.0),
                      child: Row(
                        children: <Widget>[
                          Spacer(flex: 1),
                          IrmaOutlinedButton(
                            minWidth: 550,
                            size: IrmaButtonSize.kioskBig,
                            label: 'kiosk.scan_fail.button_help',
                            textStyle: IrmaTheme.of(context).kioskButtonTextDark,
                            onPressed: () {
                              Navigator.pushNamed(context, '/scan_help');
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 60.0),
                            child: IrmaButton(
                              minWidth: 550,
                              size: IrmaButtonSize.kioskBig,
                              label: 'kiosk.scan_fail.button_again',
                              textStyle: IrmaTheme.of(context).kioskButtonTextNormal,
                              onPressed: () {
                                Navigator.pushNamed(context, '/scan');
                              },
                            ),
                          ),
                          Spacer(flex: 1),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            );
          },
        ),
      );
}
