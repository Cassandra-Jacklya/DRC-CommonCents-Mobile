import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.grey[300],
        automaticallyImplyLeading: false,
        title: Text("Notification", style: Theme.of(context).textTheme.displayLarge),
        actions: [
          IconButton(color: Colors.grey,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Iconsax.close_circle),
          ),
        ],
      ),
      body: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [Text("Notification Page")]),
      ),
    );
  }
}
