// import 'dart:js';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../apistore/stockdata.dart';
// import '../cubit/candlestick_cubit.dart';

// void handleCandleData(Map<String, dynamic> decodedData, BuildContext context) {

//   late CandlestickCubit candlestickCubit;
//   final ohlc = decodedData['ohlc'];
//   if (ohlc != null) {
//     final String open = ohlc['open'];
//     final String high = ohlc['high'];
//     final String low = ohlc['low'];
//     final String close = ohlc['close'];
//     final int time = ohlc['open_time'];
//     DateTime utcTime =
//         DateTime.fromMillisecondsSinceEpoch(time * 1000, isUtc: true);
//     double utcTimeDouble = utcTime.millisecondsSinceEpoch.toDouble() / 1000;

//     // Append the latest tick price and time to the ticks list
//     candles.add({
//       'open': open,
//       'high': high,
//       'low': low,
//       'close': close,
//       'time': utcTime
//     });
//     final candleStickData = BlocProvider.of<CandlestickCubit>(context);
//     candleStickData.updateCandlestickData(candles); // this is for line chart
//   }
// }
