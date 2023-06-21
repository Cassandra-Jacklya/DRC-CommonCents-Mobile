import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../components/numberPIcker.dart';

class SimulationPage extends StatefulWidget {
  @override
  _SimulationPageState createState() => _SimulationPageState();
}

class _SimulationPageState extends State<SimulationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [
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
                  children: [
                    const Text("VOLATILITY INDEX"),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
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
                  onPressed: () {},
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
                      onPressed: () {},
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
              child: Text("Area chart graph"),
            ),
          ),
          ToggleSwitch(
            minWidth: 90.0,
            initialLabelIndex: 1,
            cornerRadius: 20.0,
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            totalSwitches: 2,
            labels: const ['Stake', 'Payout'],
            activeBgColors: [
              [Colors.blue],
              [Colors.pink]
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
              Container( padding: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)),
                height: 45,
                width: 140,
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [ 
                  Icon(Icons.arrow_upward),
                  const Text("Higher")
                ]),
              ),
              Container( padding: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10)),
                height: 45,
                width: 140,
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: const [ 
                  Icon(Icons.arrow_downward),
                  Text("Lower")
                ]),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
