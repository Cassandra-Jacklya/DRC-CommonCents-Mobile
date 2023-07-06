import 'package:commoncents/apistore/stockdata.dart';
import 'package:commoncents/components/chart.dart';
import 'package:commoncents/cubit/markets_cubit.dart';
import 'package:commoncents/cubit/numberpicker_cubit.dart';
import 'package:commoncents/cubit/stake_payout_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../components/appbar.dart';
import '../components/navbar.dart';
import '../components/numberPIcker.dart';
import '../components/linechart.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../components/ticks_gauge.dart';
import '../cubit/login_cubit.dart';
import '../cubit/ticks_cubit.dart';
import '../apistore/PriceProposal.dart';
import '../firebase_options.dart';
import '../pages/marketspage.dart';

class SimulationPage extends StatefulWidget {
  @override
  _SimulationPageState createState() => _SimulationPageState();
}

class _SimulationPageState extends State<SimulationPage> {
  late double ticks;
  late String stakePayout;
  late int currentAmount;
  bool isCandle = false;

  @override
  void dispose() {
    closeWebSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Trading Simulation",
        logo: "assets/images/commoncents-logo.png",
        hasBell: true,
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
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Markets()));
                              },
                              child: Container(
                                padding: const EdgeInsets.only(left: 15),
                                margin: const EdgeInsets.all(10),
                                height: 60,
                                color: Colors.grey[300],
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text("VOLATILITY INDEX"),
                                    IconButton(
                                      onPressed: null,
                                      icon: Icon(
                                        Icons.keyboard_arrow_down_sharp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              child: Container(
                                height: 60,
                                color: Colors.grey[300],
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      unsubscribe();
                                      // stockDataCubit.close();
                                      isCandle = !isCandle;
                                    });
                                  },
                                  icon: isCandle
                                      ? const Icon(Icons.line_axis)
                                      : const Icon(Icons.candlestick_chart),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 6),
                              height: 60,
                              width: 110,
                              color: Colors.grey[300],
                              child: Row(
                                children: const [
                                  IconButton(
                                    onPressed: null,
                                    icon: Icon(
                                      Icons.account_balance_wallet_sharp,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          height: MediaQuery.of(context).size.height * 0.6,
                          color: Colors.grey[300],
                          child: Center(
                            child: isCandle
                                ? CandleStickChart(
                                    isCandle: isCandle,
                                  )
                                : BlocBuilder<MarketsCubit, String>(
                                    builder: (context, market) {
                                      return MyLineChart(
                                        isCandle: isCandle,
                                        market: market,
                                      );
                                    },
                                  ),
                          ),
                        ),
                        Column(
                          children: [
                            BlocBuilder<TicksCubit, double>(
                                builder: (context, selectedValue) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [const Text("Ticks"), TicksGauge()],
                              );
                            }),
                            const SizedBox(height: 20),
                            BlocBuilder<StakePayoutCubit, int>(
                              builder: (context, index) {
                                return ToggleSwitch(
                                  minWidth: 90.0,
                                  initialLabelIndex:
                                      context.read<StakePayoutCubit>().state,
                                  cornerRadius: 20.0,
                                  activeFgColor: Colors.white,
                                  inactiveBgColor: Colors.grey,
                                  inactiveFgColor: Colors.white,
                                  totalSwitches: 2,
                                  labels: const ['Stake', 'Payout'],
                                  activeBgColors: const [
                                    [Colors.greenAccent],
                                    [Colors.blueAccent]
                                  ],
                                  onToggle: (index) {
                                    context
                                        .read<StakePayoutCubit>()
                                        .updateStakePayout(index as int);
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            BlocBuilder<CurrentAmountCubit, int>(
                                builder: (context, amount) {
                              return const IntegerExample();
                            }),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    ticks = context.read<TicksCubit>().state;
                                    if (BlocProvider.of<StakePayoutCubit>(
                                                context)
                                            .state ==
                                        0) {
                                      stakePayout = 'stake';
                                    } else if (BlocProvider.of<
                                                StakePayoutCubit>(context)
                                            .state ==
                                        1) {
                                      stakePayout = 'payout';
                                    }
                                    currentAmount = context
                                        .read<CurrentAmountCubit>()
                                        .state;
                                    handleBuy(ticks.toInt(), stakePayout,
                                        currentAmount);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    height: 45,
                                    width: 140,
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
                                    ticks = context.read<TicksCubit>().state;
                                    if (BlocProvider.of<StakePayoutCubit>(
                                                context)
                                            .state ==
                                        0) {
                                      stakePayout = 'stake';
                                    } else if (BlocProvider.of<
                                                StakePayoutCubit>(context)
                                            .state ==
                                        1) {
                                      stakePayout = 'payout';
                                    }
                                    currentAmount = context
                                        .read<CurrentAmountCubit>()
                                        .state;
                                    handleBuy(ticks.toInt(), stakePayout,
                                        currentAmount);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    height: 45,
                                    width: 140,
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
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  BlocProvider.of<LoginStateBloc>(context).initFirebase('', '');
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            BlocBuilder<MarketsCubit, String>(
                                builder: (context, market) {
                              return GestureDetector(
                                onTap: () {
                                  unsubscribe();
                                  closeWebSocket();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Markets()));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(left: 15),
                                  margin: const EdgeInsets.all(10),
                                  height: 60,
                                  color: Colors.grey[300],
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(market),
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
                                height: 60,
                                color: Colors.grey[300],
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      unsubscribe();
                                      closeWebSocket();
                                      isCandle = !isCandle;
                                    });
                                  },
                                  icon: isCandle
                                      ? const Icon(Icons.line_axis)
                                      : const Icon(Icons.candlestick_chart),
                                ),
                              ),
                            ),
                            BlocBuilder<LoginStateBloc, LoginState>(
                              builder: (context, state) {
                                if (state is AppStateInitial) {
                                  // return IconButton(
                                  //   onPressed: () {},
                                  //   icon: const Icon(
                                  //     Icons.account_balance_wallet_sharp,
                                  //   ),
                                  // );
                                } else if (state is AppStateLoggedIn) {
                                  return Row(
                                    children: [
                                      Text(state.balance),
                                    ],
                                  );
                                } else if (state is AppStateError) {
                                  return const Text("null");
                                }

                                return const CircularProgressIndicator();
                              },
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          height: MediaQuery.of(context).size.height * 0.6,
                          color: Colors.grey[300],
                          child: Center(
                            child: isCandle
                                ? CandleStickChart(
                                    isCandle: isCandle,
                                  )
                                : BlocBuilder<MarketsCubit, String>(
                                    builder: (context, market) {
                                      return MyLineChart(
                                        isCandle: isCandle,
                                        market: market,
                                      );
                                    },
                                  ),
                          ),
                        ),
                        Column(
                          children: [
                            BlocBuilder<TicksCubit, double>(
                                builder: (context, selectedValue) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [const Text("Ticks"), TicksGauge()],
                              );
                            }),
                            const SizedBox(height: 20),
                            BlocBuilder<StakePayoutCubit, int>(
                              builder: (context, index) {
                                return ToggleSwitch(
                                  minWidth: 90.0,
                                  initialLabelIndex:
                                      context.read<StakePayoutCubit>().state,
                                  cornerRadius: 20.0,
                                  activeFgColor: Colors.white,
                                  inactiveBgColor: Colors.grey,
                                  inactiveFgColor: Colors.white,
                                  totalSwitches: 2,
                                  labels: const ['Stake', 'Payout'],
                                  activeBgColors: const [
                                    [Colors.greenAccent],
                                    [Colors.blueAccent]
                                  ],
                                  onToggle: (index) {
                                    context
                                        .read<StakePayoutCubit>()
                                        .updateStakePayout(index as int);
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            BlocBuilder<CurrentAmountCubit, int>(
                                builder: (context, amount) {
                              return const IntegerExample();
                            }),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    ticks = context.read<TicksCubit>().state;
                                    if (BlocProvider.of<StakePayoutCubit>(
                                                context)
                                            .state ==
                                        0) {
                                      stakePayout = 'stake';
                                    } else if (BlocProvider.of<
                                                StakePayoutCubit>(context)
                                            .state ==
                                        1) {
                                      stakePayout = 'payout';
                                    }
                                    currentAmount = context
                                        .read<CurrentAmountCubit>()
                                        .state;
                                    handleBuy(ticks.toInt(), stakePayout,
                                        currentAmount);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    height: 45,
                                    width: 140,
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
                                    ticks = context.read<TicksCubit>().state;
                                    if (BlocProvider.of<StakePayoutCubit>(
                                                context)
                                            .state ==
                                        0) {
                                      stakePayout = 'stake';
                                    } else if (BlocProvider.of<
                                                StakePayoutCubit>(context)
                                            .state ==
                                        1) {
                                      stakePayout = 'payout';
                                    }
                                    currentAmount = context
                                        .read<CurrentAmountCubit>()
                                        .state;
                                    handleBuy(ticks.toInt(), stakePayout,
                                        currentAmount);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    height: 45,
                                    width: 140,
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
                          ],
                        ),
                      ],
                    ),
                  );
                }
              default:
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 15),
                            margin: const EdgeInsets.all(10),
                            height: 60,
                            color: Colors.grey[300],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text("VOLATILITY INDEX"),
                                IconButton(
                                  onPressed: null,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_sharp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            child: Container(
                              height: 60,
                              color: Colors.grey[300],
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    unsubscribe();
                                    closeWebSocket();
                                    isCandle = !isCandle;
                                  });
                                },
                                icon: isCandle
                                    ? const Icon(Icons.line_axis)
                                    : const Icon(Icons.candlestick_chart),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            height: 60,
                            width: 110,
                            color: Colors.grey[300],
                            child: Row(
                              children: const [
                                IconButton(
                                  onPressed: null,
                                  icon: Icon(
                                    Icons.account_balance_wallet_sharp,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        height: MediaQuery.of(context).size.height * 0.6,
                        color: Colors.grey[300],
                        child: Center(
                          child: isCandle
                              ? CandleStickChart(
                                  isCandle: isCandle,
                                )
                              : BlocBuilder<MarketsCubit, String>(
                                  builder: (context, market) {
                                    return MyLineChart(
                                      isCandle: isCandle,
                                      market: market,
                                    );
                                  },
                                ),
                        ),
                      ),
                      Column(
                        children: [
                          BlocBuilder<TicksCubit, double>(
                              builder: (context, selectedValue) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [const Text("Ticks"), TicksGauge()],
                            );
                          }),
                          const SizedBox(height: 20),
                          BlocBuilder<StakePayoutCubit, int>(
                            builder: (context, index) {
                              return ToggleSwitch(
                                minWidth: 90.0,
                                initialLabelIndex:
                                    context.read<StakePayoutCubit>().state,
                                cornerRadius: 20.0,
                                activeFgColor: Colors.white,
                                inactiveBgColor: Colors.grey,
                                inactiveFgColor: Colors.white,
                                totalSwitches: 2,
                                labels: const ['Stake', 'Payout'],
                                activeBgColors: const [
                                  [Colors.greenAccent],
                                  [Colors.blueAccent]
                                ],
                                onToggle: (index) {
                                  context
                                      .read<StakePayoutCubit>()
                                      .updateStakePayout(index as int);
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          BlocBuilder<CurrentAmountCubit, int>(
                              builder: (context, amount) {
                            return const IntegerExample();
                          }),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  ticks = context.read<TicksCubit>().state;
                                  if (BlocProvider.of<StakePayoutCubit>(context)
                                          .state ==
                                      0) {
                                    stakePayout = 'stake';
                                  } else if (BlocProvider.of<StakePayoutCubit>(
                                              context)
                                          .state ==
                                      1) {
                                    stakePayout = 'payout';
                                  }
                                  currentAmount =
                                      context.read<CurrentAmountCubit>().state;
                                  handleBuy(ticks.toInt(), stakePayout,
                                      currentAmount);
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(10)),
                                  height: 45,
                                  width: 140,
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
                                  ticks = context.read<TicksCubit>().state;
                                  if (BlocProvider.of<StakePayoutCubit>(context)
                                          .state ==
                                      0) {
                                    stakePayout = 'stake';
                                  } else if (BlocProvider.of<StakePayoutCubit>(
                                              context)
                                          .state ==
                                      1) {
                                    stakePayout = 'payout';
                                  }
                                  currentAmount =
                                      context.read<CurrentAmountCubit>().state;
                                  handleBuy(ticks.toInt(), stakePayout,
                                      currentAmount);
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10)),
                                  height: 45,
                                  width: 140,
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
                        ],
                      ),
                    ],
                  ),
                );
            }
          }),
      bottomNavigationBar: const BottomNavBar(
        index: 2,
      ),
    );
  }
}
