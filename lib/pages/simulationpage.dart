import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../components/numberPIcker.dart';
import '../components/linechart.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../components/ticks_gauge.dart';
import '../cubit/ticks_cubit.dart';

class SimulationPage extends StatelessWidget {
  const SimulationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                Container(
                  height: 60,
                  color: Colors.grey[300],
                  child: IconButton(
                    onPressed: null,
                    icon: const Icon(
                      Icons.candlestick_chart,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 6),
                  height: 60,
                  width: 110,
                  color: Colors.grey[300],
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: null,
                        icon: const Icon(
                          Icons.account_balance_wallet_sharp,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.all(10),
              height: 250,
              color: Colors.grey[300],
              child: const Center(
                child: MyLineChart(),
              ),
            ),
            BlocProvider<TicksCubit>(
              create: (context) => TicksCubit(),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [const Text("Ticks"), TicksGauge()],
                  ),
                  const SizedBox(height: 20),
                  ToggleSwitch(
                    minWidth: 90.0,
                    initialLabelIndex: 1,
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
                      print('switched to: $index');
                    },
                  ),
                  const SizedBox(height: 20),
                  const IntegerExample(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10)),
                        height: 45,
                        width: 140,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const [Icon(Icons.arrow_upward), Text("Higher")]),
                      ),
                      Container(
                        padding: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            color: Colors.red, borderRadius: BorderRadius.circular(10)),
                        height: 45,
                        width: 140,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const [
                              Icon(Icons.arrow_downward),
                              Text("Lower")
                            ]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
