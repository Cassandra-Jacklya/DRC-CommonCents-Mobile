import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/stock_data_cubit.dart';

WebSocketChannel? socket;
const String appId = '1089';
final Uri url = Uri.parse(
    'wss://ws.binaryws.com/websockets/v3?app_id=$appId&l=EN&brand=deriv');

final tickStream = {"ticks": "R_50", "subscribe": 1};

final TicksHistoryRequest = {
  'ticks_history': 'R_50',
  'adjust_start_time': 1,
  'count': 10,
  'end': 'latest',
  'start': 1,
  'style': 'candles',
};

List<Map<String, dynamic>> ticks = [];

Future<void> connectToWebSocket(BuildContext context) async {
  socket = WebSocketChannel.connect(url);
  print("Connected to websocket!");

  socket?.stream.listen((dynamic message) {
    try {
      // print("this is message: $message");
      handleResponse(message, context);
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

void handleResponse(dynamic data, BuildContext context) {
  final decodedData = jsonDecode(data);
  // print("Handle response: $decodedData");
  final List<Map<String, dynamic>> tickHistory = [];

  if (decodedData['msg_type'] == 'candles') {
    final List<dynamic> candles = decodedData['candles'];
    for (int i = 0; i < candles.length; i++) {
      final candle = candles[i];
      final int epoch = candle['epoch'];
      DateTime utcTime =
          DateTime.fromMillisecondsSinceEpoch(epoch * 1000, isUtc: true);
      double utcTimeDouble = utcTime.millisecondsSinceEpoch.toDouble() / 1000;

      // final double high = candle['high'];
      // final double low = candle['low'];
      final double close = candle['close'];
      // final double open = candle['open'];

      tickHistory.add({
        // 'high': high,
        // 'open': open,
        'close': close,
        // 'low': low,
        'epoch': utcTimeDouble
      });
    }

    ticks = tickHistory;
    // print("New ticks data: $ticks");
  } else if (decodedData['msg_type'] == 'tick') {
    final tickData = decodedData['tick'];
    if (tickData != null) {
      final double price = tickData['quote'];
      final int time = tickData['epoch'];
      DateTime utcTime =
          DateTime.fromMillisecondsSinceEpoch(time * 1000, isUtc: true);
      double utcTimeDouble = utcTime.millisecondsSinceEpoch.toDouble() / 1000;

      // Append the latest tick price and time to the ticks list
      ticks.add({'close': price, 'epoch': utcTimeDouble});
    }
  }

  final stockDataCubit = BlocProvider.of<StockDataCubit>(context);
  stockDataCubit.updateStockData(ticks);
}

void handleError(dynamic error) {
  print("Failed to get data: $error");
}

void handleConnectionClosed() {
  print("Connection closed");
}
