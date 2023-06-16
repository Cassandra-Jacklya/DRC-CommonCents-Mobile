import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key,required this.title});

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
                      fontFamily: 'Raleway',
                      fontSize: 35,
                      // fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(
              color: Colors.black,
              padding: const EdgeInsets.only(top: 10),
              iconSize: 45,
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                // Add your bell icon onPressed logic here
              },
            ),
          ],
          backgroundColor: Colors.grey[300],
          elevation: 0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
