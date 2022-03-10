import 'package:flutter/material.dart';
import 'package:irmabalie/src/models/credentials.dart';
import 'package:irmabalie/src/theme/theme.dart';
import 'package:irmabalie/src/util/language.dart';
import 'package:irmabalie/src/widgets/card/irma_card_theme.dart';

import 'card_attributes.dart';
import 'card_menu.dart';

class IrmaCard extends StatelessWidget {
  static const _borderRadius = Radius.circular(15.0);
  static const _transparentBlack = Color(0x77000000);
  static const _blurRadius = 4.0;

  final String lang = 'nl';

  final Credential credential;
  final Function() onRefreshCredential;
  final Function() onDeleteCredential;

  final void Function(double) scrollBeyondBoundsCallback;
  final bool isDeleted;
  final bool largeFonts;

  final IrmaCardTheme cardTheme;

  IrmaCard({
    this.credential,
    this.onRefreshCredential,
    this.onDeleteCredential,
    this.scrollBeyondBoundsCallback,
    this.isDeleted = false,
    this.largeFonts = false,
  }) : cardTheme = IrmaCardTheme.fromCredentialType(credential);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: IrmaTheme.of(context).smallSpacing),
        decoration: BoxDecoration(
          color: cardTheme.backgroundGradientStart,
          gradient: LinearGradient(
            colors: [
              cardTheme.backgroundGradientStart,
              cardTheme.backgroundGradientEnd,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border.all(
            width: 1.0,
            color: cardTheme.backgroundGradientEnd,
          ),
          borderRadius: const BorderRadius.all(
            _borderRadius,
          ),
          boxShadow: const [
            BoxShadow(
              color: _transparentBlack,
              blurRadius: _blurRadius,
              offset: Offset(
                0.0,
                2.0,
              ),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: IrmaTheme.of(context).smallSpacing,
                left: IrmaTheme.of(context).defaultSpacing,
                bottom: 0,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      getTranslation(credential.credentialType.name),
                      style: largeFonts
                          ? IrmaTheme.of(context).subheadLarge.copyWith(
                                color: cardTheme.foregroundColor,
                              )
                          : Theme.of(context).textTheme.subtitle1.copyWith(
                                color: cardTheme.foregroundColor,
                              ),
                    ),
                  ),
                  CardMenu(
                    cardTheme: cardTheme,
                    onRefreshCredential: onRefreshCredential,
                    onDeleteCredential: onDeleteCredential,
                  )
                ],
              ),
            ),
            Container(
              child: CardAttributes(
                credential: credential,
                irmaCardTheme: cardTheme,
                scrollOverflowCallback: scrollBeyondBoundsCallback,
                largeFonts: largeFonts,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
