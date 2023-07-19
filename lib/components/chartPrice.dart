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
  late List<Map<String, dynamic>> ohlcList = [];
  late Color highcurrent = Colors.transparent;
  late Color lowcurrent = Colors.transparent;
  late Color opencurrent = Colors.transparent;

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
    if (decodedData['msg_type'] == "ohlc") {
      double close = double.parse(decodedData['ohlc']['close']);
      double high = double.parse(decodedData['ohlc']['high']);
      double low = double.parse(decodedData['ohlc']['low']);
      double open = double.parse(decodedData['ohlc']['open']);

      Map<String, dynamic> data = {
        'close': close,
        'high': high,
        'low': low,
        'open': open
      };

      ohlcList.add(data);
      if (ohlcList.length > 2) {
        ohlcList.removeAt(0);
      }
      final candlePrice = BlocProvider.of<candlePriceCubit>(context);
      candlePrice.updateLiveLinePrice(ohlcList);
    }
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
        if (state.isNotEmpty) {
          double previousClose = state[0]['close'];
          double previousHigh = state[0]['high'];
          double previousLow = state[0]['low'];
          double previousOpen = state[0]['open'];

          double close = state[state.length - 1]['close'];
          double high = state[state.length - 1]['high'];
          double low = state[state.length - 1]['low'];
          double open = state[state.length - 1]['open'];

          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: state.length < 2
                              ? Colors.white
                              : previousClose > close
                                  ? Colors.red
                                  : Colors.green,
                        ),
                        child: Text(
                          'Close: ${close.toString()}',
                          style: const TextStyle(color: Colors.white),
                        )),
                    SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: () {
                          if (state.length < 2) {
                            highcurrent = Colors.white;
                            return Colors.white;
                          } else {
                            if (previousHigh > high) {
                              highcurrent = Colors.red;
                              return Colors.red;
                            } else {
                              if (previousHigh < high) {
                                highcurrent = Colors.green;
                                return Colors.green;
                              } else {
                                return highcurrent;
                              }
                            }
                          }
                        }(),
                        border: Border.all(
                          color: highcurrent == Colors.white
                              ? Colors.black
                              : Colors.transparent,
                          width: 1.0,
                        ),
                      ),
                      child: Text(
                        'High: ${high.toString()}',
                        style: TextStyle(
                          color: highcurrent == Colors.white
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: () {
                          if (state.length < 2) {
                            lowcurrent = Colors.white;
                            return Colors.white;
                          } else {
                            if (previousLow > low) {
                              lowcurrent = Colors.red;
                              return Colors.red;
                            } else {
                              if (previousLow < low) {
                                lowcurrent = Colors.green;
                                return Colors.green;
                              } else {
                                return lowcurrent;
                              }
                            }
                          }
                        }(),
                        border: Border.all(
                          color: lowcurrent == Colors.white
                              ? Colors.black
                              : Colors.transparent,
                          width: 1.0,
                        ),
                      ),
                      child: Text(
                        'Low: ${low.toString()}',
                        style: TextStyle(
                        color: lowcurrent == Colors.white
                            ? Colors.black
                            : Colors.white,
                      ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: () {
                          if (state.length < 2) {
                            opencurrent = Colors.white;
                            return Colors.white;
                          } else {
                            if (previousOpen > open) {
                              opencurrent = Colors.red;
                              return Colors.red;
                            } else {
                              if (previousOpen < open) {
                                opencurrent = Colors.green;
                                return Colors.green;
                              } else {
                                return opencurrent;
                              }
                            }
                          }
                        }(),
                        border: Border.all(
                          color: opencurrent == Colors.white
                              ? Colors.black
                              : Colors.transparent,
                          width: 1.0,
                        ),
                      ),
                      child: Text(
                        'Open: ${open.toString()}',
                        style: TextStyle(
                        color: opencurrent == Colors.white
                            ? Colors.black
                            : Colors.white,
                      ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }
}
