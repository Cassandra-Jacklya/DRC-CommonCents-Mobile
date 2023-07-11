import 'package:flutter/material.dart';
import 'package:passwordfield/passwordfield.dart';
import '../components/popup.dart';
import 'package:iconsax/iconsax.dart';

class Security extends StatefulWidget {
  final String displayName;

  Security({
    Key? key,
    required this.displayName,
  }) : super(key: key);

  @override
  _SecurityState createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        toolbarHeight: 60,
        backgroundColor: Color(0XFF3366FF),
        title: const Text("Email and Password"),
        foregroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 50, bottom: 30),
              height: 60,
              width: MediaQuery.of(context).size.width * 0.9,
              // color: Colors.grey[400],
              child: const Text(
                "This is the password associated with CommonCents",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            height: 55,
            width: MediaQuery.of(context).size.width * 0.9,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 0.6, color: const Color(0xFF5F5F5F)),
            ),
            child: Text(widget.displayName),
          ),
          // const SizedBox(height: 40),
                    Center(
            child: Container(
              margin: const EdgeInsets.only(top: 50, bottom: 30),
              height: 60,
              width: MediaQuery.of(context).size.width * 0.9,
              // color: Colors.grey[400],
              child: const Text(
                "Click Change Password to change your CommonCents password.",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          // const SizedBox(height: 30),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext securityDialog) {
                  return Password();
                },
              );
            },
            child: Container(
              margin: const EdgeInsets.only(left: 16),
              height: 50,
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                color: const Color(0XFF3366FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(child: Text(style: TextStyle(color: Colors.white),"Change Password")),
            ),
          )
          // Container(
          //   margin: const EdgeInsets.only(left: 16),
          //   height: 50,
          //   child: TextButton(
          //     onPressed: () {
          //       // Handle change password button click
          //     },
          //     child: const Text("Change Password"),
          //     style: TextButton.styleFrom(
          //       backgroundColor: Colors.grey[300],
          //       // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

          // Container(
          //   margin: const EdgeInsets.only(left: 16, bottom: 25),
          //   width: MediaQuery.of(context).size.width * 0.9,
          //   child: PasswordField(
          //     backgroundColor: Colors.grey[600],
          //     color: Colors.blue,
          //     passwordConstraint: r'.*[@$#.*].*',
          //     // inputDecoration: PasswordDecoration(),
          //     // hintText: 'must have special characters',
          //     border: PasswordBorder(
          //       border: OutlineInputBorder(
          //         borderSide: BorderSide(
          //           color: Colors.blue.shade100,
          //         ),
          //         borderRadius: BorderRadius.circular(0),
          //       ),
          //       focusedBorder: OutlineInputBorder(
          //         borderSide: BorderSide(
          //           color: Colors.blue.shade100,
          //         ),
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //       focusedErrorBorder: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(12),
          //         borderSide: BorderSide(width: 2, color: Colors.red.shade200),
          //       ),
          //     ),
          //     errorMessage: 'must contain special character either . * @ # \$',
          //   ),
          // ),
