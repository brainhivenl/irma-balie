import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:irmabalie/main.dart';
import 'package:irmabalie/src/kiosk/screens/select_id.dart';
import 'package:irmabalie/src/kiosk/screens/welcome.dart';
import 'package:irmabalie/src/kiosk/state/language_state.dart';
import 'package:irmabalie/src/theme/theme.dart';
import 'package:irmabalie/src/util/language.dart';
import 'package:provider/provider.dart';

Map<String, dynamic> flatten(Map<String, dynamic> values,
    [String prefix = '']) {
  final result = <String, dynamic>{};
  values.forEach((key, value) {
    final path = '$prefix$key';
    if (value is Map<String, dynamic>) {
      result.addAll(flatten(value, '$path.'));
    } else {
      result[path] = value;
    }
  });
  return result;
}

void main() {
  test('English covers every kiosk key, placeholder and asset', () {
    Map<String, dynamic> kiosk(String language) => flatten(
          jsonDecode(File('assets/locales/$language.json').readAsStringSync())[
              'kiosk'] as Map<String, dynamic>,
        );
    final dutch = kiosk('nl');
    final english = kiosk('en');
    expect(english.keys.toSet(), dutch.keys.toSet());
    final placeholder = RegExp(r'\{[^}]+\}');
    dutch.forEach((key, value) {
      expect(english[key], isNotEmpty, reason: key);
      expect(
        placeholder.allMatches(english[key] as String).map((m) => m.group(0)),
        placeholder.allMatches(value as String).map((m) => m.group(0)),
        reason: key,
      );
      if (key.endsWith('.image') || key.endsWith('.animation')) {
        expect(english[key], value, reason: key);
      }
    });
  });

  testWidgets('language switches in place and survives navigation',
      (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1920, 1080);
    tester.binding.window.devicePixelRatioTestValue = 1;
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    addTearDown(tester.binding.window.clearDevicePixelRatioTestValue);

    final language = LanguageState();
    final delegates = AppState.defaultLocalizationsDelegates();
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: language,
        child: IrmaTheme(
          builder: (context) => MaterialApp(
            navigatorKey: navigator,
            locale: context.watch<LanguageState>().locale,
            supportedLocales: LanguageState.supportedLocales,
            localizationsDelegates: delegates,
            theme: IrmaTheme.of(context).themeData,
            home: Welcome(),
            routes: {SelectId.routeName: (_) => SelectId()},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
        find.text('Zet je gegevens uit je identiteitsdocument in je Yivi-app'),
        findsOneWidget);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    expect(
        find.text(
            'Add the details from your identity document to your Yivi app'),
        findsOneWidget);
    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();
    expect(find.text('Choose your identity document'), findsOneWidget);
    expect(find.text('Driving licence'), findsOneWidget);
    navigator.currentState.pop();
    await tester.pumpAndSettle();
    expect(language.locale.languageCode, 'en');

    await tester.tap(find.text('Nederlands'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();
    expect(find.text('Identiteitsdocument kiezen'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('credential translations follow locale and fall back to Dutch',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en', 'GB'),
      supportedLocales: LanguageState.supportedLocales,
      localizationsDelegates: AppState.defaultLocalizationsDelegates(),
      home: Builder(builder: (context) {
        return Column(children: [
          Text(getTranslation(context, {'nl': 'Paspoort', 'en': 'Passport'})),
          Text(getTranslation(context, {'nl': 'Amsterdam'})),
        ]);
      }),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Passport'), findsOneWidget);
    expect(find.text('Amsterdam'), findsOneWidget);
  });
}
