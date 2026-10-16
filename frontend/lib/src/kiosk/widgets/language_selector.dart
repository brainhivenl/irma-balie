import 'package:flutter/material.dart';
import 'package:irmabalie/src/kiosk/state/language_state.dart';
import 'package:irmabalie/src/theme/theme.dart';
import 'package:provider/provider.dart';

class LanguageSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageState>();
    final theme = IrmaTheme.of(context);

    return ToggleButtons(
      isSelected: LanguageState.supportedLocales
          .map((locale) => locale == language.locale)
          .toList(),
      onPressed: (index) =>
          language.select(LanguageState.supportedLocales[index]),
      constraints: const BoxConstraints(minWidth: 230, minHeight: 80),
      borderRadius: BorderRadius.circular(20),
      borderColor: theme.primaryBlue,
      selectedBorderColor: theme.primaryBlue,
      color: theme.primaryBlue,
      selectedColor: theme.grayscaleWhite,
      fillColor: theme.primaryBlue,
      textStyle: theme.kioskButtonTextNormal.copyWith(fontSize: 32),
      children: const [Text('Nederlands'), Text('English')],
    );
  }
}
