import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class ForgotPassword extends StatefulWidget {
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  void sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      showResetPasswordConfirmationDialog(email);
    } catch (e) {
      print('Error sending password reset email: $e');
    }
  }

  void showResetPasswordConfirmationDialog(String email) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Password Reset'),
          content: Text(
              'An email with instructions to reset your password has been sent to $email'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String email = '';
    TextEditingController _reset = TextEditingController();
    return AlertDialog(
      title: const Text('Forgot Password'),
      content: Form(
        child: TextFormField(
          controller: _reset,
          decoration: const InputDecoration(
            labelText: 'Enter your email',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            return null;
          },
          onChanged: (value) {
            email = value;
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Reset Password'),
          onPressed: () {
            if (_reset.text != "") {
              sendPasswordResetEmail(email);
              Navigator.of(context).pop();
              showResetPasswordConfirmationDialog(email);
            }
          },
        ),
      ],
    );
  }
}
