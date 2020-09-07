import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:irmabalie/src/theme/theme.dart';

class KioskTitle extends StatelessWidget {
  final String text;

  const KioskTitle({
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 149 / 1080,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: IrmaTheme.of(context).backgroundBlue,
      ),
      child: Text(
        text,
        style: IrmaTheme.of(context).kioskTitle,
        textAlign: TextAlign.center,
      ),
    );
  }
}
