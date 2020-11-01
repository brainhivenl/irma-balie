import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:irmabalie/src/kiosk/screens/detected.dart';
import 'package:irmabalie/src/kiosk/screens/invalid_id.dart';
import 'package:irmabalie/src/kiosk/screens/initial.dart';
import 'package:irmabalie/src/kiosk/screens/no_internet.dart';
import 'package:irmabalie/src/kiosk/screens/no_transfer.dart';
import 'package:irmabalie/src/kiosk/screens/qr_scan.dart';
import 'package:irmabalie/src/kiosk/screens/scan_fail.dart';
import 'package:irmabalie/src/kiosk/screens/scanning.dart';
import 'package:irmabalie/src/kiosk/screens/transfer_in_progress.dart';
import 'package:irmabalie/src/kiosk/screens/transferred.dart';
import 'package:irmabalie/src/kiosk/screens/welcome.dart';
import 'package:irmabalie/src/kiosk/state/id_state.dart';
import 'package:irmabalie/src/kiosk/state/qr_state.dart';
import 'package:irmabalie/src/kiosk/screens/submitting.dart';
import 'package:irmabalie/src/kiosk/screens/succeeded.dart';
import 'package:irmabalie/src/kiosk/screens/transfer/transfer.dart';
import 'package:irmabalie/src/kiosk/state/websocket_state.dart';
import 'package:irmabalie/src/models/event.dart';
import 'package:irmabalie/src/models/kiosk_events.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

typedef EventUnmarshaller = Event Function(Map<String, dynamic>);

class KioskRepository {
  static KioskRepository _instance;
  IdState idState = IdState();
  QrState qrState = QrState();
  WebsocketState websocketState = WebsocketState();
  String _hostBase;
  bool _hostSecure;

  factory KioskRepository() {
    return _instance ??= KioskRepository._internal();
  }

  final Map<String, EventUnmarshaller> _eventUnmarshallers = {
    WebsocketConnectedEvent.type: (j) => WebsocketConnectedEvent.fromJson(j),
    WebsocketNotReadyEvent.type: (j) => WebsocketNotReadyEvent.fromJson(j),
    DetectedEvent.type: (j) => DetectedEvent.fromJson(j),
    ReinsertEvent.type: (j) => ReinsertEvent.fromJson(j),
    SessionCreatedEvent.type: (j) => SessionCreatedEvent.fromJson(j),
    ScannedEvent.type: (j) => ScannedEvent.fromJson(j),
    IrmaSessionSubmittedEvent.type: (j) =>
        IrmaSessionSubmittedEvent.fromJson(j),
    IrmaInProgressEvent.type: (j) => IrmaInProgressEvent.fromJson(j),
  };

  final _eventSubject = PublishSubject<Event>();

  WebSocketChannel _websocketChannel;
  StreamSubscription _websocketSubscription;

  KioskRepository._internal() {
    _hostBase = "localhost:8080";
    _hostSecure = false;

    _connectWebsocket();
  }

  Future<void> submitId() async {
    dispatch(IrmaTransferRequestedEvent());
    try {
      print("Loading IRMA session details from client");
      final result = await http.get(
          Uri.parse('${_hostSecure ? 'https' : 'http'}://$_hostBase/submit'));
      if (result.statusCode == 200) {
        dispatch(IrmaSessionReceivedEvent(data: result.body));
      } else {
        dispatch(IrmaSessionSubmitFailedEvent());
      }
    } catch (e) {
      dispatch(IrmaSessionSubmitFailedEvent());
    }
  }

  Future<void> _connectWebsocket() async {
    if (websocketState.isConnected()) {
      // we're trying to reconnect, notify the UI that we have been disconnected
      dispatch(WebsocketDisconnectedEvent());
    }

    final connectionString =
        '${_hostSecure ? 'wss' : 'ws'}://$_hostBase/socket';
    print("Attempting websocket connection with '$connectionString'...");
    if (_websocketChannel != null) {
      try {
        _websocketChannel.sink.close(1, "");
        _websocketSubscription.cancel();
      } catch(e) {}
      // wait a little while before we retry
      await Future.delayed(Duration(seconds: 3));
    }

    _websocketChannel = WebSocketChannel.connect(Uri.parse(connectionString));
    _websocketSubscription = _websocketChannel.stream.listen(_processWebsocketMessage,
        onDone: _connectWebsocket,
        onError: _processWebsocketError,
        cancelOnError: false);
  }

  Future<void> _processWebsocketError(dynamic error) async {
    print("Websocket connection error: $error");
    await _connectWebsocket();
  }

  void _processWebsocketMessage(dynamic json) {
    try {
      final jsonString = json as String;
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
  }

  void handleEvents(GlobalKey<NavigatorState> navigatorKey) {
    _eventSubject.stream.listen((event) {
      if (event is IrmaInProgressEvent) {
        if (event.value.status == 'INITIALIZED') {
          print("Session was started, waiting for app");
        } else if (event.value.status == 'CONNECTED') {
          if (!qrState.isTransfering()) {
            qrState.setIsTransfering(true);
            navigatorKey.currentState
                .pushReplacementNamed(TransferInProgress.routeName);
          }
        } else if (event.value.status == 'DONE') {
          qrState.setIsTransfering(false);
          navigatorKey.currentState.pushReplacementNamed(Transferred.routeName);
        } else if (event.value.status == 'CANCELLED') {
          qrState.setIsTransfering(false);
          navigatorKey.currentState.pushReplacementNamed(NoTransfer.routeName);
        } else if (event.value.status == 'TIMEOUT') {
          qrState.setIsTransfering(false);
          navigatorKey.currentState.pushReplacementNamed(NoTransfer.routeName);
        } else {
          print("Unknown irma event: ${event.value.status}");
        }
      } else if (event is IrmaTransferRequestedEvent) {
        navigatorKey.currentState.pushNamed(Submitting.routeName);
      } else if (event is IrmaSessionReceivedEvent) {
        qrState.setQrData(event.data);
        navigatorKey.currentState.pushReplacementNamed(QrScan.routeName);
      } else if (event is SessionCreatedEvent) {
        navigatorKey.currentState.pushNamed(Scanning.routeName);
      } else if (event is DetectedEvent) {
        navigatorKey.currentState.pushNamed(Detected.routeName);
      } else if (event is IrmaSessionSubmitFailedEvent) {
        navigatorKey.currentState.pushNamed(NoTransfer.routeName);
      } else if (event is ReinsertEvent) {
        navigatorKey.currentState.pushNamed(ScanFail.routeName);
      } else if (event is ScannedEvent) {
        idState.setPayload(event.value);
        navigatorKey.currentState.pushReplacementNamed(Succeeded.routeName);
        Future.delayed(const Duration(milliseconds: 1500)).then((_) {
          navigatorKey.currentState.pushReplacementNamed(Transfer.routeName);
        });
      } else if (event is WebsocketConnectedEvent) {
        // only if the UI is loaded (because the UI assumes that it is connected by default)
        websocketState.setIsConnected(true);
        debugPrint("Connected");
        if (navigatorKey.currentState != null) {
          navigatorKey.currentState
              .pushNamed(Welcome.routeName);
        } else {
          Future.delayed(const Duration(milliseconds: 500)).then((_) {
            navigatorKey.currentState
              .pushNamed(Welcome.routeName);
          });
        }
      } else if (event is WebsocketNotReadyEvent) {
        websocketState.setIsConnected(false);
        if (navigatorKey.currentState != null) {
          navigatorKey.currentState
                .popUntil(ModalRoute.withName(Initial.routeName));
        }
        Future.delayed(const Duration(milliseconds: 500)).then((_) {
          _connectWebsocket();
        });
      } else if (event is WebsocketDisconnectedEvent) {
        // wait for the UI to load before we handle this event
        websocketState.setIsConnected(false);
        if (navigatorKey.currentState != null) {
          navigatorKey.currentState
              .pushNamed(NoInternet.routeName);
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
