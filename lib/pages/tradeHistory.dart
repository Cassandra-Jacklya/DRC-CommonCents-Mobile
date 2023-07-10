import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commoncents/components/formatMarkets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/popup.dart';

class TradeHistory extends StatefulWidget {
  _TradeHistoryState createState() => _TradeHistoryState();
}

class _TradeHistoryState extends State<TradeHistory> {
  List<Map<String, dynamic>> tradeDataList = [];

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

        for (final tradeDoc in tradeHistoryDocs) {
          final tradeData = tradeDoc.data() as Map<String, dynamic>;
          tradeDataList.add(tradeData);
        }
        return tradeDataList;
      }
    } else {
      return tradeDataList;
    }
  }

  @override
  void initState() {
    super.initState();
    loadTradeHistory().then((result) {
      setState(() {
        tradeDataList = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (tradeDataList.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          toolbarHeight: 60,
          backgroundColor: Color(0XFF3366FF),
          title: const Text(
            "Recent Trades",
            style: TextStyle(color: Colors.white),
          ),
          foregroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Container(margin: const EdgeInsets.only(bottom: 20),
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
                        builder: (BuildContext context) {
                          return TradeDetails(
                            status: trade['status'],
                            entry: trade['previousSpot'],
                            exit: trade['currentSpot'],
                            pNl: trade['status'] == 'Win' ? trade['additionalAmount'].toDouble() : trade['askPrice'].toDouble(),
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
                      margin: const EdgeInsets.only(top: 30, left: 10, right: 10),
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  reverseMarkets(trade['marketType']),
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "${trade['status'] == 'Win' ? '+${trade['additionalAmount']}' : '-${trade['askPrice']}'}  USD",
                                  style: const TextStyle(fontSize: 15),
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
        ),
      );
    } else {
      return Container();
    }
  }
}
