import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../cubit/stock_data_cubit.dart';
import '../apistore/stockdata.dart';
// import 'stock_candlestick_painter.dart';

class CandleStickChart extends StatefulWidget {
   final bool isCandle;

  CandleStickChart({required this.isCandle, Key? key}) : super(key: key);

  @override
  _CandleStickChartState createState() => _CandleStickChartState();
}

class _CandleStickChartState extends State<CandleStickChart> {
  late StockDataCubit stockDataCubit;

  @override
  void initState() {
    super.initState();
    stockDataCubit = StockDataCubit();
    connectToWebSocket(context, widget.isCandle);
  }

  @override
  void dispose() {
    stockDataCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width,
              child: BlocBuilder<StockDataCubit, List<Map<String, dynamic>>>(
                builder: (context, stockData) {
                  if (stockData.isEmpty) {
                    return const CircularProgressIndicator();
                  } else {
                    print("I am from chart page: ${stockData}");
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

            // GestureDetector(
            //   onTap: () {
            //     closeWebSocket();
            //   },
            //   child: Container(
            //     height: 50,
            //     width: 100,
            //     color: Colors.grey[300],
            //     child: const Center(child: Text("Unsubscribe Ticks")),
            //   ),
            // ),




// class StockCandleStickPainter extends CustomPainter {

//   StockCandleStickPainter({
//     this.stockData,
//   }) : _wickPaint = Paint()..color = Colors.grey,
//   _gainPaint = Paint()..color = Colors.green,
//   _lossPaint = Paint()..color = Colors.red;

//   final StockTimeframePerformance stockData;
//   final Paint _wickPaint;
//   final Paint _gainPaint;
//   final Paint _lossPaint;
//   final double _wickWidth = 1.0;
//   final double _candleWidth = 3.0;

//   @override
//   void paint(Canvas canvas, Size size) {
//     if(stockData==null){
//       return;
//     }

//     //Generate candlesticks
//     List<CandleStick> candlesticks = _generateCandlesticks(size);

//     //Paint candlesticks
//     for (CandleStick candlestick in candlesticks){

//       //paint the wick ( the lines )
//       canvas.drawRect(
//         Rect.fromLTRB(
//           candlestick.centerX - (_wickWidth/2), 
//           size.height - candlestick.high, //candlestick.wickHigh
//           candlestick.centerX + (_wickWidth /2), 
//           size.height - candlestick.low,
//           ),
//            _wickPaint
//       );

//       //Paint the candle
//       canvas.drawRect(
//         Rect.fromLTRB(
//         candlestick.centerX - (_candleWidth / 2), 
//         size.height - candlestick.high, 
//         candlestick.centerX + (_candleWidth / 2), 
//         size.height - candlestick.low
//         ), 
//         candlestick.candlePaint
//         );
//     }
//   }

//   List<CandleStick> _generateCandlesticks(Size availableSpace){
//     final pixelsPerWindow = availableSpace.width / (stockData.timeWindows.length + 1);

//     final pixelsPerDollar = availableSpace.height / (stockData.high - stockData.low);

//     final List<CandleStick> candlesticks = [];
//     for(int i = 0; i< stockData.timeWindows.length; i++){
//       final StockTimeWindow window = stockData.timeWindows[i];

//       candlesticks.add(
//         CandleStick(
//         centerX: (i+ 1) * pixelsPerWindow, 
//         high: (window.high - stockData.low) * pixelsPerDollar,
//         low: (window.low - stockData.low) * pixelsPerDollar, 
//         open: (window.open - stockData.low)* pixelsPerDollar, 
//         close: (window.close - stockData.low) * pixelsPerDollar, 
//         candlePaint: window.isGain ? _gainPaint : _lossPaint
//         )
//       );
//     }
//     return candlesticks;
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }

// class CandleStick {
//   CandleStick(
//       {required this.centerX,
//       required this.high,
//       required this.low,
//       required this.open,
//       required this.close,
//       required this.candlePaint}
//       );

//   final double centerX;
//   final double high;
//   final double low;
//   final double open;
//   final double close;
//   final Paint candlePaint;
// }
