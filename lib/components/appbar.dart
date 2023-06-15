import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        child: AppBar(
          title: Container(
            margin: const EdgeInsets.only(top: 15),
            child: const Text(
              'COMMONCENTS',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1956FC),
              ),
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFFF0F8FF),
          elevation: 0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}


