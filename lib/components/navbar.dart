import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/navbar_cubit.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    final bottomNavBarCubit = context.watch<BottomNavBarCubit>();
    final Size size = MediaQuery.of(context).size;

    return Container(
      height: 80,
      color: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            height: 80,
            width: size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      context.read<BottomNavBarCubit>().updatePageIndex(0);
                    });
                  },
                  child: BlocBuilder<BottomNavBarCubit, int>(
                    builder: (context, state) {
                      return Container(
                        margin: const EdgeInsets.only(top: 10, left: 8),
                        child: Column(
                          children: [
                            Icon(
                              Icons.home_outlined,
                              size: 40,
                              color: state == 0
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                            ),
                            Text(
                              "Home",
                              style: TextStyle(
                                  color: state == 0
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  width: 11,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      context.read<BottomNavBarCubit>().updatePageIndex(1);
                    });
                  },
                  child: BlocBuilder<BottomNavBarCubit, int>(
                    builder: (context, state) {
                      return Container(
                        margin: const EdgeInsets.only(top: 10, left: 8),
                        child: Column(
                          children: [
                            Icon(
                              Icons.search,
                              size: 40,
                              color: state == 1
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                            ),
                            Text(
                              "News",
                              style: TextStyle(
                                  color: state == 1
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: size.width * 0.25),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      context.read<BottomNavBarCubit>().updatePageIndex(3);
                    });
                  },
                  child: BlocBuilder<BottomNavBarCubit, int>(
                    builder: (context, state) {
                      return Container(
                        margin: const EdgeInsets.only(top: 10, left: 8),
                        child: Column(
                          children: [
                            Icon(
                              Icons.forum,
                              size: 40,
                              color: state == 3
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                            ),
                            Text(
                              "Forum",
                              style: TextStyle(
                                  color: state == 3
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      context.read<BottomNavBarCubit>().updatePageIndex(4);
                    });
                  },
                  child: BlocBuilder<BottomNavBarCubit, int>(
                    builder: (context, state) {
                      return Container(
                        margin: const EdgeInsets.only(top: 10, left: 8),
                        child: Column(
                          children: [
                            Icon(
                              Icons.person,
                              size: 40,
                              color: state == 4
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                            ),
                            Text(
                              "Profile",
                              style: TextStyle(
                                  color: state == 4
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 3, // Adjust the value to control the amount of overflow
            left: (size.width - 110) / 2, // Center the circle horizontally
            child: GestureDetector(
              onTap: () {
                setState(() {
                  context.read<BottomNavBarCubit>().updatePageIndex(2);
                });
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border:
                      Border.all(color: const Color(0xFFA4D8EF), width: 6.0),
                  shape: BoxShape.circle,
                  color: const Color(0xFF1956FC),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.trolley,
                      size: 40,
                      color: Colors.white,
                    ),
                    Text(
                      "Trade",
                      style: TextStyle(color: Colors.white),
                    )
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
