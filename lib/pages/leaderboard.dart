import 'package:flutter/material.dart';
import '../components/shape.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Leaderboard extends StatefulWidget {
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  late List<Map<String, dynamic>> ranking = []; // Declare rankedUsers variable

  Future<List<Map<String, dynamic>>> rankUsersByNetWorth() async {
    List<Map<String, dynamic>> rankedUsers = [];

    // Retrieve all users from the Firestore collection
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    // Iterate through each document and retrieve netWorth field
    await Future.forEach(querySnapshot.docs, (userDoc) async {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      String userId = userDoc.id;
      double netWorth = 0;

      // Retrieve the trade summary document for the user
      DocumentSnapshot tradeSummarySnapshot = await userDoc.reference
          .collection('tradeHistory')
          .doc('tradeSummary')
          .get();

      if (tradeSummarySnapshot.exists) {
        Map<String, dynamic>? tradeSummaryData =
            tradeSummarySnapshot.data() as Map<String, dynamic>?;

        netWorth = tradeSummaryData!['netWorth']?.toDouble() ?? 0;
      }

      String? photo = userData['photoURL'];

      rankedUsers.add({'userId': userId, 'netWorth': netWorth, 'photo': photo});
    });

    // Sort the rankedUsers list in descending order based on netWorth
    rankedUsers.sort((a, b) => b['netWorth'].compareTo(a['netWorth']));

    return rankedUsers;
  }

  @override
  void initState() {
    super.initState();
    rankUsersByNetWorth().then((users) {
      setState(() {
        ranking = users;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (ranking.isNotEmpty) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          toolbarHeight: 60,
          backgroundColor: Color(0XFF3366FF),
          title: const Text(
            "Leaderboard",
            style: TextStyle(color: Colors.white),
          ),
          foregroundColor: Colors.black,
        ),
        body: Column(
          children: [
            Stack(
              children: [
                Image.asset('assets/images/leaderboard.png'),
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  color: Colors.transparent,
                  child: Stack(
                    children: [
                      Positioned(
                        top: screenHeight * 0.029,
                        right: screenWidth * 0.375,
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[500],
                          ),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                NetworkImage(ranking[0]['photo'] ?? ''),
                          ),
                        ),
                      ),
                      Positioned(
                        top: screenHeight * 0.082,
                        right: screenWidth * 0.068,
                        child: Container(
                          width: 90,
                          height: 90,
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
                        top: screenHeight * 0.082,
                        left: screenWidth * 0.067,
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[500],
                          ),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                NetworkImage(ranking[2]['photo'] ?? ''),
                          ),
                        ),
                      ),
                      Center(child: Image.asset('assets/videos/confetti.gif')),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: ranking.length > 3 ? ranking.length - 3 : 0,
                itemBuilder: (context, index) {
                  final number = index + 3;
                  ranking[number]['displayName'];
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
                                ranking[number]['displayName'] ?? 'Anonymous',
                                style: const TextStyle(fontFamily: 'Roboto'),
                              ),
                              // Text(
                              //     "${ranking[number]['balance'].toStringAsFixed(2)} USD",
                              //     style: const TextStyle(fontFamily: "Roboto"))
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
