import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../cubit/livelinePrice_cubit.dart';

class LiveLinePrice extends StatefulWidget {
  _LiveLinePriceState createState() => _LiveLinePriceState();
}

class _LiveLinePriceState extends State<LiveLinePrice> {
  late double linePrice = 0.0;
  WebSocketChannel? socket;
  static const String appId = '1089';
  final Uri url = Uri.parse(
      'wss://ws.binaryws.com/websockets/v3?app_id=$appId&l=EN&brand=deriv');

  Map<String, dynamic> request() {
    Map<String, dynamic> request = {"ticks": "R_50", "subscribe": 1};
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
    linePrice = decodedData['tick']['quote'];
    final liveLinePriceData = BlocProvider.of<LiveLinePriceCubit>(context);
    liveLinePriceData.updateLiveLinePrice(linePrice);
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
    return BlocBuilder<LiveLinePriceCubit, double>(
      builder: (context, state) {
        return Text("Spot price: ${state.toStringAsFixed(2)}");
      },
    );
  }
}
