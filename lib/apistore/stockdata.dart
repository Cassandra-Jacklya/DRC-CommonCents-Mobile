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

Map<String, dynamic> tickStream(String market) {
  Map<String, dynamic> request = {"ticks": market, "subscribe": 1};
  return request;
}

final unsubscribeRequest = {"forget_all": "ticks"};

Map<String, dynamic> ticksHistoryRequest(String market) {
  Map<String, dynamic> request = {
    "ticks_history": "$market",
    "adjust_start_time": 1,
    "count": 100,
    "end": "latest",
    "start": 1,
    "style": "ticks"
  };
  return request;
}

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
  "count": 100,
  "end": "latest",
  "start": 1,
  "style": "candles"
};

List<Map<String, dynamic>> ticks = [];
List<Map<String, dynamic>> candles = [];

Future<void> connectToWebSocket(
    BuildContext context, bool isCandle, String market) async {
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
    subscribeTicks(market);
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

void subscribeTicks(String market) async {
  print("This now: $market");
  await requestTicksHistory(market);
  await tickSubscriber(market);
}

void unsubscribe() async {
  print("unsuscribing");
  socket?.sink.add(jsonEncode(unsubscribeRequest));
  // stockDataCubit.clearStockData();
}

void closeWebSocket() {
  socket?.sink.close();
}

Future<void> tickSubscriber(String market) async {
  final request = tickStream(market);
  socket?.sink.add(jsonEncode(request));
}

Future<void> requestTicksHistory(String market) async {
  final request = ticksHistoryRequest(market);
  socket?.sink.add(jsonEncode(request));
}

Future<void> handleResponse(
    dynamic data, bool isCandle, BuildContext context) async {
  final decodedData = jsonDecode(data);
  final List<Map<String, dynamic>> tickHistory = [];

  if (decodedData['msg_type'] == 'proposal') {
    handleBuyResponse(decodedData);
  } else if (decodedData['msg_type'] == 'ohlc') {
    // Stream candles data
    final ohlc = decodedData['ohlc'];
    if (ohlc != null) {
      final double open = double.parse(ohlc['open']);
      final double high = double.parse(ohlc['high']);
      final double low = double.parse(ohlc['low']);
      final double close = double.parse(ohlc['close']);
      final double time = ohlc['open_time'].toDouble();

      if (candles.isNotEmpty) {
        final lastItem = candles.last;
        final double lastEpoch = lastItem['epoch'];

        if (time == lastEpoch) {
          lastItem['high'] = high;
          lastItem['low'] = low;
          lastItem['close'] = close;
          // lastItem['open'] = open;
        } else {
          candles.add({
            'high': high,
            'open': open,
            'close': close,
            'low': low,
            'epoch': time,
          });
        }
      } else {
        candles.add({
          'high': high,
          'open': open,
          'close': close,
          'low': low,
          'epoch': time,
        });
      }

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
    }
  } else if (decodedData['msg_type'] == 'history') {
    final List<dynamic> prices = decodedData['history']['prices'];
    final List<dynamic> times = decodedData['history']['times'];

    for (int i = 0; i < prices.length; i++) {
      final double quote = prices[i].toDouble();
      final int epoch = times[i];

      DateTime utcTime =
          DateTime.fromMillisecondsSinceEpoch(epoch * 1000, isUtc: true);
      double utcTimeDouble = utcTime.millisecondsSinceEpoch.toDouble() / 1000;

      tickHistory.add({
        'close': quote,
        'epoch': utcTimeDouble,
      });
    }

    ticks = tickHistory;
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
    print(ticks.last);
    print(ticks.length);
    final stockDataCubit = BlocProvider.of<StockDataCubit>(context);
    stockDataCubit.updateStockData(ticks); // this is for line chart
  }
}

void handleError(dynamic error) {
  print("Failed to get data: $error");
}

void handleConnectionClosed() {
  print("Connection closed");
}
