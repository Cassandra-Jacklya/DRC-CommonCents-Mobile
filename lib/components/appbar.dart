import 'package:flutter/material.dart';
import '../pages/notifications.dart';
import 'package:iconsax/iconsax.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String logo;
  final bool hasBell;

  const CustomAppBar({super.key, required this.title, required this.logo, required this.hasBell});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: AppBar(
        automaticallyImplyLeading: logo == "" ? true : false,
        title: Row(
          children: [
            Padding(
              padding: logo == "" ? const EdgeInsets.all(0) : const EdgeInsets.fromLTRB(0, 10, 20, 0),
              child: logo != "" ? 
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(image: AssetImage(logo),
                  fit: BoxFit.cover
                  )
                ),
              )
              : Container()
            ),
            Padding(
              padding: logo == "" ? const EdgeInsets.fromLTRB(0, 0, 0, 0) : const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Text(title,
              style: const TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
        actions: [
          Visibility(
            visible: hasBell ? true : false,
            child: IconButton(
              color: Colors.white,
              padding: const EdgeInsets.only(top: 5, right: 20),
              iconSize: 25,
              icon: const Icon(Iconsax.notification),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationPage()),
                );
              },
            ),
          ),
        ],
        backgroundColor: const Color(0XFF3366FF),
        elevation: 0,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(65);
}
