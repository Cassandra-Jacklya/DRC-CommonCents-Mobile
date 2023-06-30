import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../apistore/stockdata.dart';

WebSocketChannel? socket;
const String appId = '1089';
final Uri url = Uri.parse(
    'wss://ws.binaryws.com/websockets/v3?app_id=$appId&l=EN&brand=deriv');

Future<void> PriceProposalRequest(BuildContext context) async {
  socket = WebSocketChannel.connect(url);
  print("Connected to websocket!");

  socket?.stream.listen((dynamic message) {
    try {
      // print("this is message: $message");
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

final PriceProposal = {
  "proposal": 1,
  "amount": 100,
  "barrier": "+0.1",
  "basis": "payout",
  "contract_type": "CALL",
  "currency": "USD",
  "duration": 60,
  "duration_unit": "s",
  "symbol": "R_100"
};