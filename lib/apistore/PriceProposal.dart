import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commoncents/components/contractSnackbar.dart';
import 'package:commoncents/cubit/login_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../apistore/stockdata.dart';

// ignore: non_constant_identifier_names
bool Highstrategy = false;

Future<void> handleBuy(BuildContext context, int ticks, String stakePayout,
    int currentAmount, String? strategy, String market) async {
  if (strategy == 'high') {
    Highstrategy = true;
  } else if (strategy == 'low') {
    Highstrategy = false;
  }

  final PriceProposalRequest = {
    "proposal": 1,
    "amount": currentAmount,
    "basis": stakePayout,
    "contract_type": "CALL",
    "currency": "USD",
    "duration": ticks,
    "duration_unit": "t",
    "symbol": market
  };
  socket?.sink.add(jsonEncode(PriceProposalRequest));

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  CollectionReference collectionReference =
      firebaseFirestore.collection('users');

  DocumentSnapshot userSnapshot =
      await collectionReference.doc(user!.uid).get();
  Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

  if (userData != null) {
    double balance = userData['balance'].toDouble() ?? 0.00;
    double updatedBalance = balance - currentAmount;
    await collectionReference.doc(user.uid).update({'balance': updatedBalance});
    context
        .read<LoginStateBloc>()
        .updateBalance(userData['email'], updatedBalance.toStringAsFixed(2));
  }
}

Future<double> getUpdatedBalance(String userId, double capital) async {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  CollectionReference collectionReference =
      firebaseFirestore.collection('users');

  DocumentSnapshot userSnapshot =
      await collectionReference.doc(user!.uid).get();
  Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

  if (userData != null) {
    double currentBalance = userData['balance'].toDouble() ?? 0.00;
    double updatedBalance = currentBalance - capital;
    await collectionReference.doc(user.uid).update({'balance': updatedBalance});
    return updatedBalance;
  }
  return 0;
}

void handleBuyResponse(
    BuildContext context, Map<String, dynamic> decodedData) async {
  late double buyingPrice;
  late double sellingPrice;
  late double capital;
  late double currentBalance;
  late double updatedBalance;
  late String tradeStatus;
  late int duration;
  final Map<String, dynamic> proposal = decodedData['proposal'];
  capital = decodedData['echo_req']['amount'].toDouble();
  duration = decodedData['echo_req']['duration'];

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference collectionReference =
      firebaseFirestore.collection('users');

  DocumentSnapshot userSnapshot =
      await collectionReference.doc(user!.uid).get();
  Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

  double balance = userData!['balance'].toDouble() ?? 0.00;

  buyingPrice = ticks.last['close'];
  await Future.delayed(Duration(seconds: duration));
  sellingPrice = ticks.last['close'];

  if (Highstrategy) {
    if (buyingPrice < sellingPrice) {
      //strategy = high
      updatedBalance = balance + proposal['payout'];
      collectionReference.doc(user.uid).update({'balance': updatedBalance});
      final loginStateBloc = BlocProvider.of<LoginStateBloc>(
          context as BuildContext,
          listen: false);
      loginStateBloc.updateBalance(
          userData['email'], updatedBalance.toStringAsFixed(2));
      tradeStatus = "Won";
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(backgroundColor: Color.fromARGB(255, 218, 255, 178),
            title: Text("Hooray!"),
            content: Text("You have won the trade!\nProfit: ${proposal['payout'].toStringAsFixed(2)} USD"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      tradeStatus = "Lost";
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(backgroundColor: Color.fromARGB(255, 255, 201, 197),
            title: Text("Oh No!"),
            content: Text("You have lost the trade!\nLost: ${capital.toStringAsFixed(2)} USD"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  } else {
    if (buyingPrice > sellingPrice) {
      //strategy = low
      updatedBalance = balance + proposal['payout'];
      collectionReference.doc(user.uid).update({'balance': updatedBalance});
      final loginStateBloc = BlocProvider.of<LoginStateBloc>(
          context as BuildContext,
          listen: false);
      loginStateBloc.updateBalance(
          userData['email'], updatedBalance.toStringAsFixed(2));
      tradeStatus = "Won";
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(backgroundColor: Color.fromARGB(255, 218, 255, 178),
            title: Text("Hooray!"),
            content: Text("You have won the trade!\nProfit: ${proposal['payout'].toStringAsFixed(2)} USD"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      tradeStatus = "Lost";
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(backgroundColor: Color.fromARGB(255, 255, 201, 197),
            title: Text("Oh No!"),
            content: Text("You have lost the trade!\nLost: ${capital.toStringAsFixed(2)} USD"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  CollectionReference tradeHistoryCollection =
      collectionReference.doc(user.uid).collection('tradeHistory');
  DocumentReference tradeDocRef = tradeHistoryCollection.doc();
  Map<String, dynamic> tradeData = {
    'additionalAmount': proposal['payout'],
    'askPrice': capital,
    'basis': decodedData['echo_req']['basis'],
    'currentSpot': sellingPrice,
    'marketType': decodedData['echo_req']['symbol'],
    'payoutValue': capital,
    'previousSpot': buyingPrice,
    'status': tradeStatus,
    'strategy': Highstrategy ? "Higher" : "Lower",
    'tickDuration': duration,
    'timestamp': DateTime.now().millisecondsSinceEpoch
  };
  await tradeDocRef.set(tradeData);

  DocumentReference tradeSummaryDocRef =
      tradeHistoryCollection.doc('tradeSummary');
  tradeSummaryDocRef.get().then((tradeSummarySnapshot) {
    if (tradeSummarySnapshot.exists) {
      Map<String, dynamic>? tradeSummaryData =
          tradeSummarySnapshot.data() as Map<String, dynamic>?;

      double totalProfit =
          (tradeSummaryData!['totalProfit'] as num?)?.toDouble() ?? 0;
      double totalLoss =
          (tradeSummaryData['totalLoss'] as num?)?.toDouble() ?? 0;

      if (tradeStatus == 'Won') {
        totalProfit += proposal['payout'];
      } else if (tradeStatus == 'Lost') {
        totalLoss += capital * -1;
      }

      double netWorth = totalProfit + totalLoss;

      tradeSummaryDocRef.update({
        'totalProfit': totalProfit,
        'totalLoss': totalLoss,
        'netWorth': netWorth,
        'timestamp': DateTime.now().millisecondsSinceEpoch
      });
    } else {
      tradeSummaryDocRef.set({
        'totalProfit': tradeStatus == 'Won' ? proposal['payout'] : 0,
        'totalLoss': tradeStatus == 'Lost' ? capital : 0,
        'netWorth': tradeStatus == 'Won' ? proposal['payout'] : capital * -1,
        'timestamp': DateTime.now().millisecondsSinceEpoch
      });
    }
  });
  // updateSnackbarVisibility(false);
}
