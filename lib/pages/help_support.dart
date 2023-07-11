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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Help and Support"),
          backgroundColor: const Color(0XFF3366FF),
          shadowColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                  child: SizedBox(
                    height: 70,
                    width: 311,
                    child: TextFormField(
                      controller: _email,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Color(0xFF5F5F5F))),
                        labelText: user!.email,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: SizedBox(
                    height: 80,
                    width: 311,
                    child: TextFormField(
                      controller: _enquiry,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Color(0xFF5F5F5F))),
                        labelText: 'Enquiry',
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () { 
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SendEnquiry()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0XFF3366FF),
                                borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.only(right: 25),
                            height: 50,
                            width: 120,
                            child: const Center(
                              child: Text("Submit",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
