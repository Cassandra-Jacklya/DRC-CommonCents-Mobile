import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../apistore/stockdata.dart';
import '../components/chart.dart';
import '../pages/marketspage.dart';
import '../components/linechart.dart';
import '../cubit/isCandle_cubit.dart';
import '../cubit/markets_cubit.dart';

class SimulationPageGuest extends StatefulWidget {
  @override
  _SimulationPageGuestState createState() => _SimulationPageGuestState();
}

class _SimulationPageGuestState extends State<SimulationPageGuest> {
  IsCandleCubit isCandleCubit = IsCandleCubit();
  MarketsCubit marketType = MarketsCubit();
  double ticks = 0.0;
  String stakePayout = '';
  int currentAmount = 100000;
  bool isCandle = false ;
  String market = '';

  @override
  void initState() {
    super.initState();
    marketType = context.read<MarketsCubit>();
    isCandleCubit =
        context.read<IsCandleCubit>(); // Initialize the isCandleCubit
    isCandle = isCandleCubit.state;
    market = marketType.state;
  }

  @override
  void dispose() {
    closeWebSocket();
    // marketType.close();
    // isCandleCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    // Scaffold(
    //     body: Column(
    //   children: [
    //     const SizedBox(height: 10),
    //     Row(
    //       children: [
    //         BlocBuilder<MarketsCubit, String>(builder: (context, market) {
    //           return GestureDetector(
    //             onTap: () {
    //               unsubscribe();
    //               closeWebSocket();
    //               Navigator.push(context,
    //                   MaterialPageRoute(builder: (context) => Markets(market: market,)));
    //             },
    //             child: Container(
    //               padding: const EdgeInsets.only(left: 15),
    //               margin: const EdgeInsets.all(10),
    //               height: 60,
    //               color: Colors.grey[300],
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   Text(market),
    //                   const IconButton(
    //                     onPressed: null,
    //                     icon: Icon(
    //                       Icons.keyboard_arrow_down_sharp,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           );
    //         }),
    //         GestureDetector(
    //           child: Container(
    //             height: 60,
    //             color: Colors.grey[300],
    //             child: IconButton(
    //               onPressed: () {
    //                 setState(() {
    //                   unsubscribe();
    //                   closeWebSocket();
    //                   isCandle = !isCandle;
    //                   isCandleCubit.isItCandles(isCandle);
    //                 });
    //               },
    //               icon: isCandle
    //                   ? const Icon(Icons.line_axis)
    //                   : const Icon(Icons.candlestick_chart),
    //             ),
    //           ),
    //         ),
    //         Container(
    //           margin: const EdgeInsets.symmetric(horizontal: 10),
    //           width: 25,
    //           height: 25,
    //           decoration: const BoxDecoration(
    //             shape: BoxShape.circle,
    //             color: Colors.blue,
    //           ),
    //           child: const Icon(
    //             Icons.info,
    //             color: Colors.white,
    //             size: 24,
    //           ),
    //         ),
    //       ],
    //     ),
    //     Container(
    //       margin: const EdgeInsets.symmetric(vertical: 10),
    //       height: MediaQuery.of(context).size.height * 0.4,
    //       color: Colors.grey[300],
    //       child: Center(
    //         child: isCandle
    //             ? BlocBuilder<MarketsCubit, String>(builder: (context, market) {
    //                 return CandleStickChart(
    //                   isCandle: isCandle,
    //                   market: market,
    //                 );
    //               })
    //             : BlocBuilder<MarketsCubit, String>(
    //                 builder: (context, market) {
    //                   return MyLineChart(
    //                     isMini: false,
    //                     isCandle: isCandle,
    //                     market: market,
    //                   );
    //                 },
    //               ),
    //       ),
    //     ),
    //   ],
    // ));
  }
}
