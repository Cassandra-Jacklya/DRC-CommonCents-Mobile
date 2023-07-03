import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../cubit/stock_data_cubit.dart';
import '../apistore/stockdata.dart';

class MyLineChart extends StatefulWidget {
  const MyLineChart({Key? key}) : super(key: key);

  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends State<MyLineChart> {
  late StockDataCubit stockDataCubit;
  List<FlSpot> spots = [];
  int initial = 400;

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
    connectToWebSocket(context);
  }

  @override
  void dispose() {
    closeWebSocket();
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
              // width: MediaQuery.of(context).size.width,
              child: BlocBuilder<StockDataCubit, List<Map<String, dynamic>>>(
                builder: (context, stockData) {
                  if (stockData.isEmpty) {
                    return const CircularProgressIndicator();
                  } else {
                    spots.clear();
                    for (var entry in stockData) {
                      double x = entry['epoch'];
                      double y = entry['close'];
                      spots.add(FlSpot(x, y));
                    }

                    if (stockData.length > 956) {
                      stockData.removeRange(0, stockData.length - 956);
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

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SfCartesianChart(
                        zoomPanBehavior: ZoomPanBehavior(enablePinching: true),
                        primaryXAxis: DateTimeAxis(
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
                          ), // Set the maximum value of the x-axis
                          visibleMinimum: DateTime.fromMillisecondsSinceEpoch(
                            stockData[initial]['epoch'].toInt() * 1000,
                            isUtc: true,
                          ).subtract(const Duration(
                              seconds: 10)), // Set the initial visible range
                          visibleMaximum: DateTime.fromMillisecondsSinceEpoch(
                            stockData.last['epoch'].toInt() * 1000,
                            isUtc: true,
                          ), // Display the time of the first item as axis title
                        ),
                        primaryYAxis: NumericAxis(
                          edgeLabelPlacement: EdgeLabelPlacement.shift,
                          opposedPosition: true,
                          isVisible: true,
                          minimum: minClose.floorToDouble(),
                          maximum: maxClose.floorToDouble() + 1.5,
                          interval: 1,
                          numberFormat: NumberFormat('#'),
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
                          ),
                        ],
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
