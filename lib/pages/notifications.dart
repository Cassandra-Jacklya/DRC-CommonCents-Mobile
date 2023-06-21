import 'package:flutter/material.dart';
import '../components/NotificationPageType.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          shadowColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Text(
            "Notification",
            style: Theme.of(context).textTheme.displayLarge,
          ),
          actions: [
            IconButton(
              color: Colors.grey,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Iconsax.close_circle),
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AnimatedButton(
                  onPress: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                  isSelected: selectedIndex == 0,
                  height: 50,
                  width: 180,
                  text: 'Unread Messages',
                  isReverse: false,
                  selectedTextColor: Colors.black,
                  selectedBackgroundColor: Colors.greenAccent,
                  transitionType: TransitionType.BOTTOM_CENTER_ROUNDER,
                  textStyle: const TextStyle(color: Colors.black),
                  backgroundColor: Colors.grey,
                  borderColor: Colors.white,
                  borderRadius: 50,
                  borderWidth: 2,
                ),
                AnimatedButton(
                  onPress: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                  isSelected: selectedIndex == 1,
                  height: 50,
                  width: 180,
                  text: 'All Messages',
                  isReverse: false,
                  selectedTextColor: Colors.black,
                  selectedBackgroundColor: Colors.greenAccent,
                  transitionType: TransitionType.BOTTOM_CENTER_ROUNDER,
                  textStyle: const TextStyle(color: Colors.black),
                  backgroundColor: Colors.grey,
                  borderColor: Colors.white,
                  borderRadius: 50,
                  borderWidth: 2,
                ),
              ],
            ),
            Column(
              children: [
                const SizedBox(height: 20),
                if (selectedIndex == 1) ...[
                  const AllMessages(),
                ] else if (selectedIndex == 0) ...[
                  const UnreadMessages(),
                ],
              ],
            )
          ],
        ));
  }
}
