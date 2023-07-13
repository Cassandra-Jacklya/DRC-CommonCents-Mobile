import 'package:commoncents/cubit/markets_cubit.dart';
import 'package:commoncents/pages/simulationpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Markets extends StatefulWidget {
  const Markets({super.key});

  @override
  _MarketsState createState() => _MarketsState();

}

class _MarketsState extends State<Markets> {
  // late MarketsCubit marketsCubit;
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
    // marketsCubit = context.read<MarketsCubit>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<MarketsCubit>(create: (context) => MarketsCubit())
      ],
      child:BlocBuilder<MarketsCubit, String>(
        builder: (context, state) {
          print("test");
          return Scaffold(
            appBar: AppBar(
              shadowColor: Colors.transparent,
              toolbarHeight: 60,
              backgroundColor: const Color(0xFF3366FF),
              foregroundColor: Colors.black,
              title: const Text("Markets"),
              // leading: IconButton(
              //   icon: const Icon(Icons.arrow_back),
              //   // onPressed: () {
              //   //   print("Here: ${state}");
              //   //   BlocProvider.of<MarketsCubit>(context).updateMarkets(state);
              //   //   Navigator.pushReplacement(
              //   //     context,
              //   //     MaterialPageRoute(builder: (context) => SimulationPage(market: state)),
              //   //   );
              //   // },
              // ),
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
                          print("There:${market}");
                          BlocProvider.of<MarketsCubit>(context).updateMarkets(market);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SimulationPage(market: market,)));
                        });
                      },
                    );
                  },
                );
              },
            ),
          );
        }
      ),
    );
  }
}
