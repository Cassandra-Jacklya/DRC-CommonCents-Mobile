import 'package:commoncents/cubit/markets_cubit.dart';
import 'package:commoncents/pages/simulationpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Markets extends StatefulWidget {
  _MarketsState createState() => _MarketsState();
}

class _MarketsState extends State<Markets> {
  late MarketsCubit marketsCubit;
  final List<String> items = [
    'Volatility 10',
    'Volatility 25',
    'Volatility 50',
    'Volatility 75',
    'Volatility 100',
    'Volatility 10 (1S)',
    'Volatility 25 (1S)',
    'Volatility 50 (1S)',
    'Volatility 75 (1S)',
    'Volatility 100 (1S)',
    'Jump 10',
    'Jump 25',
    'Jump 50',
    'Jump 75',
    'Jump 100',
    'Bear Market',
    'Bull Market'
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final marketsCubit = context.read<MarketsCubit>();

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        toolbarHeight: 60,
        backgroundColor: Color(0xFF3366FF),
        title: const Text("Markets"),
        foregroundColor: Colors.black,
      ),
      body: BlocBuilder<MarketsCubit, String>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final market = items[index];
              final isSelected = (market == state);
              return ListTile(
                title: Text(
                  market,
                  style: TextStyle(
                    color: isSelected ? Colors.blue : Colors.black,
                  ),
                ),
                onTap: () {
                  setState(() {
                    marketsCubit.updateMarkets(market);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SimulationPage()));
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}
