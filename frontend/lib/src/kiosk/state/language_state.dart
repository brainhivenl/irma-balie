import 'package:flutter/material.dart';

class LanguageState extends ChangeNotifier {
  static const supportedLocales = [Locale('nl', 'NL'), Locale('en', 'GB')];

  Locale _locale = supportedLocales.first;

  Locale get locale => _locale;

  void select(Locale locale) {
    if (!supportedLocales.contains(locale) || locale == _locale) return;
    _locale = locale;
    notifyListeners();
  }
}
