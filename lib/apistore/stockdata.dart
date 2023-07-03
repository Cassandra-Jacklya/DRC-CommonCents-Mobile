import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
  'count': 956, //24 hours
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

Future<void> handleResponse(dynamic data, BuildContext context) async {
  final decodedData = jsonDecode(data);
  final List<Map<String, dynamic>> tickHistory = [];

  if (decodedData['msg_type'] == 'proposal') {
    late double buyingPrice;
    late double sellingPrice;
    late double capital;
    late double currentBalance;
    late double updatedBalance;

    final Map<String, dynamic> proposal = decodedData['proposal'];
    capital = decodedData['echo_req']['amount'].toDouble();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference collectionReference =
        firebaseFirestore.collection('users');

    // Retrieve the current balance of the user
    DocumentSnapshot userSnapshot =
        await collectionReference.doc(user!.uid).get();
    Map<String, dynamic>? userData =
        userSnapshot.data() as Map<String, dynamic>?;

    //deduct the capital users have invested
    if (userData != null) {
      currentBalance = userData['balance'].toDouble() ?? 0;
      updatedBalance = currentBalance - capital;
      collectionReference.doc(user.uid).update({'balance': updatedBalance});
    }

    // collectionReference.doc(user!.uid).update(
    //   { 'balance': 100 }
    // );

    buyingPrice = ticks.last['close'];
    await Future.delayed(const Duration(seconds: 3));
    sellingPrice = ticks.last['close'];

    if (buyingPrice < sellingPrice) {
        updatedBalance = updatedBalance + proposal['payout'];
        collectionReference.doc(user.uid).update({'balance': updatedBalance});
    } else {
      print("Buying: $buyingPrice\nSelling: $sellingPrice\nSo: you lost :(");
    }
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

void handleBuy(int ticks, String stakePayout, int currentAmount) {
  final PriceProposalRequest = {
    "proposal": 1,
    "amount": currentAmount,
    "basis": stakePayout,
    "contract_type": "CALL",
    "currency": "USD",
    "duration": ticks,
    "duration_unit": "t",
    "symbol": "R_100"
  };
  socket?.sink.add(jsonEncode(PriceProposalRequest));
}
