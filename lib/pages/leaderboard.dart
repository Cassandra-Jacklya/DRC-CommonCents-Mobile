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
      String userId = userData['displayName'] ?? userData['email'];
      double netWorth = 0.00;

      // Retrieve the trade summary document for the user
      DocumentSnapshot tradeSummarySnapshot = await userDoc.reference
          .collection('tradeHistory')
          .doc('tradeSummary')
          .get();

      if (tradeSummarySnapshot.exists) {
        Map<String, dynamic>? tradeSummaryData =
            tradeSummarySnapshot.data() as Map<String, dynamic>?;

        netWorth = tradeSummaryData!['netWorth']?.toDouble() ?? 0.00;
      }

      String? photo = userData['photoURL'] ?? 'https://www.seekpng.com/png/detail/966-9665493_my-profile-icon-blank-profile-image-circle.png';

      rankedUsers.add({'userId': userId, 'netWorth': netWorth, 'photo': photo,});
    });

    // Sort the rankedUsers list in descending order based on netWorth
    if (rankedUsers != []) {
      rankedUsers.sort((a, b) => b['netWorth'].compareTo(a['netWorth']));
    }
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
      return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          toolbarHeight: 60,
          backgroundColor: const Color(0XFF3366FF),
          title: const Text(
            "Leaderboard",
            style: TextStyle(color: Colors.white),
          ),
          foregroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Stack(
              children: [
                // Positioned(
                //   top: 100,
                //   left: 0,
                //   child: Image.asset('assets/images/Ellipse 20.png', 
                //   scale: 0.9,),
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Image.asset('assets/images/leaderboard.png'),
                ),
                Container(
                  // height: MediaQuery.of(context).size.height * 0.4,
                  height: 300,
                  color: Colors.transparent,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 53,
                        right: 147,
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
                                NetworkImage(ranking[0]['photo'] ?? "https://www.seekpng.com/png/detail/966-9665493_my-profile-icon-blank-profile-image-circle.png"),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 130,
                        left: 175,
                        child: CircleAvatar(
                        backgroundColor: Color(0xFFd4af37),
                        child: Text("1", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      )),
                      Positioned(
                        top: 215,
                        left: 145,
                        child: Container(
                          width: 100,
                          child: Center(child: Text(ranking[0]['userId'], overflow: TextOverflow.ellipsis)))),
                      Positioned(
                        top: 95,
                        right: 28,
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[500],
                          ),
                          child: ranking.length < 2 
                          ? const CircleAvatar(
                            backgroundColor: Color(0xFFD9D9D9))
                          : CircleAvatar(
                            backgroundImage:
                                NetworkImage(ranking[1]['photo'] ?? "https://www.seekpng.com/png/detail/966-9665493_my-profile-icon-blank-profile-image-circle.png"),
                          )
                          ,
                        ),
                      ),
                      
                      Positioned(
                        top: 260,
                        left: 23,
                        child: Container(
                          width: 100,
                          child: Center(child: Text(ranking[1]['userId'], overflow: TextOverflow.ellipsis)))
                      ),
                      
                      Positioned(
                        top: 95,
                        left: 28,
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[500],
                          ),
                          child: ranking.length < 3
                          ? const CircleAvatar(
                            backgroundColor: Color(0xFFD9D9D9),
                          )
                          : CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                NetworkImage(ranking[2]['photo'] ?? "https://www.seekpng.com/png/detail/966-9665493_my-profile-icon-blank-profile-image-circle.png"),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 170,
                        left: 55,
                        child: CircleAvatar(
                        backgroundColor: Color(0xFFc0c0c0),
                        child: Text("2", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      )),
                      Positioned(
                        top: 260,
                        right: 20,
                        child: Container(
                          width: 100,
                          child: Center(child: Text(ranking[2]['userId'], overflow: TextOverflow.ellipsis,)))
                      ),
                      Positioned(
                        top: 170,
                        right: 50,
                        child: CircleAvatar(
                        backgroundColor: Color(0xFFcd7f32),
                        child: Text("3", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      )),
                      Positioned(
                        top: 240,
                        right: 128,
                        child: Container(
                          width: 100,
                          child: Container(
                            width: 100,
                            child: Row(
                              children: [
                                Text(ranking[0]['netWorth'].toStringAsFixed(2), style: TextStyle(fontSize: 14),),
                                const Text(" USD", style: TextStyle(fontSize: 14),)
                              ],
                            ),
                          ),
                        )
                      ),
                      Positioned(
                        top: 280,
                        left: 35,
                        child: Container(
                          width: 100,
                          child: Row(
                            children: [
                              Text(ranking[1]['netWorth'].toStringAsFixed(2), style: TextStyle(fontSize: 14),),
                              const Text(" USD", style: TextStyle(fontSize: 14),)
                            ],
                          ),
                        )
                      ),
                      Positioned(
                        top: 280,
                        right: 10,
                        child: Container(
                          width: 100,
                          child: Row(
                            children: [
                              Text(ranking[2]['netWorth'].toStringAsFixed(2), style: TextStyle(fontSize: 14),),
                              const Text(" USD", style: TextStyle(fontSize: 14),)
                            ],
                          ),
                        )
                      ),
                      Center(child: Image.asset('assets/videos/confetti.gif')),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Name"),
                  Text("Net Worth")
                ],
              ),
            ),
            ranking.length > 3 ? 
            Expanded(
              child: ListView.builder(
                itemCount: ranking.length > 3 ? ranking.length - 3 : 0,
                itemBuilder: (context, index) {       
                  final number = index + 3;
                  int currIndex = number + 1;       
                  return Container(
                    height: 64,
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF5D5D5D),),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFF5D5D5D),
                            blurRadius: 4,
                            offset: Offset(2, 3), // Shadow position
                          ),
                        ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              currIndex.toString(),
                              style: const TextStyle(fontSize: 17),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 15),
                              height: 60,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[300],
                              ),
                              child: CircleAvatar(
                                backgroundImage:
                                  NetworkImage(ranking[number]['photo'] ?? "https://www.seekpng.com/png/detail/966-9665493_my-profile-icon-blank-profile-image-circle.png",
                                ),
                                onBackgroundImageError: (exception, stackTrace) {
                                  const NetworkImage("https://www.seekpng.com/png/detail/966-9665493_my-profile-icon-blank-profile-image-circle.png");
                                },
                              ),
                            ),
                            Container(
                              width: 150,
                              child: Text(
                                ranking[number]['userId'] ?? '',
                                style: const TextStyle(fontFamily: 'Roboto', fontSize: 14, overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          ],
                        ),
                        
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Text(ranking[number]['netWorth'].toStringAsFixed(2)),
                                  const Text(" USD", style: TextStyle(fontSize: 14),)
                                ],
                              ),
                            ),
                          ],
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
            )
            : const Text("End of leaderboard")
            ,
          ],
        ),
      );
    } else {
      return SizedBox(
        height: 20,
        width: 20,
        child: Center(child: const CircularProgressIndicator()));
    }
  }
}
