import 'dart:async';
import 'dart:convert';
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

final TicksHistoryRequest = {
  'ticks_history': 'R_50',
  'adjust_start_time': 1,
  'count': 956, //24 hours
  'end': 'latest',
  'start': 1,
  'style': 'candles',
};

List<Map<String, dynamic>> ticks = [];

Future<void> connectToWebSocket(BuildContext context, bool isCandle) async {
  socket = WebSocketChannel.connect(url);

  socket?.stream.listen((dynamic message) {
    try {
      handleResponse(message, context);
    } catch (e) {
      handleError(e);
    }
  }, onError: (error) {
    handleError(error);
  }, onDone: () {
    handleConnectionClosed();
  });

  if(isCandle){
    print(isCandle);
  }
  subscribeTicks();
}

void subscribeTicks() async {
  await requestTicksHistory();
  await tickSubscriber();
}

void unsubscribe() async{
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

Future<void> handleResponse(dynamic data, BuildContext context) async {
  final decodedData = jsonDecode(data);
  final List<Map<String, dynamic>> tickHistory = [];

  if (decodedData['msg_type'] == 'proposal') {
    handleBuyResponse(decodedData);
  } else if (decodedData['msg_type'] == 'candles') {
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

