import 'dart:async';
import 'dart:convert';
import 'package:commoncents/cubit/miniChart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/formatMarkets.dart';

// WebSocketChannel? miniSocket;
WebSocketChannel? miniSocket;
final minichartCubit = MiniChartCubit();

const String appId = '1089';
final Uri url = Uri.parse(
    'wss://ws.binaryws.com/websockets/v3?app_id=$appId&l=EN&brand=deriv');
late Map<String, Map<String, dynamic>> marketData = {};
String? currentMarket;
final List<String> items = [
  'Volatility 10',
  'Volatility 25',
  'Volatility 50',
  'Volatility 75',
  'Volatility 100',
  'Volatility 10 (1S)',
  'Volatility 25 (1S)',
  'Volatility 50 (1S)',
  'Volatility 75 (1S)',
  'Volatility 100 (1S)',
  'Jump 10',
  'Jump 25',
  'Jump 50',
  'Jump 75',
  'Jump 100',
  'Bear Market',
  'Bull Market',
];

List<Map<String, dynamic>> mini = [];

final unsubscribeRequest = {"forget_all": "ticks"};

Map<String, dynamic> tickStream(String market) {
  Map<String, dynamic> request = {"ticks": market, "subscribe": 1};
  return request;
}

Map<String, dynamic> ticksHistoryRequest(String market) {
  Map<String, dynamic> request = {
    "ticks_history": "$market",
    "adjust_start_time": 1,
    "count": 10,
    "end": "latest",
    "start": 1,
    "style": "ticks"
  };
  return request;
}

Future<void> connectWebSocket(BuildContext context) async {
  miniSocket = WebSocketChannel.connect(url);

  miniSocket!.stream.listen(
    (dynamic message) {
      // Handle the received message
      handleMiniResponse(message, context);
    },
    onError: (error) {
      // Handle the error
      handleMiniError(error);
    },
    onDone: () {
      // Handle the connection closure
      handleMiniConnectionClosed();
    },
  );

  // Subscribe to mini ticks for each market
  for (final market in items) {
    subscribeMiniTicks(formatMarkets(market), miniSocket!);
  }
}

void closeMiniWebSocket() {
  miniSocket?.sink.close();
}

Future<void> subscribeMiniTicks(
    String market, WebSocketChannel miniSocket) async {
  await requestMiniTicksHistory(market, miniSocket);
  await miniTickSubscriber(market, miniSocket);
}

Future<void> miniTickSubscriber(
    String market, WebSocketChannel miniSocket) async {
  final request = tickStream(market);
  // print("Streaming $market ");
  miniSocket.sink.add(jsonEncode(request));
}

Future<void> requestMiniTicksHistory(
    String market, WebSocketChannel miniSocket) async {
  final request = ticksHistoryRequest(market);
  // print("Reuqesting $market history");
  miniSocket.sink.add(jsonEncode(request));
}

void handleMiniResponse(dynamic data, BuildContext context) {
  final decodedData = jsonDecode(data);
  if (decodedData['msg_type'] == 'history') {
    // Extract historical tick data
    final List<dynamic> prices = decodedData['history']['prices'];
    final List<dynamic> times = decodedData['history']['times'];

    final List<Map<String, dynamic>> miniHistory = [];

    for (int i = 0; i < prices.length; i++) {
      final double quote = prices[i].toDouble();
      final int epoch = times[i];

      DateTime utcTime =
          DateTime.fromMillisecondsSinceEpoch(epoch * 1000, isUtc: true);
      double utcTimeDouble = utcTime.millisecondsSinceEpoch.toDouble() / 1000;

      miniHistory.add({
        'close': quote,
        'epoch': utcTimeDouble,
      });
    }

    // Update marketData for the specific market
    currentMarket = decodedData['echo_req']['ticks_history'];
    marketData[currentMarket!] = {currentMarket!: miniHistory};

    final List<Map<String, dynamic>> combinedData = marketData.values.toList();
    // print(combinedData);
    final minichartCubit = BlocProvider.of<MiniChartCubit>(context);
    minichartCubit.updateMiniChart(combinedData);
  } else if (decodedData['msg_type'] == 'tick') {
    // Handle tick data
    final tickData = decodedData['tick'];
    if (tickData != null) {
      final double price = tickData['quote'].toDouble();
      final int time = tickData['epoch'];
      DateTime utcTime =
          DateTime.fromMillisecondsSinceEpoch(time * 1000, isUtc: true);
      double utcTimeDouble = utcTime.millisecondsSinceEpoch.toDouble() / 1000;

      final tickEntry = {'close': price, 'epoch': utcTimeDouble};

      final String tickSymbol = tickData['symbol'];

      // Add tick entry to all market lists
      for (final market in marketData.keys) {
        if (marketData[market] != null &&
            marketData[market]![tickSymbol] != null) {
          marketData[market]![tickSymbol]!.add(tickEntry);
          marketData[market]![tickSymbol]!.removeAt(0);
          final List<Map<String, dynamic>> combinedData =
              marketData.values.toList();
          // print(combinedData);
          minichartCubit.updateMiniChart(combinedData);
        }
      }
    }
  }
}

void handleMiniError(dynamic error) {
  print("Failed to get data: $error");
}

void handleMiniConnectionClosed() {
  // print("Connection closed");
}
