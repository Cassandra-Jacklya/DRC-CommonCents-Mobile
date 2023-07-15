import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commoncents/components/formatMarkets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/popup.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'auth_pages/login.dart';

class TradeHistory extends StatefulWidget {
  _TradeHistoryState createState() => _TradeHistoryState();
}

class _TradeHistoryState extends State<TradeHistory> {
  List<Map<String, dynamic>> tradeDataList = [];
  late Future<List<Map<String, dynamic>>> _tradesFuture;

  Future<List<Map<String, dynamic>>> loadTradeHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('tradeHistory')
          .get();

      if (docSnapshot.docs.length == 1) {
        print("Haven't started trading");
        return tradeDataList;
      } else {
        final tradeHistoryDocs =
            docSnapshot.docs.where((doc) => doc.id != 'tradeSummary').toList();

        tradeHistoryDocs.sort((a, b) {
          final aTimestamp = (a.data() as Map<String, dynamic>)['timestamp'];
          final bTimestamp = (b.data() as Map<String, dynamic>)['timestamp'];
          return bTimestamp.compareTo(aTimestamp);
        });

        tradeDataList = tradeHistoryDocs.map((doc) => doc.data()).toList();
        return tradeDataList;
      }
    } else {
      return tradeDataList;
    }
  }

  @override
  void initState() {
    super.initState();
    _tradesFuture = loadTradeHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          toolbarHeight: 60,
          backgroundColor: const Color(0XFF3366FF),
          title: const Text(
            "Recent Trades",
            style: TextStyle(color: Colors.white),
          ),
          foregroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
            future: _tradesFuture,
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (snapshot.hasData) {
                tradeDataList = snapshot.data!;
                print(tradeDataList);
                if (tradeDataList.isNotEmpty) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: ListView(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: tradeDataList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final trade = tradeDataList[index];
                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext tradeDialog) {
                                    return TradeDetails(
                                      status: trade['status'],
                                      entry: trade['previousSpot'],
                                      exit: trade['currentSpot'],
                                      pNl: trade['status'] == 'Won'
                                          ? trade['additionalAmount'].toDouble()
                                          : trade['askPrice'].toDouble(),
                                      marketType: trade['marketType'],
                                      duration: trade['tickDuration'],
                                      basis: trade['basis'],
                                      buyPrice: trade['askPrice'].toDouble(),
                                      payout: trade['payoutValue'].toDouble(),
                                      strategy: trade['strategy'],
                                    );
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                margin: const EdgeInsets.only(
                                    top: 30, left: 10, right: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black26),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]),
                                height: 110,
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Image.asset(
                                        'assets/images/market/${trade['marketType']}.png',
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            reverseMarkets(trade['marketType']),
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "${trade['status'] == 'Won' ? '+${trade['additionalAmount']}' : '-${trade['askPrice']}'}  USD",
                                            style:
                                                const TextStyle(fontSize: 15),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                      child: Column(
                    children: [
                      Image.asset('assets/images/no-profile.jpg'),
                      const Text(
                        "You are not logged in.",
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Please "),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginView()),
                              );
                            },
                            child: const Text(
                              "Log in ",
                              style: TextStyle(
                                color: Color(0XFF3366FF),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const Text("to view your profile")
                        ],
                      )
                    ],
                  ));
                }
              } else {
                return const Text('Havent Start Trading yet.');
              }
            })));
  }
}
