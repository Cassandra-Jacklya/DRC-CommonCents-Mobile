import 'dart:async';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatefulWidget {
  final String message;
  final int duration;
  final String market;
  final int amount;
  final String strategy;

  CustomAlertDialog(
      {required this.message,
      required this.duration,
      required this.market,
      required this.amount,
      required this.strategy,});

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(
        reverse:
            true); // Heartbeat-like effect, the animation will reverse once it completes.

    _colorAnimation =
        ColorTween(begin: Colors.white, end: Color.fromRGBO(145, 181, 243, 1))
            .animate(_animationController);

    // Automatically dismiss the dialog after the given duration
    Future.delayed(Duration(seconds: widget.duration), () {
      _animationController.dispose(); // Dispose the animation controller
      Navigator.of(context).pop(); // Dismiss the dialog manually
    });
  }

  @override
  void dispose() {
    _animationController
        .dispose(); // Dispose the animation controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.topCenter,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(10), // Customize the border radius here
      ),
      contentPadding: EdgeInsets.all(0),
      content: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return Container(
            color: _colorAnimation.value,
            child: child,
          );
        },
        child: Container(
            padding: const EdgeInsets.all(10),
            height: 120,
            width: 100,
            child: Column(
              children: [
                Center(
                    child: Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.strategy}",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      " Contract Bought!",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                )),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("Ticks: "),
                          Text(widget.duration.toString())
                        ],
                      ),
                      Row(
                        children: [Text("Market: "), Text(widget.market)],
                      ),
                      Row(
                        children: [
                          Text("Amount: "),
                          Text(widget.amount.toString()),
                          const Text(" USD")
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}

void showAlertDialog(BuildContext context, String message, int duration,
    String market, int amount, String strategy) {
  showDialog(
    context: context,
    barrierColor: Colors.black12,
    barrierDismissible: false, // Prevent dismissing on tap outside the dialog
    builder: (BuildContext context) {
      return CustomAlertDialog(
        message: message,
        duration: duration,
        market: market,
        amount: amount,
        strategy: strategy,
      );
    },
  );
}
