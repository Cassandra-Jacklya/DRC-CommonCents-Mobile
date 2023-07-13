import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class ForgotPassword extends StatefulWidget {
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  void sendResetPasswordEmail(String email) async {
    final smtpServer = gmail('your.email@gmail.com', 'yourpassword');

    // Create the email message
    final message = Message()
      ..from = const Address('bentley@besquare.com.my', 'Your Name')
      ..recipients.add(email)
      ..subject = 'Reset Password'
      ..text =
          'Click the link below to reset your password:\n\nhttps://www.example.com/reset-password'
      ..html =
          '<p>Click the link below to reset your password:</p>\n<p><a href="https://www.example.com/reset-password">Reset Password</a></p>';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.toString()}');
    } catch (e) {
      print('Error sending email: $e');
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
      title: Text('Forgot Password'),
      content: Form(
        child: TextFormField(
          controller: _reset,
          decoration: InputDecoration(
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
              sendResetPasswordEmail(email);
              Navigator.of(context).pop();
              showResetPasswordConfirmationDialog(email);
            }
          },
        ),
      ],
    );
  }
}
