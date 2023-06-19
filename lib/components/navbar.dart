import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
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
                              Iconsax.home_2,
                              size: 40,
                              color: state == 0
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                            ),
                            RichText(
                              text: TextSpan(
                                text: "Home",
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(
                                      color: state == 0
                                          ? Theme.of(context).primaryColor
                                          : Colors.black,
                                    ),
                              ),
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
                              Iconsax.search_normal_1,
                              size: 40,
                              color: state == 1
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                            ),
                            RichText(
                              text: TextSpan(
                                text: "News",
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(
                                      color: state == 1
                                          ? Theme.of(context).primaryColor
                                          : Colors.black,
                                    ),
                              ),
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
                              Iconsax.messages_2,
                              size: 40,
                              color: state == 3
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                            ),
                            RichText(
                              text: TextSpan(
                                text: "Forum",
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(
                                      color: state == 3
                                          ? Theme.of(context).primaryColor
                                          : Colors.black,
                                    ),
                              ),
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
                              Iconsax.profile_circle,
                              size: 40,
                              color: state == 4
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                            ),
                            RichText(
                              text: TextSpan(
                                text: "Profile",
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(
                                      color: state == 4
                                          ? Theme.of(context).primaryColor
                                          : Colors.black,
                                    ),
                              ),
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
                  border: Border.all(
                      color: Theme.of(context).primaryColorLight, width: 6.0),
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    const Icon(
                      Iconsax.status_up,
                      size: 40,
                      color: Colors.white,
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Trade",
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: Colors.white,
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
