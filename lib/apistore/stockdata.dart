import 'dart:async';
import 'dart:convert';
import 'package:commoncents/cubit/candlestick_cubit.dart';
import 'package:commoncents/cubit/miniChart_cubit.dart';
import '../apistore/PriceProposal.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/stock_data_cubit.dart';

WebSocketChannel? socket;
late StockDataCubit stockDataCubit;
const String appId = '1089';
final Uri url = Uri.parse(
    'wss://ws.binaryws.com/websockets/v3?app_id=$appId&l=EN&brand=deriv');

List<Map<String, dynamic>> ticks = [];
List<Map<String, dynamic>> candles = [];

final unsubscribeRequest = {"forget_all": "ticks"};

final unsubscribeCandleRequest = {"forget_all" : "candles"};


Map<String, dynamic> tickStream(String market) {
  Map<String, dynamic> request = {"ticks": market, "subscribe": 1};
  return request;
}

Map<String, dynamic> ticksHistoryRequest(
    String market, String selectedTimeUnit) {
  late int granularity;
  if (selectedTimeUnit == "Ticks") {
    Map<String, dynamic> request = {
      "ticks_history": market,
      "adjust_start_time": 1,
      "count": 100,
      "end": "latest",
      "start": 1680040550,
      "style": "ticks"
    };
    return request;
  } else if (selectedTimeUnit == "Minutes") {
    granularity = 60;
    Map<String, dynamic> request = {
      "ticks_history": market,
      "adjust_start_time": 1,
      "count": 100,
      "end": "latest",
      "granularity": granularity,
      "start": 1680040550,
      "style": "candles"
    };
    return request;
  } else if (selectedTimeUnit == "Hours") {
    granularity = 3600;
    Map<String, dynamic> request = {
      "ticks_history": market,
      "adjust_start_time": 1,
      "count": 100,
      "end": "latest",
      "granularity": granularity,
      "start": 1680040550,
      "style": "candles"
    };
    return request;
  } else if (selectedTimeUnit == "Days") {
    granularity = 86400;
    Map<String, dynamic> request = {
      "ticks_history": market,
      "adjust_start_time": 1,
      "count": 100,
      "end": "latest",
      "granularity": granularity,
      "start": 1680040550,
      "style": "candles"
    };
    return request;
  } else {
    return {};
  }
}

Map<String, dynamic> CandleHistoryRequest(
    String market, String selectedTimeUnit) {
  late int granularity;
  if (selectedTimeUnit == "Minutes") {
    granularity = 60;
  } else if (selectedTimeUnit == "Hours") {
    print("yesrrisss");
    granularity = 3600;
  } else if (selectedTimeUnit == "Days") {
    granularity = 86400;
  }
  Map<String, dynamic> request = {
    "ticks_history": market,
    "adjust_start_time": 1,
    "granularity": granularity,
    "count": 100,
    "end": "latest",
    "start": 1680040550,
    "style": "candles"
  };

  return request;
}

Map<String, dynamic> CandleTicksRequest(
    String market, String selectedTimeUnit) {
  Map<String, dynamic> request = {
    "ticks_history": market,
    "adjust_start_time": 1,
    "subscribe": 1,
    "count": 1,
    "end": "latest",
    "start": 1680040550,
    "style": "candles"
  };

  return request;
}

Future<void> connectToWebSocket(
    {required BuildContext context,
    required bool isCandle,
    required String market,
    required String selectedTimeUnit}) async {
  socket = WebSocketChannel.connect(url);

  socket?.stream.listen((dynamic message) {
    try {
      handleResponse(
          data: message,
          isCandle: isCandle,
          context: context,
          selectedTimeUnit: selectedTimeUnit);
    } catch (e) {
      handleError(e);
    }
  }, onError: (error) {
    handleError(error);
  }, onDone: () {
    handleConnectionClosed();
  });

  if (isCandle) {
    subscribeCandleTicks(market, selectedTimeUnit);
  } else {
    subscribeTicks(market, selectedTimeUnit);
  }
}

void subscribeCandleTicks(String market, String selectedTimeUnit) async {
  await requestCandleHistory(market, selectedTimeUnit);
  await candleTicks(market, selectedTimeUnit);
}

Future<void> requestCandleHistory(
    String market, String selectedTimeUnit) async {
  final request = CandleHistoryRequest(market, selectedTimeUnit);
  socket?.sink.add(jsonEncode(request));
}

Future<void> candleTicks(String market, String selectedTimeUnit) async {
  final request = CandleTicksRequest(market, selectedTimeUnit);
  socket?.sink.add(jsonEncode(request));
}

void subscribeTicks(String market, String selectedTimeUnit) async {
  await requestTicksHistory(market, selectedTimeUnit);
  await tickSubscriber(market);
}

void unsubscribe() async {
  socket?.sink.add(jsonEncode(unsubscribeRequest));
  // stockDataCubit.clearStockData();
}

void unsubscribeCandle() async{
  socket?.sink.add(jsonEncode(unsubscribeCandleRequest));
  print("unsubscribed");
}

void closeWebSocket() {
  socket?.sink.close();
}

Future<void> tickSubscriber(String market) async {
  final request = tickStream(market);
  socket?.sink.add(jsonEncode(request));
}

Future<void> requestTicksHistory(String market, String selectedTimeUnit) async {
  final request = ticksHistoryRequest(market, selectedTimeUnit);
  socket?.sink.add(jsonEncode(request));
}

Future<void> handleResponse(
    {required BuildContext context,
    required bool isCandle,
    required dynamic data,
    required String selectedTimeUnit}) async {
  final decodedData = jsonDecode(data);
  final List<Map<String, dynamic>> tickHistory = [];
  final stockDataCubit = BlocProvider.of<StockDataCubit>(context);

  if (decodedData['msg_type'] == 'proposal') {
    handleBuyResponse(context, decodedData);
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
        final DateTime lastTime =
            DateTime.fromMillisecondsSinceEpoch(lastEpoch.toInt() * 1000);
        final DateTime currentTime =
            DateTime.fromMillisecondsSinceEpoch(time.toInt() * 1000);

        if (selectedTimeUnit == 'Minutes') {
          if (currentTime.minute == lastTime.minute) {
            // They are in the same minute
                  print("I am candle $selectedTimeUnit");
            lastItem['high'] = high;
            lastItem['low'] = low;
            lastItem['close'] = close;
          } else {
            // They are in different minutes
            candles.add({
              'high': high,
              'open': open,
              'close': close,
              'low': low,
              'epoch': time,
            });
          }
        }
        if (selectedTimeUnit == 'Hours') {
          if (currentTime.hour == lastTime.hour) {
            // They are in the same minute
                  print("I am candle $selectedTimeUnit");
            lastItem['high'] = high;
            lastItem['low'] = low;
            lastItem['close'] = close;
          } else {
            // They are in different minutes
            candles.add({
              'high': high,
              'open': open,
              'close': close,
              'low': low,
              'epoch': time,
            });
          }
        }
        if (selectedTimeUnit == 'Days') {
          if (currentTime.day == lastTime.day) {
            print("I am candle $selectedTimeUnit");
            // They are in the same minute
            lastItem['high'] = high;
            lastItem['low'] = low;
            lastItem['close'] = close;
          } else {
            // They are in different minutes
            candles.add({
              'high': high,
              'open': open,
              'close': close,
              'low': low,
              'epoch': time,
            });
          }
        }
      } else {
        null;
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
        final double high = candle['high'].toDouble();
        final double low = candle['low'].toDouble();
        final double close = candle['close'].toDouble();
        final double open = candle['open'].toDouble();

        candles.add({
          'high': high,
          'open': open,
          'close': close,
          'low': low,
          'epoch': utcTimeDouble
        });
      }
      if (candles.length > 101) {
        candles = candles.sublist(candles.length - 101);
      }

      final candleStickData = BlocProvider.of<CandlestickCubit>(context);
      candleStickData.updateCandlestickData(candles);
    } else {
      //history for ticks (Minutes / Hours / Days)
      final List<dynamic> data = decodedData['candles'];
      for (int i = 0; i < data.length; i++) {
        final point = data[i];
        final int epoch = point['epoch'];
        DateTime utcTime =
            DateTime.fromMillisecondsSinceEpoch(epoch * 1000, isUtc: true);
        double utcTimeDouble = utcTime.millisecondsSinceEpoch.toDouble() / 1000;
        final double price = point['close'].toDouble();

        tickHistory.add({'close': price, 'epoch': utcTimeDouble});
        ticks = tickHistory;
      }
    }
  } else if (decodedData['msg_type'] == 'history') {
    //lines history
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
      final double price = tickData['quote'].toDouble();
      final int time = tickData['epoch'];
      DateTime utcTime =
          DateTime.fromMillisecondsSinceEpoch(time * 1000, isUtc: true);
      double utcTimeDouble = utcTime.millisecondsSinceEpoch.toDouble() / 1000;

      if (selectedTimeUnit == "Minutes") {
        print("Ticks in $selectedTimeUnit");
        final lastTick = ticks.last;
        final lastTickEpoch = lastTick['epoch'] as double;
        final lastTickTime =
            DateTime.fromMillisecondsSinceEpoch(lastTickEpoch.toInt() * 1000);

        final newTickTime =
            DateTime.fromMillisecondsSinceEpoch(utcTimeDouble.toInt() * 1000);

        print(
            "Previous ${lastTickTime.minute} & Current ${newTickTime.minute}");

        if (lastTickTime.minute == newTickTime.minute) {
          lastTick['close'] = price;
          stockDataCubit.updateSameStockData(ticks);
          if (ticks.length >= 2) {
            final lastTwoItems = ticks.sublist(ticks.length - 2);
            print("Last two items in ticks: $lastTwoItems");
          }
          // print("data :$ticks");
          return;
        } else {
          final newTick = {'close': price, 'epoch': utcTimeDouble};
          ticks.add(newTick);
          stockDataCubit.updateStockData(ticks);
        }

        // Print the last two items from ticks
        if (ticks.length >= 2) {
          final lastTwoItems = ticks.sublist(ticks.length - 2);
          print("Last two items in ticks: $lastTwoItems");
        } else {
          ticks.add({'close': price, 'epoch': utcTimeDouble});
          stockDataCubit.updateStockData(ticks);
        }
      } else if (selectedTimeUnit == "Hours") {
        print("Ticks in $selectedTimeUnit");

        final lastTick = ticks.last;
        final lastTickEpoch = lastTick['epoch'] as double;
        final lastTickTime =
            DateTime.fromMillisecondsSinceEpoch(lastTickEpoch.toInt() * 1000);

        final newTickTime =
            DateTime.fromMillisecondsSinceEpoch(utcTimeDouble.toInt() * 1000);

        if (lastTickTime.hour == newTickTime.hour) {
          // Update the close price of the last tick
          lastTick['close'] = price;
          stockDataCubit.updateStockData(ticks);
          return;
        } else {
          // Append the latest tick price and time to the ticks list
          ticks.add({'close': price, 'epoch': utcTimeDouble});
        }
      } else if (selectedTimeUnit == "Days") {
        print("Ticks in $selectedTimeUnit");

        final lastTick = ticks.last;
        final lastTickEpoch = lastTick['epoch'] as double;
        final lastTickTime =
            DateTime.fromMillisecondsSinceEpoch(lastTickEpoch.toInt() * 1000);

        final newTickTime =
            DateTime.fromMillisecondsSinceEpoch(utcTimeDouble.toInt() * 1000);

        if (lastTickTime.day == newTickTime.day) {
          // Update the close price of the last tick
          lastTick['close'] = price;
          stockDataCubit.updateStockData(ticks);
          return;
        } else {
          ticks.add({'close': price, 'epoch': utcTimeDouble});
          stockDataCubit.updateStockData(ticks);
        }
      } else if (selectedTimeUnit == "Ticks") {
        ticks.add({'close': price, 'epoch': utcTimeDouble});
        stockDataCubit.updateStockData(ticks); // this is for line chart
      }
    }
  }
}

void handleError(dynamic error) {
  print("Failed to get data: $error");
}

void handleConnectionClosed() {
  print("Connection closed");
}
