import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commoncents/components/walletbutton.dart';
import 'package:commoncents/cubit/login_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import '../components/popup.dart';
import '../components/walletbutton.dart';
import '../cubit/login_cubit.dart';

class MyAccount extends StatefulWidget {
  final String photoUrl;
  final String displayName;
  final double balance;
  final String email;

  MyAccount(
      {Key? key,
      required this.photoUrl,
      required this.displayName,
      required this.balance,
      required this.email})
      : super(key: key);

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  TextEditingController textEditingController = TextEditingController();

  Future<void> updateDisplayName() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await user.updateDisplayName(textEditingController.text);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'displayName': textEditingController.text});
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Name successfully changed.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } catch (error) {
        // Handle the error appropriately (e.g., display an error message)
      }
      setState(() {
        textEditingController.clear();
      });
    }
  }

  void showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to change your details?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                updateDisplayName();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        toolbarHeight: 60,
        backgroundColor: const Color(0XFF3366FF),
        title: const Text("My Account"),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Hero(
                  tag: 'test',
                  child: ClipOval(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.14,
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: widget.photoUrl.isNotEmpty
                              ? NetworkImage(widget.photoUrl)
                              : NetworkImage(
                                  'https://www.seekpng.com/png/detail/966-9665493_my-profile-icon-blank-profile-image-circle.png',
                                ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.email ?? 'Anonymous',
                        style: const TextStyle(fontSize: 25),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      // WalletButton(loginStateBloc: LoginStateBloc),
                      // Row(
                      //   children: [
                      //     Icon(Icons.account_balance_wallet_sharp),
                      //     const SizedBox(width: 10),
                      //     Text(
                      //       "${widget.balance.toStringAsFixed(2)} USD",
                      //       style: const TextStyle(
                      //           fontSize: 18, fontWeight: FontWeight.bold),
                      //     )
                      //   ],
                      // )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 50),
            Container(
              height: 70,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                controller: textEditingController,
                onFieldSubmitted: (String value) {
                  showConfirmationDialog();
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF5F5F5F)),
                  ),
                  labelText:
                      user!.displayName == "" ? "Anonymous" : user.displayName,
                  suffixIcon: const Icon(Icons.edit),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            // Container(
            //   height: 2,
            //   width: MediaQuery.of(context).size.width * 0.9,
            //   color: Colors.grey[400],
            // ),
            // const SizedBox(height: 20),
            const Divider(
              indent: 20,
              endIndent: 20,
              thickness: 1,
            ),
            const SizedBox(height: 15),
            Row(children: [
              Container(
                  margin: const EdgeInsets.only(left: 30),
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: const Text(
                    "This is the email associated with CommonCents.",
                    style: TextStyle(fontSize: 14),
                  ))
            ]),
            const SizedBox(height: 20),
            Container(
              height: 70,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                decoration: InputDecoration(
                  enabled: false,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: Colors.black), 
                  ),
                  labelText: widget.email,
                  labelStyle: const TextStyle(color: Colors.black),
                  suffixIcon: const Icon(Icons.person),
                  suffixIconColor: Colors.black
                ),
              ),
            ),

            const SizedBox(height: 20),
            Row(children: [
              Container(
                  margin: const EdgeInsets.only(left: 30),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: const Text(
                    "Click Change Password to change your CommonCents password",
                    style: TextStyle(fontSize: 14),
                  ))
            ]),
            Align(
              alignment: Alignment.bottomLeft,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Password();
                    },
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 30, top: 20),
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFF3366FF),
                  ),
                  child: const Center(
                    child: Text("Change Password",
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
