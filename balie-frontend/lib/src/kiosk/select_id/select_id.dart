import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmabalie/src/data/kiosk_repository.dart';
import 'package:irmabalie/src/kiosk/state/id_state.dart';
import 'package:irmabalie/src/theme/theme.dart';
import 'package:irmabalie/src/kiosk/widgets/kiosk_title.dart';
import 'package:irmabalie/src/widgets/irma_button.dart';
import 'package:irmabalie/src/widgets/irma_themed_button.dart';

// 1920, 1080

class SelectId extends StatelessWidget {
  static const routeName = '/select_id';
  IdState idState = IdState();
  KioskRepository kioskRepository = KioskRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          KioskTitle(
            text: FlutterI18n.translate(context, 'kiosk.select.title'),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 72,
              top: 72,
              right: 72,
            ),
            child: Column(
              children: <Widget>[
                Text(
                  FlutterI18n.translate(context, 'kiosk.select.body'),
                  style: IrmaTheme.of(context).kioskBody,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 420 / 1920,
                      height: MediaQuery.of(context).size.height * 700 / 1080,
                      child: Column(
                        children: <Widget>[
                          const Spacer(flex: 1),
                          Image.asset(
                            'assets/kiosk/rijbewijs-front.png',
                            width: 419,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 80.0),
                            child: IrmaButton(
                              minWidth: 420,
                              size: IrmaButtonSize.kioskBig,
                              label: 'kiosk.select.driver',
                              textStyle: IrmaTheme.of(context).kioskButtonTextNormal,
                              onPressed: () {
                                idState.setId(Id.driversLicense);
                                Navigator.pushNamed(context, '/scan');

                                /*
                                TODO
                                sendPingEvent() here is for debugging purposes only!
                                Remove in production!
                                 */
                                kioskRepository.sendPingEvent();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 1),
                    Container(
                      width: MediaQuery.of(context).size.width * 420 / 1920,
                      height: MediaQuery.of(context).size.height * 700 / 1080,
                      child: Column(
                        children: <Widget>[
                          const Spacer(flex: 1),
                          Image.asset(
                            'assets/kiosk/id-kaart-front.png',
                            width: 419,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 80.0),
                            child: IrmaButton(
                              minWidth: 420,
                              size: IrmaButtonSize.kioskBig,
                              label: 'kiosk.select.id',
                              textStyle: IrmaTheme.of(context).kioskButtonTextNormal,
                              onPressed: () {
                                idState.setId(Id.idCard);
                                Navigator.pushNamed(context, '/scan');

                                /*
                                TODO
                                sendPingEvent() here is for debugging purposes only!
                                Remove in production!
                                 */
                                kioskRepository.sendPingEvent();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 1),
                    Container(
                      width: MediaQuery.of(context).size.width * 420 / 1920,
                      height: MediaQuery.of(context).size.height * 700 / 1080,
                      child: Column(
                        children: <Widget>[
                          const Spacer(flex: 1),
                          Image.asset(
                            'assets/kiosk/paspoort-front.png',
                            width: 343,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 80.0),
                            child: IrmaButton(
                              minWidth: 420,
                              size: IrmaButtonSize.kioskBig,
                              label: 'kiosk.select.passport',
                              textStyle: IrmaTheme.of(context).kioskButtonTextNormal,
                              onPressed: () {
                                idState.setId(Id.passport);
                                Navigator.pushNamed(context, '/scan');

                                /*
                                TODO
                                sendPingEvent() here is for debugging purposes only!
                                Remove in production!
                                 */
                                kioskRepository.sendPingEvent();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
