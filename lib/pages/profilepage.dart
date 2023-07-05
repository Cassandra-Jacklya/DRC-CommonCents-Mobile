import 'package:commoncents/components/popup.dart';
import 'package:commoncents/pages/myaccount.dart';
import 'package:commoncents/pages/security.dart';
import 'package:commoncents/pages/leaderboard.dart';
import 'package:commoncents/pages/recentTrades.dart';
import 'package:commoncents/pages/help_support.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../components/appbar.dart';
import '../components/navbar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  Widget buildContainer({
    required String title,
    required Widget icon,
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
          color: Colors.grey[400],
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
              height: 50,
              width: 50,
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
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      height: 70,
                      width: 250,
                      color: Colors.grey[400],
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
                    const Text("GENERAL", style: TextStyle(fontSize: 20)),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        buildContainer(
                          title: "My Account",
                          icon: Container(
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context) => const MyAccount())
                            );
                          },
                        ),
                        buildContainer(
                          title: "Security",
                          icon: Container(
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Security())
                            );
                          },
                        ),
                        buildContainer(
                          title: "Leaderboard",
                          icon: Container(
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const Leaderboard()));
                          },
                        ),
                        buildContainer(
                          title: "Recent Trades",
                          icon: Container(
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const RecentTrades()));
                          },
                        ),
                        buildContainer(
                          title: "Help and Support",
                          icon: Container(
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpSupport()));
                          },
                          showBottomBorder: false,
                        ),
                        buildContainer(
                          title: "Logout",
                          icon: const Icon(Iconsax.logout),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const LogOut();
                                },
                            );
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
      bottomNavigationBar: const BottomNavBar(index: 4,),
    );
  }
}
