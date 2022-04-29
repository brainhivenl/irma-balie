import 'package:flutter/material.dart';
import 'package:irmabalie/src/data/kiosk_repository.dart';
import 'package:irmabalie/src/kiosk/screens/initial.dart';
import 'package:irmabalie/src/kiosk/screens/welcome.dart';
import 'package:irmabalie/src/data/kiosk_repository.dart';

class YubikeyOtpWidget extends StatefulWidget {
  const YubikeyOtpWidget({Key key}) : super(key: key);

  @override
  State<YubikeyOtpWidget> createState() => _YubikeyOtpWidgetState();
}

class _YubikeyOtpWidgetState extends State<YubikeyOtpWidget> {
  FocusNode focusThief;
  // TextEditingController textController = TextEditingController();

  bool wasOtpAccepted = false;

  @override
  void initState() {
    super.initState();
    focusThief = FocusNode();
  }

  @override
  void dispose() {
    focusThief.dispose();
    super.dispose();
  }

  void _onSubmit(String otp) {
    setState(() {
      // textController.clear();
      KioskRepository().submitId(otp);
    });
    print('OTP: $otp');
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: false,
      maintainState: true,
      child: Focus(
        onFocusChange: (bool focused) {
          focusThief.requestFocus();
        },
        child: TextField(
          autofocus: true,
          focusNode: focusThief,
          // controller: textController,
          onSubmitted: _onSubmit,
        ),
      ),
    );
  }
}
