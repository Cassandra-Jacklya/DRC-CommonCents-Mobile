import 'package:flutter/material.dart';
import '../components/shape.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Leaderboard extends StatefulWidget {
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  late List<Map<String, dynamic>> ranking = []; // Declare rankedUsers variable

  Future<List<Map<String, dynamic>>> rankUsersByBalance() async {
    List<Map<String, dynamic>> rankedUsers = [];
    print('Doing');

    // Retrieve all users from the Firestore collection
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    // Iterate through each document and retrieve balance field
    querySnapshot.docs.forEach((userDoc) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      String userId = userDoc.id;
      double balance = userData['balance'].toDouble();

      String? photo = userData['photoURL'];

      rankedUsers.add({'userId': userId, 'balance': balance, 'photo': photo});
    });

    // Sort the rankedUsers list in descending order based on balance
    rankedUsers.sort((a, b) => b['balance'].compareTo(a['balance']));

    return rankedUsers;
  }

  @override
  void initState() {
    super.initState();
    rankUsersByBalance().then((users) {
      setState(() {
        ranking = users;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (ranking.isNotEmpty) {
      // print(ranking[0]['photo']);
      return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          toolbarHeight: 60,
          backgroundColor: Colors.transparent,
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
                      child: CircleAvatar(
                        backgroundImage:
                            NetworkImage(ranking[0]['photo'] ?? ''),
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
                      child: CircleAvatar(
                        backgroundImage:
                            NetworkImage(ranking[1]['photo'] ?? ''),
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
                      child: CircleAvatar(
                        backgroundImage:
                            NetworkImage(ranking[2]['photo'] ?? ''),
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 40,
                      left: 60,
                      child: Transform.rotate(
                        angle: -20 * (3.1415926535897932 / 180),
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
                      child: Transform.rotate(
                        angle: 14 * (3.1415926535897932 / 180),
                        child: const MyShape(
                          number: 3,
                        ),
                      )),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: ranking.length > 3 ? ranking.length - 3 : 0,
                itemBuilder: (context, index) {
                  final number = index + 3;
                  return Container(
                    height: 75,
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          number.toString(),
                          style: const TextStyle(fontSize: 30),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                          ),
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(ranking[number]['photo'] ?? ''),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ranking[number]['displayName']?? 'Test',
                                style: const TextStyle(fontFamily: 'Roboto'),
                              ),
                              Text("${ranking[number]['balance'].toStringAsFixed(2)} USD",
                                  style: const TextStyle(fontFamily: "Roboto"))
                            ],
                          ),
                        ),
                      ],
                    ),
                  );

                  // return Container(
                  //   height: 75,
                  //   margin: const EdgeInsets.all(10),
                  //   child: Row(
                  //     children: [
                  //       Text(number.toString(),
                  //           style: const TextStyle(fontSize: 30)),

                  //       Container(
                  //         margin: const EdgeInsets.symmetric(horizontal: 10),
                  //         height: 60,
                  //         width: MediaQuery.of(context).size.width * 0.6,
                  //         color: Colors.grey[300],
                  //       ),
                  //     ],
                  //   ),
                  // );
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
