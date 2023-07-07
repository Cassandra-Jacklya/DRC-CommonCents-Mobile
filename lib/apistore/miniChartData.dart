import 'dart:async';
import 'dart:convert';
import 'package:commoncents/cubit/miniChart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

WebSocketChannel? miniSocket;
MiniChartCubit miniChartCubit = MiniChartCubit();
const String appId = '1089';
final Uri url = Uri.parse(
    'wss://ws.binaryws.com/websockets/v3?app_id=$appId&l=EN&brand=deriv');

List<Map<String, dynamic>> mini = [];

final unsubscribeRequest = {"forget_all": "ticks"};

Map<String, dynamic> tickStream(String market, WebSocketChannel miniSocket) {
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

WebSocketChannel connectWebSocketForMarket(
  String market,
  BuildContext context,
  Map<String, Map<String, dynamic>> marketData,
) {
  final Uri url = Uri.parse(
    'wss://ws.binaryws.com/websockets/v3?app_id=$appId&l=EN&brand=deriv&market=$market',
  );

  WebSocketChannel miniSocket = WebSocketChannel.connect(url);

  miniSocket.stream.listen(
    (dynamic message) {
      // Handle the received message
      handleMiniResponse(message, context, miniSocket, market, marketData);
      // print(message);
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

  // Subscribe to mini ticks for the specific market
  subscribeMiniTicks(market, miniSocket);

  return miniSocket;
}

Future<void> subscribeMiniTicks(
    String market, WebSocketChannel miniSocket) async {
  await requestMiniTicksHistory(market, miniSocket);
  await miniTickSubscriber(market, miniSocket);
}

void closeMiniWebSocket() {
  miniSocket?.sink.close();
}

Future<void> miniTickSubscriber(
    String market, WebSocketChannel miniSocket) async {
  print("Now asking: $market");
  final request = tickStream(market, miniSocket);
  miniSocket.sink.add(jsonEncode(request));
}

Future<void> requestMiniTicksHistory(
    String market, WebSocketChannel miniSocket) async {
  // print("Getting history: $market");

  final request = ticksHistoryRequest(market);
  miniSocket.sink.add(jsonEncode(request));
}

void handleMiniResponse(
    dynamic data,
    BuildContext context,
    WebSocketChannel miniSocket,
    String market,
    Map<String, Map<String, dynamic>> marketData) {
  final decodedData = jsonDecode(data);
  // print("Here: $decodedData");
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

    marketData[market] = {market: miniHistory};

    final List<Map<String, dynamic>> combinedData = marketData.values.toList();
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
      for (var market in marketData.keys) {
        if (marketData[market] == null) {
          marketData[market] = {};
        }
        if (marketData[market]![tickSymbol] == null) {
          marketData[market]![tickSymbol] = [];
        }
        marketData[market]![tickSymbol]!.add(tickEntry);
      }

      // print(marketData[market]![tickSymbol].length);
      marketData[market]![tickSymbol]!.removeAt(0);

      final List<Map<String, dynamic>> combinedData =
          marketData.values.toList();
      final minichartCubit = BlocProvider.of<MiniChartCubit>(context);
      minichartCubit.updateMiniChart(combinedData);
    }
  }

  // } else if (decodedData['msg_type'] == 'tick') {
  //   // Handle tick data
  //   final tickData = decodedData['tick'];
  //   if (tickData != null) {
  //     final double price = tickData['quote'].toDouble();
  //     final int time = tickData['epoch'];
  //     DateTime utcTime =
  //         DateTime.fromMillisecondsSinceEpoch(time * 1000, isUtc: true);
  //     double utcTimeDouble = utcTime.millisecondsSinceEpoch.toDouble() / 1000;

  //     final String ticksHistory = tickData['symbol'];

  //     final tickEntry = {'close': price, 'epoch': utcTimeDouble};

  //     if (marketData.containsKey(ticksHistory)) {
  //       marketData[ticksHistory]!.add(tickEntry);
  //     } else {
  //       marketData[ticksHistory] = [tickEntry];
  //     }

  // final List<List<Map<String, dynamic>>> combinedData =
  //     marketData.values.toList();
  // final minichartCubit = BlocProvider.of<MiniChartCubit>(context);
  // minichartCubit.updateMiniChart(combinedData);
  //   }
  // }
}

void handleMiniError(dynamic error) {
  print("Failed to get data: $error");
}

void handleMiniConnectionClosed() {
  print("Connection closed");
}
