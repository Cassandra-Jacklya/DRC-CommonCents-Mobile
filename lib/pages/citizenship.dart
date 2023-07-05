import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class Citizenship extends StatelessWidget {
  const Citizenship({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF3366FF),
        automaticallyImplyLeading: false,
        title: Text(
          "Choose Citizenship",
          style: TextStyle(fontSize:Theme.of(context).textTheme.displayLarge!.fontSize ,color: Colors.white)
        ),
        actions: [
          IconButton(
            color: Colors.grey,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const SizedBox(height: 80, width: 80, child: Icon(Iconsax.close_circle)),
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
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          height: 20,
                          width: 20,
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(width: 2,color: Colors.black)),
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

