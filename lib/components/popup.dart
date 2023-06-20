import 'package:flutter/material.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      titlePadding: EdgeInsets.zero,
      title: Container(
        height: 60,
        decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Account Settings',
              style: Theme.of(context).textTheme.displayLarge!.merge(
                    const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
            ),
          ],
        ),
      ),
      content: Container(padding: const EdgeInsets.only(top: 10),
        child: const Align(
          heightFactor: 0.9,
          alignment: Alignment.centerLeft,
          child: Text(
            'Are you sure you want to change your details?',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(child: Text("Cancel")),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(child: Text("Yes")),
            ),
          ),
        ),
      ],
    );
  }
}

class LogOut extends StatelessWidget {
  const LogOut({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      titlePadding: EdgeInsets.zero,
      title: Container(
        height: 60,
        decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Logout',
              style: Theme.of(context).textTheme.displayLarge!.merge(
                    const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
            ),
          ],
        ),
      ),
      content: Container(padding: const EdgeInsets.only(top: 10),
        child: const Align(
          heightFactor: 0.9,
          alignment: Alignment.centerLeft,
          child: Text(
            'Are you sure you want to log out?',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(child: Text("Cancel")),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(child: Text("Yes")),
            ),
          ),
        ),
      ],
    );
  }
}