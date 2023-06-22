import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

WebSocketChannel? socket;
const String appId = '1089'; 
final Uri url = Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=$appId&l=EN&brand=deriv');

List<dynamic> history = [];

Future<void> connectToWebSocket() async {
  print("Connecting to ws....");
  socket = await WebSocketChannel.connect(url);
  print("Connected!");

  socket?.stream.listen((dynamic message) {
    try {
      final decodedData = jsonDecode(message);
      handleResponse(decodedData);
    } catch (e) {
      handleError(e);
    }
  }, onError: (error) {
    handleError(error);
  }, onDone: () {
    handleConnectionClosed();
  });
}

void subscribeToStream(String streamName) {
  final subscribeRequest = {
    'subscribe': streamName,
  };

  socket?.sink.add(jsonEncode(subscribeRequest));
}



void requestTicksHistory() {
  socket?.sink.add(jsonEncode(TicksHistoryRequest));
}

final TicksHistoryRequest = {
  'ticks_history': 'R_50',
  'adjust_start_time': 1,
  'count': 100,
  'end': 'latest',
  'start': 1,
  'style': 'candles',
};

void handleResponse(dynamic data) {
  history = data['candles'];
  print(history.length);
  print(history);
}

void handleError(dynamic error) {
  print("Failed to get data: $error");
}

void handleConnectionClosed() {
  print("Connection closed");
}

void main() {
  connectToWebSocket();
  requestTicksHistory();
}
