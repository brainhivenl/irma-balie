import 'package:flutter/widgets.dart';

String getTranslation(BuildContext context, Map<String, String> translations) {
  final language = Localizations.localeOf(context).languageCode;
  return translations[language] ??
      translations['nl'] ??
      '[translation missing]';
}
