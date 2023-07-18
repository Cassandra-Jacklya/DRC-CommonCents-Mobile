import 'dart:async';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/safe_area_values.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../pages/simulationpage.dart';

class SnackBarContent extends StatefulWidget {
  final String message;
  final int initialDuration;

  const SnackBarContent({
    Key? key,
    required this.message,
    required this.initialDuration,
  }) : super(key: key);

  @override
  _SnackBarContentState createState() => _SnackBarContentState();
}

class _SnackBarContentState extends State<SnackBarContent> {
  late int timerSeconds;
  late AnimationController localAnimationController;

  @override
  void initState() {
    super.initState();
    timerSeconds = widget.initialDuration;
    startTimer();
  }

  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        timerSeconds--;
      });

      if (timerSeconds <= 0) {
        timer.cancel();
        setState(() {
          isSnackbarVisible = false;
        });
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      // Wrap the content in a Stack
      children: [
        SizedBox(
          height: 220,
          width: 100,
          child: Row(
            children: [
              Text(widget.message),
              const SizedBox(width: 8),
              Text(
                '$timerSeconds',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        // ModalBarrier(
        //   color: Colors.transparent, // Set the desired color for the barrier
        //   dismissible: false,
        // ),
      ],
    );
  }
}
