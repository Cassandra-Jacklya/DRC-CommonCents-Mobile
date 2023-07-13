import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/chartTime_cubit.dart';
import '../cubit/lineTime_cubit.dart';

class LineTime extends StatefulWidget {
  _LineTimeState createState() => _LineTimeState();
}

class _LineTimeState extends State<LineTime> {
  List<String> timeUnit = ['Ticks', 'Minutes', 'Hours', 'Days'];
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<LineTimeCubit>(create: (context) => LineTimeCubit())
    ],
      child: Container(
        height: 50,
        child: BlocBuilder(
          builder: (context,state) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: timeUnit.length,
              itemBuilder: (context, index) {
                final unit = timeUnit[index];
                final isSelected = (unit == state);
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  width: 80,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.white,borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(child: Text(timeUnit[index])),
                );
              },
            );
          }
        ),
      ),
    );
  }
}
