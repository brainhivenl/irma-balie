import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:irmabalie/src/theme/theme.dart';
import 'package:irmabalie/src/widgets/irma_themed_button.dart';

class IrmaOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final VoidCallback onPressedDisabled;
  final TextStyle textStyle;
  final IrmaButtonSize size;
  final IconData icon;
  final double minWidth;

  const IrmaOutlinedButton({
    @required this.label,
    this.onPressed,
    this.onPressedDisabled,
    this.textStyle,
    this.minWidth = 232,
    this.size,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return IrmaThemedButton(
      label: label,
      onPressed: onPressed,
      onPressedDisabled: onPressedDisabled,
      textStyle: textStyle,
      minWidth: minWidth,
      size: size,
      icon: icon,
      color: Colors.transparent,
      disabledColor: Colors.white,
      textColor: IrmaTheme.of(context).primaryGray,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(
          color: onPressed != null ? IrmaTheme.of(context).primaryGray : IrmaTheme.of(context).disabled,
          width: 2,
        ),
      ),
    );
  }
}
