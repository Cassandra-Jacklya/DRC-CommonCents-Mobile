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
    final isGoogleSignIn = user != null &&
        user.providerData.any((info) => info.providerId == 'google.com');
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
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
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 33),
                    child: Hero(
                      tag: 'test',
                      child: ClipOval(
                        child: Container(
                          // height: MediaQuery.of(context).size.height * 0.14,
                          // width: MediaQuery.of(context).size.width * 0.3,
                          height: 87,
                          width: 87,
                          decoration: BoxDecoration(
                            image: DecorationImage(
//                               Image.network('Your image url...',
//     errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
//         return Text('Your error widget...');
//     },
// ),
                              image: widget.photoUrl.isNotEmpty
                                  ? NetworkImage(widget.photoUrl)
                                  : const NetworkImage(
                                      'https://www.seekpng.com/png/detail/966-9665493_my-profile-icon-blank-profile-image-circle.png',
                                    ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.displayName ?? user!.email!,
                            style: const TextStyle(fontSize: 17),
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
                    labelText: user?.displayName ?? user!.email!,
                    suffixIcon: const Icon(Icons.edit),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Divider(
                indent: 20,
                endIndent: 20,
                thickness: 1,
              ),
              const SizedBox(height: 15),
              const SizedBox(
                  // width: MediaQuery.of(context).size.width * 0.6,
                  width: 313,
                  height: 34,
                  child: Text(
                    "This is the email associated with CommonCents.",
                    style: TextStyle(fontSize: 14),
                  )),
              const SizedBox(height: 14),
              Container(
                height: 70,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  decoration: InputDecoration(
                    enabled: false,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    labelText: widget.email,
                    labelStyle: const TextStyle(color: Color(0xFFCCCCCC)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                  width: 333,
                  margin: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Text(
                            "Click ",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            "Change Password ",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "to change your ",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const Text(
                        "CommonCents password.",
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  )),
              Container(
                child: isGoogleSignIn ? Container() : Align(
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
                      margin: const EdgeInsets.only(left: 33, top: 14),
                      height: 31,
                      width: 142,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color(0xFF3366FF),
                      ),
                      child: const Center(
                        child: Text("Change Password",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
