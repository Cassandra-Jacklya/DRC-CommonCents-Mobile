import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commoncents/components/popup.dart';
import 'package:commoncents/pages/myaccount.dart';
import 'package:commoncents/pages/security.dart';
import 'package:commoncents/pages/leaderboard.dart';
import 'package:commoncents/pages/recentTrades.dart';
import 'package:commoncents/pages/help_support.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../components/appbar.dart';
import '../components/navbar.dart';

class ProfilePage extends StatefulWidget {
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String photoUrl = ''; // Initialize with an empty string
  String displayName = ''; // Initialize with an empty string
  double balance = 0.0; // Initialize with 0.0
  String email = '';

  @override
  void initState() {
    super.initState();
    loadData();
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
        if (data != null) {
          setState(() {
            photoUrl = data['photoURL'] ?? ''; // Get the photoURL if it exists
            displayName = data['displayName'] ??
                'nope'; // Get the displayName if it exists
            balance = data['balance'].toDouble() ?? 0.0; // Get the balance if it exists
            email = data['email'];
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
    // FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    // User? user = FirebaseAuth.instance.currentUser;
    // CollectionReference collectionReference =
    //     firebaseFirestore.collection('users');

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Profile",
        logo: "assets/images/commoncents-logo.png",
        hasBell: true,
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                  'https://static01.nyt.com/newsgraphics/2019/08/01/candidate-pages/3b31eab6a3fd70444f76f133924ae4317567b2b5/trump-circle.png',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      height: 70,
                      width: 250,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: const TextStyle(fontFamily: 'Roboto'),
                          ),
                          Text(balance.toStringAsFixed(2),
                              style: const TextStyle(fontFamily: "Roboto"))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
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
                                    builder: (context) => MyAccount(displayName: displayName,photoUrl: photoUrl,balance: balance,email: email ,)));
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
                                    builder: (context) => Leaderboard()));
                          },
                        ),
                        buildContainer(
                          title: "Help and Support",
                          icon: null,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RecentTrades()));
                          },
                        ),
                        buildContainer(
                          title: "FAQs",
                          icon:null,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HelpSupport()));
                          },
                          showBottomBorder: false,
                        ),
                        GestureDetector(onTap: (){                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const LogOut();
                              },
                            );},
                          child: Container(padding: const EdgeInsets.all(15), height: MediaQuery.of(context).size.height*0.07,width: MediaQuery.of(context).size.width*0.9,decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Color(0XFF3366FF)),
                            child: Row(children:  [
                              Icon(color: Colors.white, Iconsax.logout),
                              SizedBox(width: MediaQuery.of(context).size.width*0.3),
                              Text("Logout", style: TextStyle(fontSize:18, color: Colors.white),)
                            ],
                        
                            ),
                          ),
                        )
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
