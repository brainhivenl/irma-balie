import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmabalie/src/kiosk/state/id_state.dart';
import 'package:irmabalie/src/theme/theme.dart';
import 'package:irmabalie/src/kiosk/widgets/kiosk_title.dart';
import 'package:provider/provider.dart';

// 1920, 1080

class ScanId extends StatelessWidget {
  static const routeName = '/scan';

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Consumer<IdState>(
          builder: (context, idState, child) {
            return Column(
              children: <Widget>[
                KioskTitle(
                  text: FlutterI18n.translate(context, 'kiosk.scan.title',
                      translationParams: {"id": FlutterI18n.translate(context, 'kiosk.id_type.${idState.getCode()}.nameCapitalized')}),
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: AlignmentDirectional.bottomCenter,
                    child: Container(
                      width: 1531,
                      height: 878,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/kiosk/scan_hulp_bg.png',
                          ),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Text(
                              FlutterI18n.translate(context, 'kiosk.scan.header',
                                  translationParams: {"id": FlutterI18n.translate(context, 'kiosk.id_type.${idState.getCode()}.name')}),
                              style: IrmaTheme.of(context).kioskTitleWhite,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(40.0),
                                  child: Text(
                                    FlutterI18n.translate(context, 'kiosk.scan.instruction.${idState.getCode()}'),
                                    style: IrmaTheme.of(context).kioskBodyWhiteExpanded,
                                  ),
                                ),
                              ),
                              Container(
                                width: 727,
                                height: 497,
                                alignment: AlignmentDirectional.center,
                                padding: const EdgeInsets.only(right: 40.0),
                                child: Image.asset(
                                  FlutterI18n.translate(context, 'kiosk.id_type.${idState.getCode()}.animation'),
                                  width: 687,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
}
