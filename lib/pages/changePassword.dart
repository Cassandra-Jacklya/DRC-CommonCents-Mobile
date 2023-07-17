import 'package:commoncents/pages/profilepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

import '../components/navbar.dart';

class ChangePassword extends StatefulWidget {
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late bool viewPass;
  late bool viewPass2;
  TextEditingController textEditingController = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();

  void changePassword() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String currentPassword = textEditingController.text;
    final String newPassword = textEditingController2.text;

    if (user != null) {
      bool passwordMatch = await verifyPasswordMatch(user, newPassword);
      if (passwordMatch) {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext passwordDialog) {
            return AlertDialog(
              title: const Text("Cannot use existing password as new password"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(passwordDialog).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        print("Password can change");
        await user.updatePassword(newPassword);
        Navigator.of(context).pop();
        print('Password updated successfully!');
      }
    }
  }

  Future<bool> verifyPasswordMatch(User user, String newPassword) async {
    try {
      // Sign in the user with the new password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user.email!,
        password: newPassword,
      );
      return true;
    } catch (error) {
      if (error is PlatformException && error.code == 'wrong-password') {
        print("ok");
        return false;
      }
      // Handle other types of exceptions here
      print("Error verifying password match: $error");
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    viewPass = false;
    viewPass2 = false;
  }

  @override
  void dispose() {
    textEditingController.dispose();
    textEditingController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          toolbarHeight: 60,
          backgroundColor: Color(0XFF3366FF),
          title: const Text("Change Password"),
          foregroundColor: Colors.black,
        ),
        body: Column(
          children: [
            Container(
              // width: MediaQuery.of(context).size.width * 0.9,
              width: 300,
              margin: const EdgeInsets.only(top: 40, bottom: 30),
              child: TextFormField(
                controller: textEditingController,
                obscureText: viewPass ? false : true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF5F5F5F))),
                    labelText: 'New Password',
                    suffixIcon: viewPass
                        ? const Icon(Iconsax.eye)
                        : const Icon(Iconsax.eye_slash)),
                onTap: () {
                  setState(() {
                    viewPass = !viewPass;
                  });
                },
              ),
            ),
            Container(
              // width: MediaQuery.of(context).size.width * 0.9,
              width: 300,
              margin: const EdgeInsets.only(bottom: 30),
              child: TextFormField(
                controller: textEditingController2,
                obscureText: viewPass2 ? false : true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF5F5F5F))),
                    labelText: 'Confirm Password',
                    // hintText: 'ben',
                    suffixIcon: viewPass2
                        ? const Icon(Iconsax.eye)
                        : const Icon(Iconsax.eye_slash)),
                onTap: () {
                  setState(() {
                    viewPass2 = !viewPass2;
                  });
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () {
                  textEditingController.text != "" &&
                          textEditingController2.text != "" &&
                          textEditingController.text ==
                              textEditingController2.text
                      ? changePassword()
                      : {};
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: textEditingController.text ==
                                textEditingController2.text &&
                            textEditingController.text != "" &&
                            textEditingController2.text != ""
                        ? const Color(0XFF3366FF)
                        : Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.only(top: 10, right: 30),
                  height: 50,
                  width: 300,
                  child: const Center(
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}


  // if (user != null) {
  //   try {
  //     final AuthCredential credential = EmailAuthProvider.credential(
  //       email: user.email!,
  //       password: currentPassword,
  //     );

  //     final UserCredential userCredential =
  //         await user.reauthenticateWithCredential(credential);

  //     if (userCredential.user != null) {
  //       if (currentPassword == newPassword) {
          
  //           },
  //         );
  //       } else {
  //         // Code to change the password using your desired authentication method
  //         // For example, with Firebase Authentication:
  //         await user.updatePassword(newPassword);

  //         // Display a success message or perform any other necessary actions
  //         showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: const Text("Password changed successfully"),
  //               actions: [
  //                 TextButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: const Text("OK"),
  //                 ),
  //               ],
  //             );
  //           },
  //         );
  //       }
  //     } else {
  //       // Password is incorrect, display an error message
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: const Text("Incorrect password"),
  //             actions: [
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: const Text("OK"),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     }
  //   } catch (e) {
  //     print("Error reauthenticating user: $e");
  //   }
  // }