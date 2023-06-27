import 'package:anim_search_bar/anim_search_bar.dart';
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
            GestureDetector(
              onTap: () {
                closeWebSocket();
              },
              child: Container(
                height: 50,
                width: 100,
                color: Colors.grey[300],
                child: const Center(child: Text("Unsubscribe Ticks")),
              ),
            ),
            SizedBox(
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

                    return LineChart(
                      LineChartData(
                        minX: minX,
                        maxX: maxX,
                        minY: minY,
                        maxY: maxY,
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                              reservedSize: 0,
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                              reservedSize: 0,
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                              reservedSize: 0,
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            // axisNameWidget: const Text('time'),
                            sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                // getTitlesWidget: (value, meta) {
                                //   return bottomTitleWidgets(value, meta, 10.00);
                                // }),
                          ),
                        ),
                        ),
                        gridData: FlGridData(
                            show: true,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.greenAccent,
                                strokeWidth: 2,
                              );
                            },
                            getDrawingVerticalLine: (value) {
                              return FlLine(
                                color: Colors.redAccent,
                                strokeWidth: 2,
                              );
                            }),
                        borderData: FlBorderData(
                            show: true,
                            border:
                                Border.all(color: Colors.blueAccent, width: 1)),
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: true,
                            // colors: gradientColors,
                            barWidth: 3,
                            // belowBarData: BarAreaData()
                            dotData: FlDotData(show: false),
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
