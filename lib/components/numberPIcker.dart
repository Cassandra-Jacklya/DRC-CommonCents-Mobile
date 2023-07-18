// ignore: file_names
import 'package:commoncents/apistore/miniChartData.dart';
import 'package:commoncents/apistore/stockdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
import '../cubit/numberpicker_cubit.dart';

class IntegerExample extends StatefulWidget {
  IntegerExample({Key? key}) : super(key: key);

  @override
  State<IntegerExample> createState() => _IntegerExampleState();
}

class _IntegerExampleState extends State<IntegerExample> {
  final TextEditingController _controller = TextEditingController();

  double currentAmount = 0;

  final _amountFormatter =
      FilteringTextInputFormatter.allow(RegExp(r'^[0-9]{1,3}$'));

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    CurrentAmountCubit currentAmountCubit = context.watch<CurrentAmountCubit>();

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            if (currentAmountCubit.state <= 0) {
            } else {
              currentAmountCubit.decrement(currentAmountCubit.state);
              _controller.text = currentAmountCubit.state.toString();
            }
          },
        ),
        Expanded(
          child: NumberPicker(
            value: currentAmountCubit.state,
            minValue: 0,
            maxValue: 500,
            onChanged: (newValue) {
              currentAmountCubit.setCurrentAmount(newValue);
              _controller.text = newValue.toString();
            },
            axis: Axis.vertical,
            itemCount: 1, // Customize the height of each item in the picker
            // highlightSelectedValue: true,
            textStyle: TextStyle(fontSize: 20), // Customize the font size
            decoration: BoxDecoration(
              border: Border.all(color:  const Color(0XFF5F5F5F), width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            if (currentAmountCubit.state >= 500) {
            } else {
              currentAmountCubit.increment(currentAmountCubit.state);
              _controller.text = currentAmountCubit.state.toString();
            }
          },
        ),
      ],
    );
  }
}
