import 'package:commoncents/cubit/candlestick_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../cubit/stock_data_cubit.dart';
import '../apistore/stockdata.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CandleStickChart extends StatefulWidget {
  final bool isCandle;

  CandleStickChart({required this.isCandle, Key? key}) : super(key: key);

  @override
  _CandleStickChartState createState() => _CandleStickChartState();
}

class _CandleStickChartState extends State<CandleStickChart> {
  late CandlestickCubit candleStickCubit;

  @override
  void initState() {
    super.initState();
    candleStickCubit = CandlestickCubit();
    connectToWebSocket(context, widget.isCandle);
  }

  @override
  void dispose() {
    candleStickCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width,
              child: BlocBuilder<CandlestickCubit, List<Map<String, dynamic>>>(
                builder: (context, candleData) {
                  if (candleData.isNotEmpty) {
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
                        ),
                      ],
                      primaryXAxis: DateTimeAxis(),
                      primaryYAxis: NumericAxis(),
                    );
                  } else {
                    return const CircularProgressIndicator();
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
