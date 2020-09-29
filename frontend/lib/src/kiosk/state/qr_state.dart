import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class QrState extends ChangeNotifier {
  static final QrState _instance = QrState._internal();
  String _qrData;
  bool _isTransfering = false;

  factory QrState() {
    return _instance;
  }

  QrState._internal();

  setQrData(String data) {
    _qrData = data;
    notifyListeners();
  }

  String getQrData() {
    return _qrData;
  }

  setIsTransfering(bool transfering) {
    _isTransfering = transfering;
    notifyListeners();
  }

  bool isTransfering() {
    return _isTransfering;
  }
}
