import 'package:commoncents/apistore/stockdata.dart';
import 'package:commoncents/components/chart.dart';
import 'package:commoncents/cubit/isCandle_cubit.dart';
import 'package:commoncents/cubit/markets_cubit.dart';
import 'package:commoncents/cubit/numberpicker_cubit.dart';
import 'package:commoncents/cubit/stake_payout_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../components/appbar.dart';
import '../components/navbar.dart';
import '../components/numberPIcker.dart';
import '../components/linechart.dart';
import '../components/ticks_gauge.dart';
import '../cubit/candlestick_cubit.dart';
import '../cubit/login_cubit.dart';
import '../cubit/navbar_cubit.dart';
import '../cubit/news_tabbar_cubit.dart';
import '../cubit/stock_data_cubit.dart';
import '../cubit/ticks_cubit.dart';
import '../apistore/PriceProposal.dart';
import '../firebase_options.dart';
import '../pages/marketspage.dart';

class SimulationPage extends StatefulWidget {
  const SimulationPage({super.key});

  @override
  _SimulationPageState createState() => _SimulationPageState();
}

class _SimulationPageState extends State<SimulationPage> {
  late IsCandleCubit isCandleCubit;
  late MarketsCubit marketType;
  late double ticks;
  late String stakePayout;
  late int currentAmount;
  late bool isCandle;
  late String market;

  // @override
  // void initState() {
  //   super.initState();
  //   marketType = context.read<MarketsCubit>();
  //   isCandleCubit =
  //       context.read<IsCandleCubit>(); // Initialize the isCandleCubit
  //   isCandle = isCandleCubit.state;
  //   market = marketType.state;
  // }

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
          BlocProvider<StakePayoutCubit>(create: (context)=> StakePayoutCubit()),
          BlocProvider<TicksCubit>(create: (context) => TicksCubit()),
          BlocProvider<CurrentAmountCubit>(create: (context) => CurrentAmountCubit()),
          BlocProvider<CandlestickCubit>(create: (context) => CandlestickCubit()),
          BlocProvider<MarketsCubit>(create: (context) => MarketsCubit()),
          BlocProvider<IsCandleCubit>(create: (content) => IsCandleCubit()),
      ],
      child: Scaffold(
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
                    //not logged in
                    return Container();
                  } else {
                    //logged in
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
                                            builder: (context) =>
                                                const Markets()));
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
                                        // isCandleCubit.isItCandles(isCandle);
                                      });
                                    },
                                    icon: isCandle
                                        ? const Icon(Icons.line_axis)
                                        : const Icon(Icons.candlestick_chart),
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                width: 25,
                                height: 25,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue,
                                ),
                                child: const Icon(
                                  Icons.info,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              BlocConsumer<LoginStateBloc, LoginState>(
                                builder: (context, state) {
                                  if (state is AppStateLoggedIn) {
                                    return Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          const Icon(Icons.wallet),
                                          Text(
                                            "${double.parse(state.balance).toStringAsFixed(2)} USD",
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                  return const SizedBox();
                                },
                                listenWhen: (previous, current) {
                                  return current
                                      is AppStateLoggedIn; 
                                },
                                listener: (context, state) {
                                  if (state is AppStateLoggedIn) {
                                  }
                                },
                              )
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            height: MediaQuery.of(context).size.height * 0.6,
                            color: Colors.grey[300],
                            child: Center(
                              child: isCandle
                                  ? BlocBuilder<MarketsCubit, String>(
                                      builder: (context, market) {
                                      return CandleStickChart(
                                        isCandle: isCandle,
                                        market: market,
                                      );
                                    })
                                  : BlocBuilder<MarketsCubit, String>(
                                      builder: (context, market) {
                                        return MyLineChart(isMini: false,
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
                                      handleBuy(context, ticks.toInt(),
                                          stakePayout, currentAmount);
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
                                      handleBuy(context, ticks.toInt(),
                                          stakePayout, currentAmount);
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
                              const SizedBox(height: 20),
                            ],
                          ),
                        ],
                      ),
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
