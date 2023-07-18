import 'package:commoncents/cubit/markets_cubit.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../cubit/lineTime_cubit.dart';
import '../cubit/stock_data_cubit.dart';
import '../apistore/stockdata.dart';
import 'formatMarkets.dart';

class MyLineChart extends StatefulWidget {
  final bool isCandle;
  final String market;
  final bool isMini;
  final String timeunit;

  MyLineChart(
      {required this.isCandle,
      required this.market,
      required this.isMini,
      required this.timeunit,
      Key? key})
      : super(key: key);

  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends State<MyLineChart> {
  bool _isTooltipVisible = false;

  late StockDataCubit stockDataCubit;
  late String selectedTimeUnit = widget.timeunit;
  late TooltipBehavior _tooltipBehavior;
  // late String selectedTimeUnit;
  List<FlSpot> spots = [];
  int initial = 50;
  Widget bottomTitleWidgets(double value, TitleMeta meta, double chartWidth) {
    final style = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFamily: 'Digital',
      fontSize: 18 * chartWidth / 500,
    );
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(value.toInt() * 1000, isUtc: true);
    String timeString =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(timeString, style: style),
    );
  }

  @override
  void initState() {
    super.initState();
    stockDataCubit = StockDataCubit();
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: 'Spot price',
      format: 'point.y',
    );
  }

  @override
  void dispose() {
    // stockDataCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    connectToWebSocket(
      context: context,
      isCandle: widget.isCandle,
      market: formatMarkets(widget.market),
      selectedTimeUnit: widget.timeunit,
    );
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                height: 280,
                width: 380,
                child: BlocBuilder<StockDataCubit, List<Map<String, dynamic>>>(
                  builder: (context, stockData) {
                    if (stockData.length >= 100) {
                      spots.clear();
                      for (var entry in stockData) {
                        double x = entry['epoch'];
                        double y = entry['close'];
                        spots.add(FlSpot(x, y));
                      }

                      if (stockData.length > 100) {
                        stockData.removeRange(0, stockData.length - 100);
                      }

                      double minClose = stockData[initial]['close'];
                      double maxClose = stockData[initial]['close'];

                      for (int i = initial; i < stockData.length; i++) {
                        double close = stockData[i]['close'];
                        if (close < minClose) {
                          minClose = close;
                        }
                        if (close > maxClose) {
                          maxClose = close;
                        }
                      }

                      if (minClose == maxClose) {
                        maxClose += 1;
                      }

                      return SfCartesianChart(
                        tooltipBehavior: _tooltipBehavior,
                        zoomPanBehavior: ZoomPanBehavior(
                          // enableSelectionZooming: true,
                          enablePinching: true,
                          enablePanning: true,
                          zoomMode: ZoomMode.xy,
                        ),
                        trackballBehavior: TrackballBehavior(
                          enable: true,
                          shouldAlwaysShow: true,
                          tooltipDisplayMode:
                              TrackballDisplayMode.floatAllPoints,
                          tooltipSettings: const InteractiveTooltip(
                            enable: true,
                            color: Colors.blue,
                          ),
                        ),
                        primaryXAxis: DateTimeAxis(
                          isVisible: widget.isMini ? false : true,
                          majorGridLines: const MajorGridLines(width: 0),
                          dateFormat: DateFormat(
                              'HH:mm'), // Specify the desired time format
                          intervalType: DateTimeIntervalType
                              .seconds, // Adjust based on your data
                          axisLine:
                              const AxisLine(width: 0), // Hide the x-axis line
                          minimum: DateTime.fromMillisecondsSinceEpoch(
                            stockData.first['epoch'].toInt() * 1000,
                            isUtc: true,
                          ), // Set the minimum value of the x-axis
                          maximum: DateTime.fromMillisecondsSinceEpoch(
                            stockData.last['epoch'].toInt() * 1000,
                            isUtc: true,
                          ),
                        ),
                        primaryYAxis: NumericAxis(
                          edgeLabelPlacement: EdgeLabelPlacement.shift,
                          opposedPosition: true,
                          isVisible: widget.isMini ? false : true,
                          desiredIntervals: 3,
                        ),
                        series: <ChartSeries>[
                          LineSeries<FlSpot, DateTime>(
                              dataSource: spots,
                              xValueMapper: (FlSpot spot, _) =>
                                  DateTime.fromMillisecondsSinceEpoch(
                                      spot.x.toInt() * 1000,
                                      isUtc: true),
                              yValueMapper: (FlSpot spot, _) => spot.y,
                              yAxisName: 'secondaryYAxis',
                              width: 2.0),
                        ],
                      );
                    } else {
                      return const Center(
                        child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator()),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
