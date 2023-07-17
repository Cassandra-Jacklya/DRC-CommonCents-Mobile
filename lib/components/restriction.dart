

import 'package:flutter/material.dart';

class OverlayWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: true, // Set this to true when you want to ignore taps
        child: Container(
          color: Colors.transparent,
        ),
      ),
    );
  }
}


