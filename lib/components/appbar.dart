import 'package:flutter/material.dart';
import '../pages/notifications.dart';
import 'package:iconsax/iconsax.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            // offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        child: AppBar(
          title: Container(
            margin: const EdgeInsets.only(
              top: 15,
            ),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: title,
                      style: const TextStyle(
                        fontSize: 20,
                      )),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(
              color: Colors.white,
              padding: const EdgeInsets.only(top: 10),
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
          elevation: 0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
