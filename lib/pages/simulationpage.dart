import 'dart:async';

import 'package:commoncents/apistore/stockdata.dart';
import 'package:commoncents/components/chart.dart';
import 'package:commoncents/components/chartTime.dart';
import 'package:commoncents/components/contractSnackbar.dart';
import 'package:commoncents/components/liveLinePrice.dart';
import 'package:commoncents/cubit/candlePrice_cubit.dart';
import 'package:commoncents/cubit/chartTime_cubit.dart';
import 'package:commoncents/cubit/isCandle_cubit.dart';
import 'package:commoncents/cubit/lineTime_cubit.dart';
import 'package:commoncents/cubit/livelinePrice_cubit.dart';
import 'package:commoncents/cubit/markets_cubit.dart';
import 'package:commoncents/cubit/numberpicker_cubit.dart';
import 'package:commoncents/cubit/stake_payout_cubit.dart';
import 'package:commoncents/pages/simulationpage_guest.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../components/appbar.dart';
import '../components/chartPrice.dart';
import '../components/formatMarkets.dart';
import '../components/lineTime.dart';
import '../components/navbar.dart';
import '../components/numberPIcker.dart';
import '../components/linechart.dart';
import '../components/ticks_gauge.dart';
import '../components/walletbutton.dart';
import '../cubit/candlestick_cubit.dart';
import '../cubit/login_cubit.dart';
import '../cubit/navbar_cubit.dart';
import '../cubit/news_tabbar_cubit.dart';
import '../cubit/resetwallet_cubit.dart';
import '../cubit/stock_data_cubit.dart';
import '../cubit/ticks_cubit.dart';
import '../apistore/PriceProposal.dart';
import '../firebase_options.dart';
import '../pages/marketspage.dart';

bool isSnackbarVisible = false;

class SimulationPage extends StatefulWidget {
  final String market;

  const SimulationPage({
    super.key,
    required this.market,
  });

  @override
  _SimulationPageState createState() => _SimulationPageState();
}

class _SimulationPageState extends State<SimulationPage> {
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
    super.initState();
    isCandle = false;
  }

  @override
  void dispose() {
    closeWebSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    closeWebSocket();
    // print("Hello");
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
        BlocProvider<candlePriceCubit>(create: (context) => candlePriceCubit()),
        BlocProvider<ResetWalletBloc>(
          create: (context) => ResetWalletBloc(),
        )
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: const CustomAppBar(
          title: "Trading Simulation",
          logo: "assets/images/commoncents-logo.png",
          isTradingPage: true,
        ),
        body: FutureBuilder(
            future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            ),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  final User? user = FirebaseAuth.instance.currentUser;
                  if (user == null) {
                    //not logged in
                    return BlocBuilder<MarketsCubit, String>(
                        builder: (context, state) {
                      return SimulationPageGuest(market: widget.market);
                    });
                  } else {
                    //logged in
                    return Column(
                      children: [
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                BlocBuilder<MarketsCubit, String>(
                                    builder: (context, state) {
                                  return GestureDetector(
                                    onTap: () {
                                      unsubscribe();
                                      closeWebSocket();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Markets(
                                                  market: widget.market)));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 10),
                                      margin: const EdgeInsets.only(left: 10, right: 5),
                                      height: 44,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color(0xFF5F5F5F),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                    width: 40,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color(0xFF5F5F5F),
                                        ),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: IconButton(
                                        iconSize: 18,
                                        onPressed: () {
                                          setState(() {
                                            unsubscribe();
                                            closeWebSocket();
                                            isCandle = !isCandle;
                                            // isCandleCubit.isItCandles(isCandle);
                                          });
                                        },
                                        icon: isCandle
                                            ? const Icon(
                                                Icons.candlestick_chart)
                                            : const Icon(Icons.line_axis)),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                              child: WalletButton(),
                            ),
                          ],
                        ),
                        BlocBuilder<ChartTimeCubit, String>(
                            builder: (context, charttime) {
                          return BlocBuilder<LineTimeCubit, String>(
                              builder: (context, state) {
                            return Column(
                              children: [
                                SizedBox(
                                    height: 40,
                                    child: !isCandle
                                        ? ListView.builder(
                                            //line time
                                            scrollDirection: Axis.horizontal,
                                            itemCount: timeUnit.length,
                                            itemBuilder: (context, index) {
                                              final unit = timeUnit[index];
                                              final isSelected =
                                                  (unit == state);
                                              return GestureDetector(
                                                onTap: () {
                                                  unsubscribe();
                                                  BlocProvider.of<
                                                              LineTimeCubit>(
                                                          context)
                                                      .updateLineTime(unit);
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.only(left: 5, right: 5),
                                                  //candle time
                                                  margin: const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                                  height: 31,
                                                  decoration: BoxDecoration(
                                                    color: isSelected
                                                        ? const Color(
                                                            0xFF5F5F5F)
                                                        : Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Center(
                                                      child: Text(
                                                    timeUnit[index],
                                                    style: TextStyle(
                                                        color: isSelected
                                                            ? Colors.white
                                                            : Colors.black),
                                                  )),
                                                ),
                                              );
                                            },
                                          )
                                        : ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: candleTimeUnit.length,
                                            itemBuilder: (context, index) {
                                              final chartunit =
                                                  candleTimeUnit[index];
                                              final isSelected =
                                                  (chartunit == charttime);
                                              return GestureDetector(
                                                onTap: () {
                                                  unsubscribeCandle();
                                                  BlocProvider.of<
                                                              ChartTimeCubit>(
                                                          context)
                                                      .updateChartTime(
                                                          chartunit);
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  height: 31,
                                                  decoration: BoxDecoration(
                                                    color: isSelected
                                                        ? const Color(
                                                            0xFF5F5F5F)
                                                        : Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Center(
                                                      child: Text(
                                                    candleTimeUnit[index],
                                                    style: TextStyle(
                                                        color: isSelected
                                                            ? Colors.white
                                                            : Colors.black),
                                                  )),
                                                ),
                                              );
                                            },
                                          )),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 15, 0),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    height: 280,
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
                        Expanded(
                          child: Scaffold(
                            resizeToAvoidBottomInset: true,
                            body: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 17),
                                    child: Container(
                                        child: isCandle
                                            ? ChartPrice(
                                                market: formatMarkets(
                                                    widget.market))
                                            : LiveLinePrice(
                                                market: formatMarkets(
                                                    widget.market))),
                                  ),
                                  BlocBuilder<TicksCubit, double>(
                                      builder: (context, selectedValue) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 30),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Text("Ticks"),
                                          TicksGauge()
                                        ],
                                      ),
                                    );
                                  }),
                                  const SizedBox(height: 12),
                                  BlocBuilder<StakePayoutCubit, int>(
                                    builder: (context, index) {
                                      return Container(
                                        height: 45,
                                        child: ToggleSwitch(
                                          minWidth: 269,
                                          initialLabelIndex: context
                                              .read<StakePayoutCubit>()
                                              .state,
                                          cornerRadius: 5,
                                          borderColor: const [
                                            Color(0xFF5F5F5F),
                                            Color(0xFF5F5F5F)
                                          ],
                                          borderWidth: 2,
                                          activeFgColor: Colors.white,
                                          inactiveBgColor: Colors.white,
                                          inactiveFgColor: Colors.black,
                                          totalSwitches: 2,
                                          labels: const ['Stake', 'Payout'],
                                          activeBgColors: const [
                                            [Color(0xFF5F5F5F)],
                                            [Color(0xFF5F5F5F)]
                                          ],
                                          onToggle: (index) {
                                            context
                                                .read<StakePayoutCubit>()
                                                .updateStakePayout(
                                                    index as int);
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 14),
                                  // BlocBuilder<CurrentAmountCubit, int>(
                                  //     builder: (context, amount) {
                                  //   return IntegerExample();
                                  // }),
                                  IntegerExample(),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (!isSnackbarVisible) {
                                            markettype =
                                                formatMarkets(widget.market);
                                            ticks = context
                                                .read<TicksCubit>()
                                                .state;
                                            if (BlocProvider.of<
                                                            StakePayoutCubit>(
                                                        context)
                                                    .state ==
                                                0) {
                                              stakePayout = 'stake';
                                            } else if (BlocProvider.of<
                                                            StakePayoutCubit>(
                                                        context)
                                                    .state ==
                                                1) {
                                              stakePayout = 'payout';
                                            }
                                            currentAmount = context
                                                .read<CurrentAmountCubit>()
                                                .state;
                                            handleBuy(
                                                context,
                                                ticks.toInt(),
                                                stakePayout,
                                                currentAmount,
                                                "high",
                                                markettype);
                                            showAlertDialog(
                                                context,
                                                'Higher contract bought for USD ${currentAmount.toString()}',
                                                ticks.toInt(), markettype, currentAmount, "Higher");
                                            isSnackbarVisible = false;
                                          } else {}
                                        },
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          height: 45,
                                          width: 128,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: const [
                                                Icon(Icons.arrow_upward),
                                                Text("Higher")
                                              ]),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (!isSnackbarVisible) {
                                            isSnackbarVisible = true;
                                            markettype =
                                                formatMarkets(widget.market);
                                            ticks = context
                                                .read<TicksCubit>()
                                                .state;
                                            if (BlocProvider.of<
                                                            StakePayoutCubit>(
                                                        context)
                                                    .state ==
                                                0) {
                                              stakePayout = 'stake';
                                            } else if (BlocProvider.of<
                                                            StakePayoutCubit>(
                                                        context)
                                                    .state ==
                                                1) {
                                              stakePayout = 'payout';
                                            }
                                            currentAmount = context
                                                .read<CurrentAmountCubit>()
                                                .state;
                                            handleBuy(
                                                context,
                                                ticks.toInt(),
                                                stakePayout,
                                                currentAmount,
                                                "low",
                                                markettype);
                                            showAlertDialog(
                                                context,
                                                'Lower contract bought for USD ${currentAmount.toString()}',
                                                ticks.toInt(), markettype, currentAmount, "Lower");
                                            isSnackbarVisible = false;
                                          } else {}
                                        },
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          height: 30,
                                          width: 128,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: const [
                                                Icon(Icons.arrow_downward),
                                                Text("Lower")
                                              ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 40),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                default:
                  return Container();
              }
            }),
        bottomNavigationBar: const BottomNavBar(
          index: 2,
        ),
      ),
    );
  }
}
