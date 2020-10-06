import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_i18n/loaders/file_translation_loader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:irmabalie/src/data/kiosk_repository.dart';
import 'package:irmabalie/src/kiosk/screens/invalid_id.dart';
import 'package:irmabalie/src/kiosk/screens/no_internet.dart';
import 'package:irmabalie/src/kiosk/screens/no_transfer.dart';
import 'package:irmabalie/src/kiosk/screens/qr_scan.dart';
import 'package:irmabalie/src/kiosk/screens/scan_fail.dart';
import 'package:irmabalie/src/kiosk/screens/scan_help.dart';
import 'package:irmabalie/src/kiosk/screens/scan_id.dart';
import 'package:irmabalie/src/kiosk/screens/scanning.dart';
import 'package:irmabalie/src/kiosk/screens/select_id.dart';
import 'package:irmabalie/src/kiosk/screens/transfer_in_progress.dart';
import 'package:irmabalie/src/kiosk/state/id_state.dart';
import 'package:irmabalie/src/kiosk/state/qr_state.dart';
import 'package:irmabalie/src/kiosk/screens/submitting.dart';
import 'package:irmabalie/src/kiosk/screens/succeeded.dart';
import 'package:irmabalie/src/kiosk/screens/transfer/transfer.dart';
import 'package:irmabalie/src/kiosk/screens/transferred.dart';
import 'package:irmabalie/src/kiosk/screens/welcome.dart';
import 'package:irmabalie/src/kiosk/state/websocket_state.dart';
import 'package:irmabalie/src/kiosk/widgets/no_animation_material_page_route.dart';
import 'package:irmabalie/src/theme/theme.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<IdState>(create: (_) => IdState()),
        ChangeNotifierProvider<QrState>(create: (_) => QrState()),
        ChangeNotifierProvider<WebsocketState>(create: (_) => WebsocketState()),
      ],
      child: App(),
    ),
  );
}

class KioskRouting {
  static Map<String, WidgetBuilder> simpleRoutes = {
    Welcome.routeName: (context) => Welcome(),
    SelectId.routeName: (context) => SelectId(),
    ScanId.routeName: (context) => ScanId(),
    Scanning.routeName: (context) => Scanning(),
    Succeeded.routeName: (context) => Succeeded(),
    Transfer.routeName: (context) => Transfer(),
    QrScan.routeName: (context) => QrScan(),
    NoTransfer.routeName: (context) => NoTransfer(),
    Transferred.routeName: (context) => Transferred(),
    NoInternet.routeName: (context) => NoInternet(),
    ScanFail.routeName: (context) => ScanFail(),
    ScanHelp.routeName: (context) => ScanHelp(),
    InvalidId.routeName: (context) => InvalidId(),
    Submitting.routeName: (context) => Submitting(),
    TransferInProgress.routeName: (context) => TransferInProgress(),
  };

  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      default:
        final builder = simpleRoutes[settings.name];
        assert(builder != null);

        return NoAnimationMaterialPageRoute(
          builder: builder,
          settings: settings,
        );
    }
  }
}

class App extends StatefulWidget {
  const App({Key key}) : super(key: key);

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  AppState();

  KioskRepository kioskRepository = KioskRepository();

  @override
  void initState() {
    kioskRepository.handleEvents(_navigatorKey);
  }

  static List<LocalizationsDelegate> defaultLocalizationsDelegates(
      [Locale forcedLocale]) {
    return [
      FlutterI18nDelegate(
        translationLoader: FileTranslationLoader(
          fallbackFile: 'nl',
          basePath: 'assets/locales',
          forcedLocale: forcedLocale,
        ),
      ),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate
    ];
  }

  static List<Locale> defaultSupportedLocales() {
    return const [
      Locale('nl', 'NL'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return IrmaTheme(
      builder: (BuildContext context) {
        return MaterialApp(
          key: const Key("app"),
          title: 'IRMA Kiosk',
          theme: IrmaTheme.of(context).themeData,
          localizationsDelegates:
              defaultLocalizationsDelegates(const Locale('nl', 'NL')),
          supportedLocales: defaultSupportedLocales(),
          navigatorKey: _navigatorKey,
          initialRoute: Welcome.routeName,
          onGenerateRoute: KioskRouting.generateRoute,

          // Set showSemanticsDebugger to true to view semantics in emulator.
          showSemanticsDebugger: false,

          builder: (context, child) {
            return child;
          },
        );
      },
    );
  }
}
