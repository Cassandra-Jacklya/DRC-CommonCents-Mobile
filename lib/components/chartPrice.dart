import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../cubit/candlePrice_cubit.dart';
import '../cubit/livelinePrice_cubit.dart';

class ChartPrice extends StatefulWidget {
  final String market;

  ChartPrice({required this.market});

  _ChartPriceState createState() => _ChartPriceState();
}

class _ChartPriceState extends State<ChartPrice> {
  late List<Map<String, dynamic>> ohlc;
  WebSocketChannel? socket;
  static const String appId = '1089';
  final Uri url = Uri.parse(
      'wss://ws.binaryws.com/websockets/v3?app_id=$appId&l=EN&brand=deriv');

  Map<String, dynamic> request() {
    Map<String, dynamic> request = {
      "ticks_history": widget.market,
      "subscribe": 1,
      "end": "latest",
      "style": "candles"
    };
    return request;
  }

  Future<void> connectToWebSocket() async {
    socket = WebSocketChannel.connect(url);

    socket!.stream.listen((dynamic message) {
      try {
        handleLineResponse(message);
      } catch (e) {
        handleLineError(e);
      }
    }, onError: (error) {
      handleLineError(error);
    }, onDone: () {
      handleLineDone();
    });
    subscribe();
  }

  Future<void> subscribe() async {
    final requestData =
        request(); // Call the request method to get the request data
    socket?.sink.add(jsonEncode(requestData));
  }

  void handleLineResponse(dynamic data) {
    final decodedData = jsonDecode(data);
    String close = decodedData['ohlc']['close'];
    String high = decodedData['ohlc']['high'];
    String low = decodedData['ohlc']['low'];
    String open = decodedData['ohlc']['open'];

    List<Map<String, dynamic>> dataList = [
      {'close': close, 'high': high, 'low': low, 'open': open},
    ];
    final candlePrice = BlocProvider.of<candlePriceCubit>(context);
    candlePrice.updateLiveLinePrice(dataList);
  }

  void handleLineError(dynamic error) {
    print("Failed to get data: $error");
  }

  void handleLineDone() {
    print("Line Closed");
  }

  @override
  void initState() {
    super.initState();
    connectToWebSocket();
  }

  @override
  void dispose() {
    super.dispose();
    socket?.sink.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<candlePriceCubit, List<Map<String, dynamic>>>(
      builder: (context, state) {
        // Check if the state list has at least one item
        if (state.isNotEmpty) {
          // Extract the values from the first map in the list
          String close = state[0]['close'].toString();
          String high = state[0]['high'].toString();
          String low = state[0]['low'].toString();
          String open = state[0]['open'].toString();

          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Close: $close'),
                    SizedBox(width: 10),
                    Text('High: $high'),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Low: $low'),
                    SizedBox(width: 10),
                    Text('Open: $open'),
                  ],
                ),
              ],
            ),
          );
        } else {
          // Placeholder container when the state list is empty
          return Container();
        }
      },
    );
  }
}
