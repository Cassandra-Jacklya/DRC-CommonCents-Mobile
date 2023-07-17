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
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: SizedBox(
                    height: 57,
                    width: 283,
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
                        labelText: "Email*",
                        hintText: user!.email,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 27, 0, 0),
                  child: SizedBox(
                    height: 221,
                    width: 283,
                    child: TextFormField(
                      maxLines: 15,
                      controller: _enquiry,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SendEnquiry()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0XFF3366FF),
                                borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.only(right: 45),
                            height: 42,
                            width: 91,
                            child: const Center(
                              child: Text("Submit",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
