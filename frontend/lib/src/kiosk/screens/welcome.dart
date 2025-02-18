import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmabalie/src/kiosk/screens/select_id.dart';
import 'package:irmabalie/src/theme/theme.dart';
import 'package:irmabalie/src/util/platform_svg.dart';
import 'package:irmabalie/src/widgets/irma_button.dart';
import 'package:irmabalie/src/widgets/irma_themed_button.dart';

class Welcome extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(
          76,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 36),
              child: PlatformSvg.asset(
                'assets/wallet/wallet_illustration.svg',
                excludeFromSemantics: true,
                width: MediaQuery.of(context).size.width * 866 / 1920,
              ),
            ),
            const Spacer(flex: 1),
            Container(
              width: MediaQuery.of(context).size.width * 790 / 1920,
              child: Column(
                children: <Widget>[
                  const Spacer(flex: 1),
                  PlatformSvg.asset(
                    'assets/yivi_logo.svg',
                    excludeFromSemantics: true,
                    width: 169,
                  ),
                  const Spacer(flex: 1),
                  Text(
                    FlutterI18n.translate(context, 'kiosk.main.start_heading'),
                    style: IrmaTheme.of(context).kioskHeader,
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(flex: 1),
                  IrmaButton(
                    minWidth: 420,
                    size: IrmaButtonSize.kioskBig,
                    label: 'kiosk.main.start_button',
                    textStyle: IrmaTheme.of(context).kioskButtonTextLarge,
                    onPressed: () {
                      Navigator.pushNamed(context, SelectId.routeName);
                    },
                  ),
                  const Spacer(flex: 1),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
