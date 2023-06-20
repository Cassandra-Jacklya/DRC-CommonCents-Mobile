import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class Citizenship extends StatelessWidget {
  const Citizenship({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        automaticallyImplyLeading: false,
        title: Text(
          "Choose Citizenship",
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
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Pass the selected citizenship string back to the previous screen
              Navigator.pop(context, "Malaysia");
            },
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 70,
                    color: Colors.grey[500],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          height: 20,
                          width: 20,
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.black)),
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                        const Text("Malaysia"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

