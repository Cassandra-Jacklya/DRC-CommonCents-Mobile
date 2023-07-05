import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:commoncents/cubit/candlestick_cubit.dart';

import '../apistore/PriceProposal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/stock_data_cubit.dart';

WebSocketChannel? socket;
late StockDataCubit stockDataCubit;
const String appId = '1089';
final Uri url = Uri.parse(
    'wss://ws.binaryws.com/websockets/v3?app_id=$appId&l=EN&brand=deriv');

final tickStream = {"ticks": "R_50", "subscribe": 1};

final unsubscribeRequest = {"forget_all": "ticks"};

// ignore: non_constant_identifier_names
final TicksHistoryRequest = {
  'ticks_history': 'R_50',
  'adjust_start_time': 1,
  'count': 956, //24 hours
  'end': 'latest',
  'start': 1,
  'style': 'candles',
};

// ignore: non_constant_identifier_names
final CandleTicksRequest = {
  "ticks_history": "R_50",
  "adjust_start_time": 1,
  "subscribe": 1,
  "count": 1,
  "end": "latest",
  "start": 1,
  "style": "candles"
};

// ignore: non_constant_identifier_names
final CandleHistoryRequest = {
  "ticks_history": "R_50",
  "adjust_start_time": 1,
  // "subscribe": 1,
  "count": 100,
  "end": "latest",
  "start": 1,
  "style": "candles"
};

List<Map<String, dynamic>> ticks = [];
List<Map<String, dynamic>> candles = [];

Future<void> connectToWebSocket(BuildContext context, bool isCandle) async {
  socket = WebSocketChannel.connect(url);

  socket?.stream.listen((dynamic message) {
    try {
      handleResponse(message, isCandle, context);
    } catch (e) {
      handleError(e);
    }
  }, onError: (error) {
    handleError(error);
  }, onDone: () {
    handleConnectionClosed();
  });

  if (isCandle) {
    subscribeCandleTicks();
  } else {
    subscribeTicks();
  }
}

void subscribeCandleTicks() async {
  await requestCandleHistory();
  await candleTicks();
}

Future<void> requestCandleHistory() async {
  socket?.sink.add(jsonEncode(CandleHistoryRequest));
}

Future<void> candleTicks() async {
  socket?.sink.add(jsonEncode(CandleTicksRequest));
}

void subscribeTicks() async {
  await requestTicksHistory();
  await tickSubscriber();
}

void unsubscribe() async {
  socket?.sink.add(jsonEncode(unsubscribeRequest));
  // stockDataCubit.clearStockData();
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

Future<void> handleResponse(
    dynamic data, bool isCandle, BuildContext context) async {
  final decodedData = jsonDecode(data);
  final List<Map<String, dynamic>> tickHistory = [];

  if (decodedData['msg_type'] == 'proposal') {
    handleBuyResponse(decodedData);
  } else if (decodedData['msg_type'] == 'ohlc') {
    //stream candles data
    final ohlc = decodedData['ohlc'];
    if (ohlc != null) {
      final double open = double.parse(ohlc['open']);
      final double high = double.parse(ohlc['high']);
      final double low = double.parse(ohlc['low']);
      final double close = double.parse(ohlc['close']);
      final double time = ohlc['open_time'].toDouble();
      // DateTime utcTime =
      //     DateTime.fromMillisecondsSinceEpoch(time * 1000, isUtc: true);
      // double utcTimeDouble = utcTime.millisecondsSinceEpoch.toDouble() / 1000;

      // Append the latest tick price and time to the ticks list
      candles.add({
        'high': high,
        'open': open,
        'close': close,
        'low': low,
        'epoch': time
      });

      final candleStickData = BlocProvider.of<CandlestickCubit>(context);
      candleStickData.updateCandlestickData(candles);
    }
  } else if (decodedData['msg_type'] == 'candles') {
    //history candles data
    if (isCandle) {
      final List<dynamic> legitCandles = decodedData['candles'];
      for (int i = 0; i < legitCandles.length; i++) {
        final candle = legitCandles[i];
        final int epoch = candle['epoch'];
        DateTime utcTime =
            DateTime.fromMillisecondsSinceEpoch(epoch * 1000, isUtc: true);
        double utcTimeDouble = utcTime.millisecondsSinceEpoch.toDouble() / 1000;
        final double high = candle['high'];
        final double low = candle['low'];
        final double close = candle['close'];
        final double open = candle['open'];

        candles.add({
          'high': high,
          'open': open,
          'close': close,
          'low': low,
          'epoch': utcTimeDouble
        });
      }

      final candleStickData = BlocProvider.of<CandlestickCubit>(context);
      candleStickData.updateCandlestickData(candles); // this is for line chart

    } else {
      //this is for line
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
    }
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
  stockDataCubit.updateStockData(ticks); // this is for line chart
}

void handleError(dynamic error) {
  print("Failed to get data: $error");
}

void handleConnectionClosed() {
  print("Connection closed");
}
