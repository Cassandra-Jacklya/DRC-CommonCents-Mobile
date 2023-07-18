// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/numberpicker_cubit.dart';

class IntegerExample extends StatefulWidget {
  const IntegerExample({Key? key}) : super(key: key);

  @override
  _IntegerExampleState createState() => _IntegerExampleState();
}

class _IntegerExampleState extends State<IntegerExample> {
  final TextEditingController _controller = TextEditingController();

  // @override
  // void didChangeDependencies() {

  //   super.didChangeDependencies();
  // }

  // @override
  // void dispose() {
  //   currentAmountCubit.close();
  //   _controller.dispose();
  //   super.dispose();
  // }

  final _amountFormatter =
      FilteringTextInputFormatter.allow(RegExp(r'^[0-9]{1,3}$'));

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
                builder: (BuildContext context) {
                  final TextEditingController dialogController =
                      TextEditingController();

                  return Stack(
                    children: [
                      // const ModalBarrier(
                      //     color: Colors.transparent, dismissible: false),
                      AlertDialog(
                        // Prevent dismissing on tap outside the dialog
                        alignment: Alignment.center,
                        content: RawKeyboardListener(
                          focusNode: FocusNode(),
                          onKey: (RawKeyEvent event) {
                            if (event is RawKeyDownEvent &&
                                event.logicalKey == LogicalKeyboardKey.enter) {
                              final amount =
                                  int.tryParse(dialogController.text) ?? 0;
                              // Limit the input to a range of 0 to 500
                              final limitedAmount = amount.clamp(0, 500);
                              currentAmountCubit
                                  .setCurrentAmount(limitedAmount);
                              Navigator.of(context)
                                  .pop(); // Dismiss the dialog when the Enter key is pressed
                            }
                          },
                          child: TextField(
                            autofocus: false,
                            textAlign: TextAlign.center,
                            controller: dialogController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              _amountFormatter
                            ], // Apply the formatter
                            onSubmitted: (value) {
                              final amount = int.tryParse(value) ?? 0;
                              // Limit the input to a range of 0 to 500
                              final limitedAmount = amount.clamp(0, 500);
                              currentAmountCubit
                                  .setCurrentAmount(limitedAmount);
                            },
                            decoration: InputDecoration(
                              hintText: currentAmountCubit.state == 0
                                  ? 'USD'
                                  : currentAmountCubit.state.toString(),
                            ),
                          ),
                        ),
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
