import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:irmabalie/src/kiosk/invalid_id/invalid_id.dart';
import 'package:irmabalie/src/kiosk/no_internet/no_internet.dart';
import 'package:irmabalie/src/kiosk/scan_fail/scan_fail.dart';
import 'package:irmabalie/src/kiosk/scanning/scanning.dart';
import 'package:irmabalie/src/kiosk/state/id_state.dart';
import 'package:irmabalie/src/kiosk/succeeded/succeeded.dart';
import 'package:irmabalie/src/kiosk/transfer/transfer.dart';
import 'package:irmabalie/src/models/event.dart';
import 'package:irmabalie/src/models/kiosk_events.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

typedef EventUnmarshaller = Event Function(Map<String, dynamic>);

class KioskRepository {
  static KioskRepository _instance;
  IdState idState = IdState();
  String _hostBase;
  bool _hostSecure;

  factory KioskRepository() {
    return _instance ??= KioskRepository._internal();
  }

  final Map<String, EventUnmarshaller> _eventUnmarshallers = {
    // PassportReadEvent: (j) => PassportReadEvent.fromJson(j),
    // IdCardReadEvent: (j) => IdCardReadEvent.fromJson(j),
    // DriversLicenseReadEvent: (j) => DriversLicenseReadEvent.fromJson(j),
    // MrzEvent: (j) => MrzEvent.fromJson(j),
    // ErrorEvent: (j) => ErrorEvent.fromJson(j),
    SessionCreatedEvent.type: (j) => SessionCreatedEvent.fromJson(j),
    ScannedEvent.type: (j) => ScannedEvent.fromJson(j),
    IrmaInProgressEvent.type: (j) => IrmaInProgressEvent.fromJson(j),
  };

  final _eventSubject = PublishSubject<Event>();

  WebSocketChannel _websocketChannel;

  KioskRepository._internal() {
    _hostBase = "localhost:8080";
    _hostSecure = false;
    _websocketChannel = WebSocketChannel.connect(
        Uri.parse('${_hostSecure ? 'wss' : 'ws'}://$_hostBase/socket'));
    _listenToWebsocket();
  }

  Future<void> submitId() async {
    final result = await http.get(
        Uri.parse('${_hostSecure ? 'https' : 'http'}://$_hostBase/submit'));
    print(result);
  }

  void _listenToWebsocket() {
    _websocketChannel.stream.listen((json) {
      try {
        final jsonString = json as String;

        print(jsonString);

        final data = jsonDecode(jsonString) as Map<String, dynamic>;

        final eventName = data["type"];
        if (eventName == null) {
          debugPrint(
              "Received websocket message without type and payload $jsonString");
          return;
        }

        final unmarshaller = _eventUnmarshallers[eventName];
        if (unmarshaller == null) {
          debugPrint(
              "Unrecognized bridge event received: $eventName with payload $jsonString");
          return;
        }

        debugPrint("Received event with payload");
        final Event event = unmarshaller(data);
        dispatch(event);
      } catch (e) {
        debugPrint("Error receiving or parsing websocket message: $e");
      }
    });
  }

  void handleEvents(GlobalKey<NavigatorState> navigatorKey) {
    _eventSubject.stream.listen((event) {
      if (event is SessionCreatedEvent) {
        navigatorKey.currentState.pushNamed(Scanning.routeName);
      } else if (event is ScannedEvent) {
        idState.setPayload(event.value);
        navigatorKey.currentState.pushReplacementNamed(Succeeded.routeName);
        Future.delayed(const Duration(milliseconds: 1500)).then((_) {
          navigatorKey.currentState.pushReplacementNamed(Transfer.routeName);
        });
      } else if (event is MrzEvent) {
        print("--Pong event");
        navigatorKey.currentState.pushNamed(Scanning.routeName);
      } else if (event is ErrorEvent) {
        print("--ErrorEvent event");
        switch (event.errorCode) {
          case "no_internet":
            navigatorKey.currentState.pushNamed(NoInternet.routeName);
            break;
          case "scan_error":
            navigatorKey.currentState.pushNamed(ScanFail.routeName);
            break;
          case "invalid_id":
            navigatorKey.currentState.pushNamed(InvalidId.routeName);
            break;
        }
      }
    });
  }

  void dispatch(Event event, {bool isBridgedEvent = false}) {
    _eventSubject.add(event);

    if (isBridgedEvent) {
      final encodedEvent = jsonEncode(event);
      debugPrint("Sending event: $encodedEvent");

      _websocketChannel.sink.add(encodedEvent);
    }
  }

  void bridgedDispatch(Event event) {
    dispatch(event, isBridgedEvent: true);
  }
}
