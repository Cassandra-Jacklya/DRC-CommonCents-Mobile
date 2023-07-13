import 'package:commoncents/cubit/chartTime_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChartTime extends StatefulWidget {
  _ChartTimeState createState() => _ChartTimeState();
}

class _ChartTimeState extends State<ChartTime> {
  List<String> timeUnit = ['Minutes', 'Hours', 'Days'];
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
       BlocProvider<ChartTimeCubit>(create: (context) => ChartTimeCubit())
    ],
      child: Container(
        margin: const EdgeInsets.only(left: 60),
        height: 50,
        child: BlocBuilder<ChartTimeCubit, String>(builder: (context, state) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: timeUnit.length,
            itemBuilder: (context, index) {
              final unit = timeUnit[index];
              final isSelected = (unit == state);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    BlocProvider.of<ChartTimeCubit>(context)
                        .updateChartTime(unit);
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  width: 80,
                  height: 50,
                  decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(child: Text(timeUnit[index])),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
