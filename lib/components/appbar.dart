import 'package:flutter/material.dart';
import '../pages/notifications.dart';
import 'package:iconsax/iconsax.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
              child: Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(image: AssetImage("assets/images/commoncents-logo.png"),
                  fit: BoxFit.cover
                  )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Text(title,
              style: const TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
        actions: [
          IconButton(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 10, right: 20),
            iconSize: 25,
            icon: const Icon(Iconsax.notification),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationPage()),
              );
            },
          ),
        ],
        backgroundColor: const Color(0XFF3366FF),
        shape: const ContinuousRectangleBorder(side: BorderSide.none,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0)
        )),
        elevation: 0,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
