import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../cubit/livelinePrice_cubit.dart';

class LiveLinePrice extends StatefulWidget {
  final String market;

  const LiveLinePrice({required this.market});

  _LiveLinePriceState createState() => _LiveLinePriceState();
}

class _LiveLinePriceState extends State<LiveLinePrice> {
  late List<double> linePriceList = [];
  late double linePrice = 0.0;
  WebSocketChannel? socket;
  static const String appId = '1089';
  final Uri url = Uri.parse(
      'wss://ws.binaryws.com/websockets/v3?app_id=$appId&l=EN&brand=deriv');

  Map<String, dynamic> request() {
    Map<String, dynamic> request = {"ticks": widget.market, "subscribe": 1};
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
    linePrice = decodedData['tick']['quote'].toDouble();
    linePriceList.add(linePrice);
    if (linePriceList.length > 2) {
      linePriceList.removeAt(0);
    }
    final liveLinePriceData = BlocProvider.of<LiveLinePriceCubit>(context);
    liveLinePriceData.updateLiveLinePrice(linePriceList);
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
    return BlocBuilder<LiveLinePriceCubit, List<double>>(
      builder: (context, state) {
        if (state.isNotEmpty) {
          late double price = state.last;
          return Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: state.length < 2
                    ? Colors.white
                    : state.first > state.last
                        ? Colors.red
                        : Colors.green,
              ),
              child:
                  // Text("Spot price: ${state.toStringAsFixed(2)}")
                  Text("Spot price: ${price.toStringAsFixed(2)}",
                      style: const TextStyle(color: Colors.white)));
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
