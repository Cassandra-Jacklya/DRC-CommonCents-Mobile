import 'package:commoncents/components/formatMarkets.dart';
import 'package:commoncents/cubit/candlestick_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../apistore/stockdata.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CandleStickChart extends StatefulWidget {
  final bool isCandle;
  final String market;
  final String timeunit;

  CandleStickChart(
      {required this.isCandle,
      required this.market,
      required this.timeunit,
      Key? key})
      : super(key: key);

  @override
  _CandleStickChartState createState() => _CandleStickChartState();
}

class _CandleStickChartState extends State<CandleStickChart> {
  CandlestickCubit candleStickCubit = CandlestickCubit();


  @override
  void dispose() {
    // candleStickCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    candleStickCubit.clearStockData();
    connectToWebSocket(
        context: context,
        isCandle: widget.isCandle,
        market: formatMarkets(widget.market),
        selectedTimeUnit: widget.timeunit);
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              // height: MediaQuery.of(context).size.height * 0.3,
              // width: MediaQuery.of(context).size.width,
              height: 300,
              width: double.infinity,
              child: BlocBuilder<CandlestickCubit, List<Map<String, dynamic>>>(
                builder: (context, candleData) {
                  if (candleData.isNotEmpty) {
                    print(candleData);
                    print(candleData.length);
                    List<ChartData> chartData = candleData.map((data) {
                      double x = data['epoch'];
                      double open = data['open'];
                      double high = data['high'];
                      double low = data['low'];
                      double close = data['close'];
                      DateTime time =
                          DateTime.fromMillisecondsSinceEpoch(x.toInt());

                      return ChartData(
                        time: time,
                        open: open,
                        high: high,
                        low: low,
                        close: close,
                      );
                    }).toList();

                    return SfCartesianChart(
                      zoomPanBehavior: ZoomPanBehavior(
                        enablePinching: true,
                        enablePanning: true,
                        zoomMode: ZoomMode.xy,
                        enableSelectionZooming: true,
                        maximumZoomLevel: 0.1,
                      ),
                      series: <CandleSeries>[
                        CandleSeries<ChartData, DateTime>(
                          showIndicationForSameValues: true,
                          dataSource: chartData,
                          xValueMapper: (ChartData data, _) => data.time,
                          lowValueMapper: (ChartData data, _) => data.low,
                          highValueMapper: (ChartData data, _) => data.high,
                          openValueMapper: (ChartData data, _) => data.open,
                          closeValueMapper: (ChartData data, _) => data.close,
                          enableSolidCandles: true,
                        ),
                      ],
                      primaryXAxis: DateTimeAxis(
                        autoScrollingMode: AutoScrollingMode.start,
                      ),
                      primaryYAxis: NumericAxis(
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        opposedPosition: true,
                      ),
                    );
                  } else {
                    return const Scaffold(
                      body: Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
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

class ChartData {
  ChartData({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  final double open;
  final double high;
  final double low;
  final double close;
  final DateTime time;
}
