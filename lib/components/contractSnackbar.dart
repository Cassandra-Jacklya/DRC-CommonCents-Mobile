import 'package:flutter/material.dart';

class CustomAlertDialog extends StatefulWidget {
  final String message;
  final int duration;

  CustomAlertDialog({required this.message, required this.duration});

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  @override
  void initState() {
    super.initState();
    // Automatically dismiss the dialog after the given duration
    Future.delayed(Duration(seconds: widget.duration), () {
      Navigator.of(context).pop(); // Dismiss the dialog manually
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(widget.message),
    );
  }
}

void showAlertDialog(BuildContext context, String message, int duration) {
  showDialog(
    context: context,
    barrierColor: Colors.black12,
    barrierDismissible: false, 
    builder: (BuildContext context) {
      return CustomAlertDialog(message: message, duration: duration);
    },
  );
}
