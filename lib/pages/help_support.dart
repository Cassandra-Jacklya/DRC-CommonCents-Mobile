import 'package:commoncents/pages/sendEnquiry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class HelpSupport extends StatefulWidget {
  _HelpSupportState createState() => _HelpSupportState();
}

class _HelpSupportState extends State<HelpSupport> {
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _enquiry = TextEditingController();
  Color _buttonColor = Colors.grey;
  // Function to check if both _email and _enquiry are not empty
  void _updateButtonColor() {
    setState(() {
      if (_email.text.isNotEmpty && _enquiry.text.isNotEmpty) {
        _buttonColor = const Color(0XFF3366FF);
      } else {
        _buttonColor = Colors.grey;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Help and Support"),
          backgroundColor: const Color(0XFF3366FF),
          shadowColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
                child: const Text(
                  "Once your enquiry has been sent, we will get in touch with you within 12 hours.",
                  style: TextStyle(fontSize: 17),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 30, 0, 0),
                child: SizedBox(
                  height: 57,
                  width: 283,
                  child: TextFormField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) =>
                        _updateButtonColor(), // Call function here
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Color(0xFF5F5F5F))),
                      labelText: "Email*",
                      hintText: user!.email,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 27, 0, 0),
                child: SizedBox(
                  height: 221,
                  width: 283,
                  child: TextFormField(
                    maxLines: 15,
                    controller: _enquiry,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) =>
                        _updateButtonColor(), // Call function here
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Color(0xFF5F5F5F))),
                      hintText: 'How may we help you?',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _buttonColor == Colors.grey
                              ? {}
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SendEnquiry(),
                                  ),
                                );
                        },
                        child: AnimatedContainer(
                          // Use AnimatedContainer to handle color transitions
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: _buttonColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.only(right: 70),
                          height: 42,
                          width: 91,
                          child: const Center(
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
