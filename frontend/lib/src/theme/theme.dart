import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class IrmaThemeData extends Equatable {
  static const double _spaceBase = 16.0;
  @Deprecated(
      "Move to tinySpacing, smallSpacing, defaultSpacing or largeSpacing, don't use local divisions/multiplications")
  final double spacing = _spaceBase;
  final double tinySpacing = _spaceBase / 4; // 4
  final double smallSpacing = _spaceBase / 2; // 8
  final double defaultSpacing = _spaceBase; // 16
  final double mediumSpacing = _spaceBase * 1.5; // 24
  final double largeSpacing = _spaceBase * 2; // 32
  final double hugeSpacing = _spaceBase * 4; // 64

  // Primary colors
  final Color primaryGray = const Color(0xFF484747);
  final Color primaryBlue = const Color(0xFFA03352);
  final Color primaryDark = const Color(0xFF15222E);
  final Color primaryLight = const Color(0xFFF2F5F8);

  // Grayscale colors (used for text, background colors, lines and icons)
  final Color grayscaleWhite = const Color(0xFFFFFFFF);
  final Color grayscale95 = const Color(0xFFF2F5F8);
  final Color grayscale90 = const Color(0xFFE8ECF0);
  final Color grayscale85 = const Color(0xFFE3E9F0);
  final Color grayscale80 = const Color(0xFFB7C2CC);
  final Color grayscale60 = const Color(0xFF71808F);
  final Color grayscale40 = const Color(0xFF3C4B5A);

  final Color scanBackground = const Color(0xFFCCCFD1);

  final Color disabled = const Color(0xFFE8ECF0);

  // Supplementary colors (for card backgrounds)
  final Color cardRed = const Color(0xFFD44454);
  final Color cardBlue = const Color(0xFF00B1E6);
  final Color cardOrange = const Color(0xFFFFBB58);
  final Color cardGreen = const Color(0xFF2BC194);

  // Support colors (for alerts and feedback on form elements)
  final Color interactionValid = const Color(0xFF079268);
  final Color interactionInvalid = const Color(0xFFD44454);
  final Color interactionAlert = const Color(0xFFF97D08);
  final Color interactionInformation = const Color(0xFF004C92);
  final Color interactionInvalidTransparant = const Color(0x22D44454);

  // Support colors (qr scanner)
  final Color overlayValid = const Color(0xFF029B17);
  final Color overlayInvalid = const Color(0xFFC8192C);

  // Link colors
  final Color linkColor = const Color(0xFF004C92);
  final Color linkVisitedColor = const Color(0xFF71808F);

  // Overlay color
  final Color overlay50 = const Color(0xFF3C4B5A);

  // background color
  final Color backgroundBlue = const Color(0xFFDFE6EE);
  final Color backgroundOrange = const Color(0xFFFAD8B6);

  final String fontFamilyAlexandria = "Alexandria";

  TextTheme textTheme;
  TextStyle collapseTextStyle;
  TextStyle textButtonTextStyle;
  TextStyle issuerNameTextStyle;
  TextStyle newCardButtonTextStyle;
  TextStyle hyperlinkTextStyle;
  TextStyle hyperlinkVisitedTextStyle;
  TextStyle boldBody;
  TextStyle kioskHeader;
  TextStyle kioskTitle;
  TextStyle kioskTitleWhite;
  TextStyle kioskBody;
  TextStyle kioskBodyDark;
  TextStyle kioskBodyHigh;
  TextStyle kioskBodyWhiteExpanded;
  TextStyle kioskButtonTextNormal;
  TextStyle kioskButtonTextDark;
  TextStyle kioskButtonTextLarge;
  TextStyle kioskButtonTextLargeDark;
  TextStyle subheadLarge;
  TextStyle cardAttrName;
  TextStyle cardAttrValue;
  TextStyle cardAttrNameLarge;
  TextStyle cardAttrValueLarge;

  ThemeData themeData;

  IrmaThemeData() {
    textTheme = TextTheme(
      // Headings

      // display4 is used for extremely large text
      //
      // md2018: headline1
      headline1: TextStyle(
        fontFamily: fontFamilyAlexandria,
        fontSize: 18.0,
        height: 28.0 / 18.0,
        fontWeight: FontWeight.bold,
        color: grayscale40,
      ),

      // display3 is used for very, very large text
      //
      // md2018: headline2
      headline2: TextStyle(
        fontFamily: fontFamilyAlexandria,
        fontSize: 24.0,
        height: 28.0 / 24.0,
        fontWeight: FontWeight.bold,
        color: grayscale40,
      ),

      // display2 is used for very large text
      //
      // md2018: headline3
      headline3: TextStyle(
        fontFamily: fontFamilyAlexandria,
        fontSize: 18.0,
        height: 24.0 / 18.0,
        fontWeight: FontWeight.bold,
        color: grayscale40,
      ),

      // display1 is used for large text
      //
      // md2018: headline4
      headline4: TextStyle(
        fontFamily: fontFamilyAlexandria,
        fontSize: 16.0,
        height: 24.0 / 16.0,
        fontWeight: FontWeight.bold,
        color: grayscale40,
      ),

      // Paragraph text

      // body2 is used for emphasizing text that would otherwise be body1
      //
      // md2018: body1
      bodyText1: TextStyle(
        fontFamily: fontFamilyAlexandria,
        fontSize: 16.0,
        height: 24.0 / 16.0,
        fontWeight: FontWeight.w500,
        // medium
        color: primaryDark,
      ),

      // body1 is the default text style
      //
      // md2018: body2
      bodyText2: TextStyle(
        fontFamily: fontFamilyAlexandria,
        fontSize: 16.0,
        height: 24.0 / 16.0,
        fontWeight: FontWeight.normal,
        color: primaryDark,
      ),

      // Specific styles

      // headline is used for large text in dialogs
      //
      // md2018: headline5
      headline5: TextStyle(
        // TODO: Misisng in designs
        fontFamily: fontFamilyAlexandria,
        fontSize: 24.0,
        height: 28.0 / 24.0,
        fontWeight: FontWeight.bold,
        color: grayscale40,
      ),

      // title is used for the primary text in app bars and dialogs
      //
      // md2018: headline6
      headline6: TextStyle(
        fontFamily: fontFamilyAlexandria,
        fontSize: 18.0,
        height: 28.0 / 18.0,
        fontWeight: FontWeight.bold,
        color: grayscale40,
      ),

      // subhead is used for the primary text in lists
      // also used in textfield inputs' text style
      //
      // md2018: subtitle1
      subtitle1: TextStyle(
        fontFamily: fontFamilyAlexandria,
        fontSize: 18.0,
        height: 22.0 / 18.0,
        fontWeight: FontWeight.normal,
        color: primaryDark,
      ),

      // subtitle is used for medium emphasis text that's a little smaller than subhead.
      //
      // md2018: subtitle2
      subtitle2: TextStyle(
        fontFamily: fontFamilyAlexandria,
        fontSize: 16.0,
        height: 22.0 / 16.0,
        fontWeight: FontWeight.w500,
        color: grayscale40,
      ),

      // caption is used for auxiliary text associated with images
      //
      // md2018: caption
      caption: TextStyle(
        fontFamily: fontFamilyAlexandria,
        fontSize: 14.0,
        height: 20.0 / 14.0,
        fontWeight: FontWeight.normal,
        color: primaryDark,
      ),

      // button is used for text on RaisedButton and FlatButton
      //
      // md2018: button
      button: TextStyle(
        fontFamily: fontFamilyAlexandria,
        fontSize: 16.0,
        height: 19.0 / 16.0,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),

      // is used for the smallest text
      //
      // md2018: overline
      overline: TextStyle(
        fontFamily: fontFamilyAlexandria,
        fontSize: 12.0,
        height: 16.0 / 12.0,
        fontWeight: FontWeight.w600,
        color: grayscale40,
      ),
    );

    // Additional text styles that are not defined by Material Design
    issuerNameTextStyle = TextStyle(
      fontFamily: fontFamilyAlexandria,
      fontSize: 16.0,
      height: 19.0 / 16.0,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    );

    collapseTextStyle = TextStyle(
      fontFamily: fontFamilyAlexandria,
      fontSize: 18.0,
      height: 22.0 / 18.0,
      fontWeight: FontWeight.normal,
      color: grayscale40,
    );

    textButtonTextStyle = TextStyle(
      fontFamily: fontFamilyAlexandria,
      fontSize: 16.0,
      height: 19.0 / 16.0,
      fontWeight: FontWeight.w600,
      color: primaryGray,
    );

    newCardButtonTextStyle = TextStyle(
      fontFamily: fontFamilyAlexandria,
      fontSize: 18.0,
      height: 22.0 / 18.0,
      fontWeight: FontWeight.w500,
      color: grayscale40,
    );

    hyperlinkTextStyle = TextStyle(
      fontFamily: fontFamilyAlexandria,
      fontSize: 16.0,
      height: 24.0 / 16.0,
      fontWeight: FontWeight.normal,
      color: primaryGray,
      decoration: TextDecoration.underline,
    );

    hyperlinkVisitedTextStyle = TextStyle(
      fontFamily: fontFamilyAlexandria,
      fontSize: 16.0,
      height: 19.0 / 16.0,
      fontWeight: FontWeight.normal,
      color: grayscale60,
    );

    boldBody = TextStyle(
      fontFamily: fontFamilyAlexandria,
      fontSize: 16.0,
      height: 24.0 / 16.0,
      fontWeight: FontWeight.w600,
      color: primaryDark,
    );

    kioskHeader = TextStyle(
      fontFamily: fontFamilyAlexandria,
      fontSize: 72.0,
      height: 84.0 / 72.0,
      fontWeight: FontWeight.w600,
      color: primaryGray,
    );

    kioskTitle = TextStyle(
      fontFamily: fontFamilyAlexandria,
      fontSize: 48.0,
      height: 56.0 / 48.0,
      fontWeight: FontWeight.w800,
      color: grayscale40,
    );

    kioskTitleWhite = kioskTitle.copyWith(
      color: grayscaleWhite,
    );

    kioskBody = TextStyle(
      fontFamily: fontFamilyAlexandria,
      fontSize: 48.0,
      height: 56.0 / 48.0,
      fontWeight: FontWeight.w500,
      color: primaryGray,
    );

    kioskBodyDark = kioskBody.copyWith(
      color: primaryDark,
    );

    kioskBodyHigh = kioskBody.copyWith(
      height: 72.0 / 48.0,
    );

    kioskBodyWhiteExpanded = kioskBody.copyWith(
      height: 80.0 / 48.0,
      color: grayscaleWhite,
      fontWeight: FontWeight.w400,
    );

    kioskButtonTextNormal = TextStyle(
      fontFamily: fontFamilyAlexandria,
      fontSize: 40.0,
      height: 49.0 / 40.0,
      fontWeight: FontWeight.w500,
      color: grayscaleWhite,
    );

    kioskButtonTextLarge = TextStyle(
      fontFamily: fontFamilyAlexandria,
      fontSize: 48.0,
      height: 58.0 / 48.0,
      fontWeight: FontWeight.w600,
      color: grayscaleWhite,
    );

    kioskButtonTextDark = kioskButtonTextNormal.copyWith(
      color: primaryGray,
    );

    kioskButtonTextLargeDark = kioskButtonTextLarge.copyWith(
      color: primaryGray,
    );

    subheadLarge = TextStyle(
      fontFamily: fontFamilyAlexandria,
      fontSize: 26.0,
      height: 30.0 / 26.0,
      fontWeight: FontWeight.normal,
      color: primaryDark,
    );

    cardAttrName = TextStyle(
      fontFamily: fontFamilyAlexandria,
      fontSize: 14.0,
      height: 22.0 / 14.0,
      fontWeight: FontWeight.normal,
      color: primaryDark,
    );

    cardAttrValue = TextStyle(
      fontFamily: fontFamilyAlexandria,
      fontSize: 14.0,
      height: 22.0 / 14.0,
      fontWeight: FontWeight.normal,
      color: primaryDark,
    );

    cardAttrNameLarge = TextStyle(
      fontFamily: fontFamilyAlexandria,
      fontSize: 14.0,
      height: 22.0 / 14.0,
      fontWeight: FontWeight.normal,
      color: primaryDark,
    );

    cardAttrValueLarge = TextStyle(
      fontFamily: fontFamilyAlexandria,
      fontSize: 14.0,
      height: 22.0 / 14.0,
      fontWeight: FontWeight.normal,
      color: primaryDark,
    );

    // Final ThemeData composed of all individual theme components.
    themeData = ThemeData(
        brightness: Brightness.light,
        primaryColor: primaryBlue,
        accentColor: cardRed,
        disabledColor: disabled,
        scaffoldBackgroundColor: primaryLight,
        fontFamily: fontFamilyAlexandria,
        textTheme: textTheme,
        appBarTheme: AppBarTheme(
          elevation: 0,
          brightness: Brightness.light,
          color: grayscale85,
          // TODO: validate
          textTheme: textTheme,
          iconTheme: IconThemeData(
            color: primaryDark,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: textTheme.overline,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: grayscale60,
              width: 1.0,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: primaryGray,
              width: 2.0,
            ),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: interactionInvalid,
              width: 2.0,
            ),
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: grayscale80,
              width: 1.0,
            ),
          ),
          errorStyle: textTheme.bodyText2.copyWith(color: interactionInvalid),
        ));
  }

    @override
  List<Object> get props => [
    spacing,
    tinySpacing,
    smallSpacing,
    defaultSpacing,
    mediumSpacing,
    largeSpacing,
    hugeSpacing,

    primaryBlue,
    primaryDark,
    primaryLight,

    grayscaleWhite,
    grayscale95,
    grayscale90,
    grayscale85,
    grayscale80,
    grayscale60,
    grayscale40,

    scanBackground,

    disabled,

    cardRed,
    cardBlue,
    cardOrange,
    cardGreen,

    interactionValid,
    interactionInvalid,
    interactionAlert,
    interactionInformation,
    interactionInvalidTransparant,

    overlayValid,
    overlayInvalid,

    linkColor,
    linkVisitedColor,

    overlay50,

    backgroundBlue,
    backgroundOrange,

    fontFamilyAlexandria,

    textTheme,
    collapseTextStyle,
    textButtonTextStyle,
    issuerNameTextStyle,
    newCardButtonTextStyle,
    hyperlinkTextStyle,
    hyperlinkVisitedTextStyle,
    boldBody,
    kioskHeader,
    kioskTitle,
    kioskTitleWhite,
    kioskBody,
    kioskBodyDark,
    kioskBodyHigh,
    kioskBodyWhiteExpanded,
    kioskButtonTextNormal,
    kioskButtonTextDark,
    kioskButtonTextLarge,
    kioskButtonTextLargeDark,
    subheadLarge,
    cardAttrName,
    cardAttrValue,
    cardAttrNameLarge,
    cardAttrValueLarge,

    themeData,
  ];
}

class IrmaTheme extends InheritedWidget {
  final IrmaThemeData data = IrmaThemeData();

  // IrmaTheme provides the IRMA ThemeData to descendents. Therefore descendents
  // must be wrapped in a Builder.
  IrmaTheme({Key key, WidgetBuilder builder})
      : super(
          key: key,
          child: Builder(builder: builder),
        );

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return (oldWidget as IrmaTheme).data != data;
  }

  static IrmaThemeData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<IrmaTheme>().data;
  }
}
