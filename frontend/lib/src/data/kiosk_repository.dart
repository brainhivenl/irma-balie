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

typedef EventUnmarshaller = Event Function(Map<String, dynamic>);

class KioskRepository {
  static KioskRepository _instance;
  IdState idState = IdState();

  factory KioskRepository() {
    return _instance ??= KioskRepository._internal();
  }

  final Map<Type, EventUnmarshaller> _eventUnmarshallers = {
    PassportReadEvent: (j) => PassportReadEvent.fromJson(j),
    IdCardReadEvent: (j) => IdCardReadEvent.fromJson(j),
    DriversLicenseReadEvent: (j) => DriversLicenseReadEvent.fromJson(j),
    MrzEvent: (j) => MrzEvent.fromJson(j),
    ErrorEvent: (j) => ErrorEvent.fromJson(j),
  };

  final Map<String, EventUnmarshaller> _eventUnmarshallerLookup = {};
  final _eventSubject = PublishSubject<Event>();

  WebSocketChannel _websocketChannel;

  KioskRepository._internal() {
    // Create a lookup of unmarshallers
    _eventUnmarshallerLookup.addAll(
      _eventUnmarshallers.map(
        (Type t, EventUnmarshaller u) =>
            MapEntry<String, EventUnmarshaller>(t.toString(), u),
      ),
    );

    _websocketChannel =
        WebSocketChannel.connect(Uri.parse('ws://localhost:8080'));
    _listenToWebsocket();
  }

  // PingEvent is only for testing, for triggering the backend
  void sendPingEvent() {
    bridgedDispatch(PingEvent());
  }

  void _listenToWebsocket() {
    _websocketChannel.stream.listen((json) {
      try {
        final jsonString = json as String;

//        print(jsonString);

        final data = jsonDecode(jsonString) as Map<String, dynamic>;

        final eventName = data["type"];
        if (eventName == null) {
          debugPrint(
              "Received websocket message without type and payload $jsonString");
          return;
        }

        final unmarshaller = _eventUnmarshallerLookup[eventName];
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
      if (event is MrzEvent) {
        print("--Pong event");
        navigatorKey.currentState.pushNamed(Scanning.routeName);
      } else if (event is PassportReadEvent) {
        print("--PassportReadEvent event");
        idState.setPassportScanState(event);
        navigatorKey.currentState.pushNamed(Succeeded.routeName);
        Future.delayed(const Duration(milliseconds: 1500)).then((_) {
          navigatorKey.currentState.pushNamed(Transfer.routeName);
        });
      } else if (event is IdCardReadEvent) {
        print("--IdCardReadEvent event");
        idState.setIdCardScanState(event);
        navigatorKey.currentState.pushNamed(Succeeded.routeName);
        Future.delayed(const Duration(milliseconds: 1500)).then((_) {
          navigatorKey.currentState.pushNamed(Transfer.routeName);
        });
      } else if (event is DriversLicenseReadEvent) {
        print("--DriversLicenseReadEvent event");
        idState.setDriversLicenseScanState(event);
        navigatorKey.currentState.pushNamed(Succeeded.routeName);
        Future.delayed(const Duration(milliseconds: 1500)).then((_) {
          navigatorKey.currentState.pushNamed(Transfer.routeName);
        });
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
