import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../cubit/ticks_cubit.dart';

class TicksGauge extends StatefulWidget {
  @override
  _TicksGaugeState createState() => _TicksGaugeState();
}

class _TicksGaugeState extends State<TicksGauge> {
  double selectedValue = 1.0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicksCubit, double>(builder: (context, selectedValue) {
      return SfLinearGauge(
        animateAxis: true,
        minimum: 1.0,
        maximum: 10.0,
        showTicks: false,
        showLabels: false,
        barPointers: [LinearBarPointer(value: selectedValue)],
        orientation: LinearGaugeOrientation.horizontal,
        axisTrackStyle: LinearAxisTrackStyle(
          color: Colors.grey[300],
          edgeStyle: LinearEdgeStyle.bothFlat,
          thickness: 3.0,
          borderColor: Colors.grey,
        ),
        markerPointers: List<LinearWidgetPointer>.generate(10, (index) {
          final value = index + 1; // Add 1 to start from 1 instead of 0
          return LinearWidgetPointer(
            value: value.toDouble(),
            offset: -20,
            child: GestureDetector(
              onTap: () {
                // Handle the tap on the number
                selectedValue = value.toDouble();
                context.read<TicksCubit>().updateSelectedValue(selectedValue);
                print(selectedValue);
              },
              child: Container(
                width: value == selectedValue ? 30 : 20,
                height: value == selectedValue ? 30 : 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      selectedValue >= value ? Colors.cyan : Colors.grey[300],
                ),
                child: Center(
                  child: value == selectedValue
                      ? Text(
                          value.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
              ),
            ),
          );
        }),
      );
    });
  }
}
