import 'package:commoncents/pages/forumpage.dart';
import 'package:commoncents/pages/homepage.dart';
import 'package:commoncents/pages/newspage.dart';
import 'package:commoncents/pages/profilepage.dart';
import 'package:commoncents/pages/simulationpage.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key, required this.index});

  final int index;

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            pageBuilder: (context, anim1, anim2) => const HomePage(),
            transitionDuration: Duration.zero),
      );
        break;
      case 1:
        Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            pageBuilder: (context, anim1, anim2) => const NewsPage(),
            transitionDuration: Duration.zero),
      );
        break;
      case 2:
        Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            pageBuilder: (context, anim1, anim2) => const SimulationPage(),
            transitionDuration: Duration.zero),
      );
        break;
      case 3: 
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (context, anim1, anim2) => const ForumPage(),
              transitionDuration: Duration.zero),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (context, anim1, anim2) => ProfilePage(),
              transitionDuration: Duration.zero),
        );
      break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    // final bottomNavBarCubit = context.watch<BottomNavBarCubit>();
    final Size size = MediaQuery.of(context).size;

    return Container(
      height: 70,
      color: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(
                  color: Colors.black87,
                  spreadRadius: 1.5
                ),
                ],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),     
            height: 70,
            width: size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    _onItemTapped(0);
                  },
                  child: Container(
                        margin: const EdgeInsets.only(top: 10, left: 8),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: Icon(
                                Iconsax.home_2,
                                size: 25,
                                color: widget.index == 0
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: RichText(
                                text: const TextSpan(
                                  text: "Home",
                                  style: TextStyle(fontSize: 10, color: Colors.black)
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                ),
                const SizedBox(
                  width: 11,
                ),
                GestureDetector(
                  onTap: () {
                    _onItemTapped(1);
                  },
                  child: Container(
                        margin: const EdgeInsets.only(top: 10, left: 8),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: Icon(
                                Iconsax.search_normal_1,
                                size: 25,
                                color: widget.index == 1
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: RichText(
                                text: const TextSpan(
                                  text: "News",
                                  style: TextStyle(fontSize: 10, color: Colors.black)
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                ),
                SizedBox(width: size.width * 0.25),
                GestureDetector(
                  onTap: () {
                    _onItemTapped(3);
                  },
                  child: Container(
                        margin: const EdgeInsets.only(top: 10, left: 8),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: Icon(
                                Iconsax.messages_2,
                                size: 25,
                                color: widget.index == 3
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: RichText(
                                text: const TextSpan(
                                  text: "Forum",
                                  style: TextStyle(fontSize: 10, color: Colors.black)
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                ),
                const SizedBox(
                  width: 16,
                ),
                GestureDetector(
                  onTap: () {
                    _onItemTapped(4);
                  },
                  child: Container(
                        margin: const EdgeInsets.only(top: 10, left: 8),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: Icon(
                                Iconsax.profile_circle,
                                size: 25,
                                color: widget.index == 4
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: RichText(
                                text: const TextSpan(
                                  text: "Profile",
                                  style: TextStyle(fontSize: 10, color: Colors.black)
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 15, // Adjust the value to control the amount of overflow
            left: (size.width - 80) / 2, // Center the circle horizontally
            child: GestureDetector(
              onTap: () {
                _onItemTapped(2);
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).primaryColorLight, width: 6.0),
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Icon(
                        Iconsax.status_up,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: RichText(
                        text: const TextSpan(
                          text: "Trade",
                          style: TextStyle(fontSize: 10, color: Colors.white)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
