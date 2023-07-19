import 'package:commoncents/apistore/stockdata.dart';
import 'package:commoncents/components/chart.dart';
import 'package:commoncents/cubit/candlePrice_cubit.dart';
import 'package:commoncents/cubit/chartTime_cubit.dart';
import 'package:commoncents/cubit/isCandle_cubit.dart';
import 'package:commoncents/cubit/lineTime_cubit.dart';
import 'package:commoncents/cubit/livelinePrice_cubit.dart';
import 'package:commoncents/cubit/markets_cubit.dart';
import 'package:commoncents/cubit/numberpicker_cubit.dart';
import 'package:commoncents/cubit/stake_payout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../components/linechart.dart';
import '../cubit/candlestick_cubit.dart';
import '../cubit/login_cubit.dart';
import '../cubit/navbar_cubit.dart';
import '../cubit/news_tabbar_cubit.dart';
import '../cubit/stock_data_cubit.dart';
import '../cubit/ticks_cubit.dart';
import '../pages/marketspage.dart';
import 'auth_pages/login.dart';

bool isSnackbarVisible = false;

class SimulationPageGuest extends StatefulWidget {
  final String market;

  const SimulationPageGuest({
    super.key,
    required this.market,
  });

  @override
  _SimulationPageGuestState createState() => _SimulationPageGuestState();
}

class _SimulationPageGuestState extends State<SimulationPageGuest> {
  late IsCandleCubit isCandleCubit;
  late String markettype;
  late double ticks;
  late String stakePayout;
  late int currentAmount;
  late bool isCandle;
  List<String> timeUnit = ['Ticks', 'Minutes', 'Hours', 'Days'];
  List<String> candleTimeUnit = [
    'Minutes',
    'Hours',
    'Days',
  ];

  @override
  void initState() {
    isCandle = false;
  }

  @override
  void dispose() {
    closeWebSocket();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BottomNavBarCubit>(
          create: (context) => BottomNavBarCubit(),
        ),
        BlocProvider<StockDataCubit>(
          create: (context) => StockDataCubit(),
        ),
        BlocProvider<LoginStateBloc>(
          create: (context) => LoginStateBloc(),
        ),
        BlocProvider<NewsTabBarCubit>(create: (context) => NewsTabBarCubit()),
        BlocProvider<StakePayoutCubit>(create: (context) => StakePayoutCubit()),
        BlocProvider<TicksCubit>(create: (context) => TicksCubit()),
        BlocProvider<CurrentAmountCubit>(
            create: (context) => CurrentAmountCubit()),
        BlocProvider<CandlestickCubit>(create: (context) => CandlestickCubit()),
        BlocProvider<MarketsCubit>(create: (context) => MarketsCubit()),
        BlocProvider<IsCandleCubit>(create: (content) => IsCandleCubit()),
        BlocProvider<LineTimeCubit>(create: (context) => LineTimeCubit()),
        BlocProvider<ChartTimeCubit>(create: (context) => ChartTimeCubit()),
        BlocProvider<LiveLinePriceCubit>(
            create: (context) => LiveLinePriceCubit()),
        BlocProvider<candlePriceCubit>(create: (context) => candlePriceCubit())
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            const SizedBox(height: 5),
            Row(
              children: [
                BlocBuilder<MarketsCubit, String>(builder: (context, state) {
                  return GestureDetector(
                    onTap: () {
                      unsubscribe();
                      closeWebSocket();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Markets(market: widget.market)));
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 15),
                      margin: const EdgeInsets.all(10),
                      height: 44,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF5F5F5F),
                        ),
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.market),
                          const IconButton(
                            onPressed: null,
                            icon: Icon(
                              Icons.keyboard_arrow_down_sharp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                GestureDetector(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF5F5F5F),
                      ),
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: IconButton(
                      iconSize: 12,
                      onPressed: () {
                        setState(() {
                          unsubscribe();
                          closeWebSocket();
                          isCandle = !isCandle;
                          // isCandleCubit.isItCandles(isCandle);
                        });
                      },
                      icon: isCandle
                          ? const Icon(Icons.candlestick_chart)
                          : const Icon(Icons.line_axis),
                    ),
                  ),
                ),
              ],
            ),
            BlocBuilder<ChartTimeCubit, String>(builder: (context, charttime) {
              return BlocBuilder<LineTimeCubit, String>(
                  builder: (context, state) {
                return Column(
                  children: [
                    Container(
                      height: 50,
                      child: !isCandle
                        ? ListView.builder(
                            //line time
                            scrollDirection: Axis.horizontal,
                            itemCount: timeUnit.length,
                            itemBuilder: (context, index) {
                              final unit = timeUnit[index];
                              final isSelected = (unit == state);
                              return GestureDetector(
                                onTap: () {
                                  unsubscribe();
                                  BlocProvider.of<LineTimeCubit>(context)
                                      .updateLineTime(unit);
                                },
                                child: Container(
                                  //candle time
                                  padding: const EdgeInsets.only(left: 5, right: 5),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8),
                                  height: 31,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF5F5F5F)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child:
                                      Center(child: Text(timeUnit[index],
                                      style: TextStyle(
                                        color: isSelected
                                        ? Colors.white
                                        : Colors.black
                                      ),
                                    )
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            //candle time
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: candleTimeUnit.length,
                              itemBuilder: (context, index) {
                                final chartunit = candleTimeUnit[index];
                                final isSelected = (chartunit == charttime);
                                return GestureDetector(
                                  onTap: () {
                                    unsubscribeCandle();
                                    BlocProvider.of<ChartTimeCubit>(context)
                                        .updateChartTime(chartunit);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    width: 70,
                                    height: 31,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFF5F5F5F)
                                          : Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                        child: Text(candleTimeUnit[index],
                                        style: TextStyle(
                                          color: isSelected
                                          ? Colors.white
                                          : Colors.black
                                        ),
                                        )),
                                  ),
                                );
                              },
                            ),
                          )
                        ),
                        Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        // height: MediaQuery.of(context).size.height * 0.3,
                        height: 300,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Center(
                          child: isCandle
                            ? BlocBuilder<MarketsCubit, String>(
                              builder: (context, market) {
                              return CandleStickChart(
                                  isCandle: isCandle,
                                  market: widget.market,
                                  timeunit: charttime
                                  // context
                                  //     .read<ChartTimeCubit>()
                                  //     .state,
                                  );
                            })
                            : BlocBuilder<MarketsCubit, String>(
                                builder: (context, market) {
                                  return MyLineChart(
                                    isMini: false,
                                    isCandle: isCandle,
                                    market: widget.market,
                                    timeunit: state,
                                  );
                                },
                              ),
                        ),
                      ),
                    ),
                  ],
                );
              });
            }),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginView()),
                    );
                  },
                  child: const Text(
                    "Log in ",
                    style: TextStyle(
                        fontSize: 17,
                        color: Color(0XFF3366FF),
                        decoration: TextDecoration.underline,),
                  ),
                ),
                const Text(
                  "to start trading",
                  style: TextStyle(fontSize: 17),
                ),
                const SizedBox(height: 20),
              ],
            )
          ],
        ),
      ),
    );
  }
}