// ignore: file_names
import 'package:commoncents/apistore/miniChartData.dart';
import 'package:commoncents/apistore/stockdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          child: GestureDetector(
            onTap: () {
                showDialog(
                  context: context,
                  // barrierDismissible: false,
                  builder: (BuildContext usdContext) {
                    return AlertDialog(
                      alignment: Alignment.center,
                      content: TextField(
                        autofocus: true,
                        textAlign: TextAlign.center,
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          _amountFormatter
                        ], // Apply the formatter
                        onSubmitted: (value) {
                          final amount = int.tryParse(value) ?? 0;
                          // Limit the input to a range of 0 to 500
                          final limitedAmount = amount.clamp(0, 500);
                          currentAmountCubit.setCurrentAmount(limitedAmount);
                        },
                        decoration: InputDecoration(
                          hintText: currentAmountCubit.state == 0
                              ? 'USD'
                              : currentAmountCubit.state.toString(),
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.of(usdContext).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            
            child: SizedBox(
              height: 35,
              child: TextField(
                enabled: false,
                textAlign: TextAlign.center,
                controller: _controller,
                keyboardType: TextInputType.number,
                inputFormatters: [_amountFormatter], // Apply the formatter
                onSubmitted: (value) {
                  final amount = int.tryParse(value) ?? 0;
                  // Limit the input to a range of 0 to 500
                  final limitedAmount = amount.clamp(0, 500);
                  currentAmountCubit.setCurrentAmount(limitedAmount);
                },
                decoration: InputDecoration(
                  hintText: currentAmountCubit.state == 0
                      ? 'USD'
                      : currentAmountCubit.state.toString(),
                ),
              ),
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
