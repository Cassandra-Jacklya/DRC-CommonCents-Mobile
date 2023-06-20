import 'package:flutter/material.dart';
import 'package:passwordfield/passwordfield.dart';
import '../components/popup.dart';
import 'package:iconsax/iconsax.dart';

class Security extends StatelessWidget {
  const Security({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        toolbarHeight: 60,
        backgroundColor: Colors.grey[300],
        title: const Text("Security"),
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
            margin: const EdgeInsets.only(left: 16, bottom: 25),
            width: MediaQuery.of(context).size.width * 0.9,
            child: PasswordField(
              backgroundColor: Colors.grey[600],
              color: Colors.blue,
              passwordConstraint: r'.*[@$#.*].*',
              // inputDecoration: PasswordDecoration(),
              // hintText: 'must have special characters',
              border: PasswordBorder(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue.shade100,
                  ),
                  borderRadius: BorderRadius.circular(0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue.shade100,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(width: 2, color: Colors.red.shade200),
                ),
              ),
              errorMessage: 'must contain special character either . * @ # \$',
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const Password();
                },
              );
            },
            child: Container(
              margin: const EdgeInsets.only(left: 16),
              height: 50,
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(child: Text("Change Password")),
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
