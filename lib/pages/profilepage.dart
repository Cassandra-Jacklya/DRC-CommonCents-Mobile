import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commoncents/components/popup.dart';
import 'package:commoncents/pages/favourites.dart';
import 'package:commoncents/pages/favourites.dart';
import 'package:commoncents/pages/myaccount.dart';
import 'package:commoncents/pages/leaderboard.dart';
import 'package:commoncents/pages/tradeHistory.dart';
import 'package:commoncents/pages/help_support.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';

import '../components/appbar.dart';
import '../components/navbar.dart';
import 'auth_pages/login.dart';
import 'faq.dart';

class ProfilePage extends StatefulWidget {
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String photoUrl = '';
  String displayName = '';
  double balance = 0.0;
  String email = '';
  late Map<String, dynamic> forTradeHisitory;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    forTradeHisitory = {};
    if (mounted) {
      loadData();
    }
  }

  Future<void> loadData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        forTradeHisitory = docSnapshot.data()!;
        if (data != null) {
          setState(() {
            photoUrl = data['photoURL'] ??
                user.photoURL ??
                ''; // Provide a default value if 'photoURL' is null
            displayName = data['displayName'] ??
                user.displayName ??
                'nope'; // Provide a default value if 'displayName' is null
            balance = data['balance']?.toDouble() ??
                0.0; // Provide a default value if 'balance' is null
            email = data['email'] ?? '';
          });
        }
      }
    }
  }

  Widget buildContainer({
    required String title,
    required Widget? icon,
    required VoidCallback onPressed,
    bool showBottomBorder = true,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 350,
        height: 80,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: showBottomBorder
              ? const Border(
                  bottom: BorderSide(
                    color: Colors.black,
                    width: 2.0,
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 20),
              height: icon == null ? 0 : 50,
              width: icon == null ? 0 : 50,
              color: Colors.transparent,
              child: icon,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title),
                  IconButton(
                    onPressed: onPressed,
                    icon: const Icon(Icons.arrow_forward_ios_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        appBar: const CustomAppBar(
            title: 'Profile',
            logo: "assets/images/commoncents-logo.png",
            isTradingPage: false),
        body: Center(
            child: Column(
          children: [
            Image.asset('assets/images/no-profile.jpg'),
            const Text(
              "You are not logged in.",
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Please "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginView()),
                    );
                  },
                  child: const Text(
                    "Log in ",
                    style: TextStyle(
                      color: Color(0XFF3366FF),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const Text("to view your profile")
              ],
            )
          ],
        )),
        bottomNavigationBar: const BottomNavBar(index: 4),
      );
    } else {
      return Scaffold(
        appBar: const CustomAppBar(
          title: "Profile",
          logo: "assets/images/commoncents-logo.png",
          isTradingPage: false,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Hero(
                        tag: 'test',
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: photoUrl.isNotEmpty
                                ? Image.network(photoUrl, fit: BoxFit.cover)
                                : Image.network(
                                    'https://www.seekpng.com/png/detail/966-9665493_my-profile-icon-blank-profile-image-circle.png',
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        height: 78,
                        width: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: const TextStyle(fontFamily: 'Roboto'),
                            ),
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                  child: Icon(FontAwesomeIcons.wallet,
                                    size: 13,
                                  ),
                                ),
                                Text(balance.toStringAsFixed(2),
                                    style: const TextStyle(fontFamily: "Roboto", fontWeight: FontWeight.bold),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text("USD",
                                    style: TextStyle(fontFamily: "Roboto", fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: SizedBox(
                                height: 30,
                                width: 130,
                                child: ElevatedButton(onPressed: () {
                                  
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(const Color(0xFF6699FF)),
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                  ))
                                ),
                                child: const Text("Reset balance",
                                  style: TextStyle(color: Colors.white, fontSize: 12
                                  ),
                                )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext logoutDialog) {
                                return const LogOut();
                              },
                            );
                          },
                          child: Transform.scale(
                            scale: 1.5, // Adjust the scale factor as needed
                            child: const Icon(Iconsax.logout,
                              size: 20,
                            ),
                          )),
                    ],
                  ),
                ),
                Container(
                  // width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          buildContainer(
                            title: "My Account",
                            icon: null,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyAccount(
                                            displayName: displayName,
                                            photoUrl: photoUrl,
                                            balance: balance,
                                            email: email,
                                          )));
                            },
                          ),
                          buildContainer(
                            title: "Favourites",
                            icon: null,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FavouritesPage()));
                            },
                          ),
                          buildContainer(
                            title: "Leaderboard",
                            icon: null,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Leaderboard()));
                            },
                          ),
                          buildContainer(
                            title: "Trade History",
                            icon: null,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TradeHistory()));
                            },
                          ),
                          buildContainer(
                            title: "Help and Support",
                            icon: null,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HelpSupport()));
                            },
                          ),
                          buildContainer(
                            title: "FAQs",
                            icon: null,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FAQ()));
                            },
                            showBottomBorder: false,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomNavBar(
          index: 4,
        ),
      );
    }
  }
}
