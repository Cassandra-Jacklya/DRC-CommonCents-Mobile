import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

WebSocketChannel? socket;
const String appId = '1089';
final Uri url = Uri.parse(
    'wss://ws.binaryws.com/websockets/v3?app_id=$appId&l=EN&brand=deriv');

final tickStream = {"ticks": "R_50", "subscribe": 1};

final TicksHistoryRequest = {
  'ticks_history': 'R_50',
  'adjust_start_time': 1,
  'count': 2,
  'end': 'latest',
  'start': 1,
  'style': 'candles',
};

List<dynamic> ticks = [];

Future<void> connectToWebSocket() async {
  socket = WebSocketChannel.connect(url);
  print("Connectedto websocket!");

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

  subscribeTicks();
}

void subscribeTicks() async {
  await requestTicksHistory();
  await tickSubscriber();
}

void closeWebSocket() {
  socket?.sink.close();
}

Future<void> tickSubscriber() async {
  socket?.sink.add(jsonEncode(tickStream));
}

Future<void> requestTicksHistory() async {
  socket?.sink.add(jsonEncode(TicksHistoryRequest));
}



void handleResponse(dynamic data) {
  final decodedData = jsonDecode(data);

  if (decodedData['msg_type'] == 'candles') {
    final List<dynamic> candles = decodedData['candles'];
    if (candles != null) {
      final List<Map<String, dynamic>> tickHistory = [];
      for (int i = 0; i < candles.length; i++) {
        final candle = candles[i];
        final double close = candle['close'];
        final double open = candle['open'];

        tickHistory.add({'open': open, 'close': close});
      }

      
      ticks = tickHistory;
    }
  } else if (decodedData['msg_type'] == 'tick') {
    final tickData = decodedData['tick'];
    if (tickData != null) {
      final double price = tickData['quote'];
      final int time = tickData['epoch'];

      // Append the latest tick price and time to the ticks list
      ticks.add({'quote': price, 'epoch': time});
    }
  }

  print("New data: ${ticks.toString()}");
}

void handleError(dynamic error) {
  print("Failed to get data: $error");
}

void handleConnectionClosed() {
  print("Connection closed");
}
