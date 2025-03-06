import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:irmabalie/src/theme/theme.dart';
import 'package:irmabalie/src/util/platform_svg.dart';

class KioskToast extends StatelessWidget {
  final String text;

  const KioskToast({
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1225,
      padding: const EdgeInsets.symmetric(
        horizontal: 56.0,
        vertical: 48.0,
      ),
      decoration: BoxDecoration(
        color: IrmaTheme.of(context).backgroundOrange,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 34.0),
            child: PlatformSvg.asset(
              'assets/kiosk/warning.svg',
              excludeFromSemantics: true,
            ),
          ),
          Text(
            text,
            style: IrmaTheme.of(context).kioskBodyDark.copyWith(
              fontSize: 36.0
            ),
          ),
        ],
      ),
    );
  }
}
