import 'package:flutter/material.dart';
import '../components/shape.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        toolbarHeight: 60,
        backgroundColor: Colors.grey[300],
        title: const Text("Leaderboard"),
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            color: Colors.grey[300],
            child: Stack(
              children: [
                Positioned(
                  top: 5,
                  right: 135,
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  right: 10,
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                Positioned(
                  top: 70,
                  left: 10,
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                Positioned(
                    bottom: 40,
                    left: 60,
                    child: Transform.rotate( angle:  -20 * (3.1415926535897932 / 180),
                      child: const MyShape(
                        number: 2,
                      ),
                    )),
                const Positioned(
                    top: 115,
                    left: 163,
                    child: MyShape(
                      number: 1,
                    )),
                Positioned(
                    bottom: 30,
                    right: 50,
                    child: Transform.rotate(angle: 14 * (3.1415926535897932 / 180),
                      child: const MyShape(
                        number: 3,
                      ),
                    )),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                final number = index + 4;

                return Container(
                  height: 75,
                  margin: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Text(number.toString(),
                          style: const TextStyle(fontSize: 30)),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.6,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


// Future<List<Map<String, dynamic>>> rankUsersByBalance() async {
//   List<Map<String, dynamic>> rankedUsers = [];

//   // Retrieve all users from the Firestore collection
//   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//       .collection('users')
//       .get();

//   // Iterate through each document and retrieve balance field
//   querySnapshot.docs.forEach((userDoc) {
//     Object? userData = userDoc.data();
//     String userId = userDoc.id;
//     int balance = userData!['balance'] as int;

//     rankedUsers.add({
//       'userId': userId,
//       'balance': balance,
//     });
//   });

//   // Sort the rankedUsers list in descending order based on balance
//   rankedUsers.sort((a, b) => b['balance'].compareTo(a['balance']));

//   return rankedUsers;
// }

