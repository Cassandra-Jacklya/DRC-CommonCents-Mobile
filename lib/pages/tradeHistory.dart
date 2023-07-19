import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commoncents/components/formatMarkets.dart';
import 'package:commoncents/pages/simulationpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/popup.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'auth_pages/login.dart';

class TradeHistory extends StatefulWidget {
  _TradeHistoryState createState() => _TradeHistoryState();
}

class _TradeHistoryState extends State<TradeHistory> {
  bool showAllTradeHistories = true;

  List<Map<String, dynamic>> tradeDataList = [];
  late Future<List<Map<String, dynamic>>> _tradesFuture;
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<List<Map<String, dynamic>>> loadTradeHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      //load all history
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
          final aTimestamp = (a.data())['timestamp'];
          final bTimestamp = (b.data())['timestamp'];
          return bTimestamp.compareTo(aTimestamp);
        });

        tradeDataList = tradeHistoryDocs.map((doc) => doc.data()).toList();
        
        if (showAllTradeHistories) {
          return tradeDataList;
        } else {
          if (selectedDate != null) {
            tradeDataList = tradeDataList
                .where((doc) =>
                    DateTime.fromMicrosecondsSinceEpoch(doc['timestamp'] * 1000)
                        .toLocal()
                        .day ==
                    selectedDate!.day)
                .toList();
          }
          return tradeDataList;
        }
      }
    } else {
      return tradeDataList;
    }
  }

  @override
  void initState() {
    super.initState();
    _tradesFuture = loadTradeHistory();
    selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return Scaffold(
          appBar: AppBar(
            shadowColor: Colors.transparent,
            toolbarHeight: 60,
            backgroundColor: const Color(0XFF3366FF),
            title: const Text(
              "Trade History",
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              PopupMenuButton(
                onSelected: (value) {
                  setState(() {
                    showAllTradeHistories = value == 'all';
                  });
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'all',
                    child: Text('Show All Trade Histories'),
                  ),
                  const PopupMenuItem(
                    value: 'filter',
                    child: Text('Filter Trade Histories by Date'),
                  ),
                ],
              ),
            ],
            foregroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Column(
            children: [
              showAllTradeHistories == false
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _selectDate(context);
                        },
                        child: Text(selectedDate == null
                            ? "Select Date"
                            : "Selected Date: ${DateFormat.yMd().format(selectedDate!)}"),
                      ),
                    )
                  : Container(),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _tradesFuture,
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else if (snapshot.hasData) {
                        tradeDataList = snapshot.data!;
                        if (tradeDataList.isEmpty) {
                          return Scaffold(
                            backgroundColor: Colors.white,
                            body: Column(
                              children: [
                                Image.asset(
                                    "assets/images/no-trade-history.jpg"),
                                Column(
                                  children: [
                                    const Text(
                                      "You have not bought any trades.",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Start ",
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 17),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushReplacement(
                                                context,
                                                PageRouteBuilder(
                                                    pageBuilder: (context,
                                                            anim1, anim2) =>
                                                        const SimulationPage(
                                                          market:
                                                              "Volatility 50",
                                                        ),
                                                    transitionDuration:
                                                        Duration.zero),
                                              );
                                            },
                                            child: const Text(
                                              "trading ",
                                              style: TextStyle(
                                                  color: Color(0xFF3366FF),
                                                  fontFamily: 'Roboto',
                                                  fontSize: 17,
                                                  decoration:
                                                      TextDecoration.underline),
                                            ),
                                          ),
                                          const Text(
                                            "now!",
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 17),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        } else {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: ListView(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: tradeDataList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
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
                                                  ? trade['additionalAmount']
                                                      .toDouble()
                                                  : trade['askPrice']
                                                      .toDouble(),
                                              marketType: trade['marketType'],
                                              duration: trade['tickDuration'],
                                              basis: trade['basis'],
                                              buyPrice:
                                                  trade['askPrice'].toDouble(),
                                              payout: trade['payoutValue']
                                                  .toDouble(),
                                              strategy: trade['strategy'],
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        margin: const EdgeInsets.only(
                                            top: 30, left: 10, right: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Colors.black26),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: const Offset(0, 3),
                                              ),
                                            ]),
                                        height: 120,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  right: 10),
                                              height: 80,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Image.asset(
                                                'assets/images/market/${trade['marketType']}.png',
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    reverseMarkets(
                                                        trade['marketType']),
                                                    style: const TextStyle(
                                                        fontSize: 18),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  // var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Profit/Loss:  ",
                                                        style: TextStyle(
                                                            color: trade[
                                                                        'status'] ==
                                                                    'Won'
                                                                ? Colors
                                                                    .greenAccent
                                                                : Colors
                                                                    .redAccent),
                                                      ),
                                                      Text(
                                                        "${trade['status'] == 'Won' ? '+${trade['additionalAmount'].toStringAsFixed(2)}' : '-${trade['askPrice'].toStringAsFixed(2)}'} USD",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: trade[
                                                                        'status'] ==
                                                                    'Won'
                                                                ? Colors
                                                                    .greenAccent
                                                                : Colors
                                                                    .redAccent),
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                    child: Row(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              DateFormat.d()
                                                                  .format(DateTime
                                                                      .fromMicrosecondsSinceEpoch(
                                                                          trade['timestamp'] *
                                                                              1000))
                                                                  .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          13),
                                                            ),
                                                            const Text("/"),
                                                            Text(
                                                              DateFormat.M()
                                                                  .format(DateTime
                                                                      .fromMicrosecondsSinceEpoch(
                                                                          trade['timestamp'] *
                                                                              1000))
                                                                  .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          13),
                                                            ),
                                                            const Text("/"),
                                                            Text(
                                                              DateFormat.y()
                                                                  .format(DateTime
                                                                      .fromMicrosecondsSinceEpoch(
                                                                          trade['timestamp'] *
                                                                              1000))
                                                                  .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          13),
                                                            ),
                                                            const Text(", ")
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 5),
                                                          child: Text(
                                                            DateFormat.jms()
                                                                .format(DateTime
                                                                    .fromMicrosecondsSinceEpoch(
                                                                        trade['timestamp'] *
                                                                            1000))
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        13),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
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
                        }
                      } else {
                        return const CircularProgressIndicator();
                      }
                    })),
              )
            ],
          ));
    } else {
      return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          toolbarHeight: 60,
          backgroundColor: const Color(0XFF3366FF),
          title: const Text(
            "Trade History",
            style: TextStyle(color: Colors.white),
          ),
          foregroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: Column(
            children: [
              Image.asset("assets/images/no-trade-history.jpg"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Log in",
                    style: TextStyle(color: Color(0xFF3366FF), fontSize: 17),
                  ),
                  Text(" to view your trade history.")
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}
