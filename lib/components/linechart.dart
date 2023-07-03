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
  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a)
  ];

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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
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

                      double minX = stockData.first['epoch'].toDouble();
                      double maxX = stockData.last['epoch'].toDouble();
                      double minY = stockData
                          .map((entry) => entry['close'])
                          .reduce((a, b) => a < b ? a : b);
                      double maxY = stockData
                              .map((entry) => entry['close'])
                              .reduce((a, b) => a > b ? a : b) +
                          0.1;

                      double newMinX;
                      if (spots.length >= 100) {
                        newMinX = spots[spots.length - 100].x;
                      } else if (spots.isNotEmpty) {
                        newMinX = spots.first.x;
                      } else {
                        newMinX =
                            0; // Set a default value if spots list is empty
                      }
                      double newMaxX;
                      if (spots.length >= 100) {
                        newMaxX = spots.last.x;
                      } else if (spots.isNotEmpty) {
                        newMaxX = spots[spots.length - 1].x;
                      } else {
                        newMaxX =
                            0; // Set a default value if spots list is empty
                      }

                      double range = newMaxX - newMinX;
                      double zoomPercentage = 0; // Adjust as needed

                      DateTime visibleMinX =
                          DateTime.fromMillisecondsSinceEpoch(
                              (newMinX - range * zoomPercentage).toInt() * 1000,
                              isUtc: true);
                      DateTime visibleMaxX =
                          DateTime.fromMillisecondsSinceEpoch(
                              (newMaxX + range * zoomPercentage).toInt() * 1000,
                              isUtc: true);

                      return SfCartesianChart(
                        primaryXAxis: DateTimeAxis(
                          dateFormat: DateFormat(
                              'HH:mm'), // Specify the desired time format
                          intervalType: DateTimeIntervalType
                              .seconds, // Adjust based on your data
                          axisLine: AxisLine(width: 0), // Hide the x-axis line
                          minimum: DateTime.fromMillisecondsSinceEpoch(
                              stockData.first['epoch'].toInt() * 1000,
                              isUtc:
                                  true), // Set the minimum value of the x-axis
                          maximum: DateTime.fromMillisecondsSinceEpoch(
                              stockData.last['epoch'].toInt() * 1000,
                              isUtc:
                                  true), // Set the maximum value of the x-axis
                          visibleMinimum: visibleMinX, // Set the initial visible range
                          visibleMaximum: visibleMaxX, // Set the initial visible range
                        ),
                        primaryYAxis: NumericAxis(
                          edgeLabelPlacement: EdgeLabelPlacement.shift,
                          opposedPosition: true,
                          isVisible: true,
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
