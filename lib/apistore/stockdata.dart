import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

WebSocketChannel? socket;
const String appId = '1089';
final Uri url = Uri.parse(
    'wss://ws.binaryws.com/websockets/v3?app_id=$appId&l=EN&brand=deriv');

StreamSubscription<dynamic>? subscription;

List<dynamic> history = [];

Future<void> connectToWebSocket() async {
  print("Connecting to ws....");
  socket = WebSocketChannel.connect(url);
  print("Connected!");

  socket?.stream.listen((dynamic message) {
    try {
      handleResponse(message);
    } catch (e) {
      handleError(e);
    }
  }, onError: (error) {
    handleError(error);
  }, onDone: () {
    handleConnectionClosed();
  });
}


Future<void> subscribeTicks() async {
  socket?.sink.add(jsonEncode(tickStream));
}

Future<void> requestTicksHistory() async {
  socket?.sink.add(jsonEncode(TicksHistoryRequest));
}

final tickStream = {"ticks": "R_50", "subscribe": 1};

final TicksHistoryRequest = {
  'ticks_history': 'R_50',
  'adjust_start_time': 1,
  'count': 100,
  'end': 'latest',
  'start': 1,
  'style': 'candles',
};

void handleResponse(dynamic data) {
  print("Handling response: $data");
}

void handleError(dynamic error) {
  print("Failed to get data: $error");
}

void handleConnectionClosed() {
  print("Connection closed");
}
