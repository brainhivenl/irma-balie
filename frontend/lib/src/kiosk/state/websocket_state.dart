import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WebsocketState extends ChangeNotifier {
  static final WebsocketState _instance = WebsocketState._internal();

  // UI assumes it is connected by default
  bool _isConnected = true;

  factory WebsocketState() {
    return _instance;
  }

  WebsocketState._internal();

  setIsConnected(bool connected) {
    _isConnected = connected;
    notifyListeners();
  }

  bool isConnected() {
    return _isConnected;
  }
}
