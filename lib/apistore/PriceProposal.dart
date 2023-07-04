import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../apistore/stockdata.dart';

void handleBuy(int ticks, String stakePayout, int currentAmount) {
  final PriceProposalRequest = {
    "proposal": 1,
    "amount": currentAmount,
    "basis": stakePayout,
    "contract_type": "CALL",
    "currency": "USD",
    "duration": ticks,
    "duration_unit": "t",
    "symbol": "R_100"
  };
  socket?.sink.add(jsonEncode(PriceProposalRequest));
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
    double currentBalance = userData['balance'].toDouble() ?? 0;
    double updatedBalance = currentBalance - capital;
    await collectionReference.doc(user.uid).update({'balance': updatedBalance});
    return updatedBalance;
  }
  return 0;
}

void handleBuyResponse(Map<String,dynamic> decodedData) async {
    late double buyingPrice;
    late double sellingPrice;
    late double capital;
    late double currentBalance;
    late double updatedBalance;

    final Map<String, dynamic> proposal = decodedData['proposal'];
    capital = decodedData['echo_req']['amount'].toDouble();

    
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference collectionReference =
        firebaseFirestore.collection('users');

    
    DocumentSnapshot userSnapshot =
        await collectionReference.doc(user!.uid).get();
    Map<String, dynamic>? userData =
        userSnapshot.data() as Map<String, dynamic>?;

    
    if (userData != null) {
      currentBalance = userData['balance'].toDouble() ?? 0;
      updatedBalance = currentBalance - capital;
      collectionReference.doc(user.uid).update({'balance': updatedBalance});
    }

    buyingPrice = ticks.last['close'];
    await Future.delayed(const Duration(seconds: 3));
    sellingPrice = ticks.last['close'];

    if (buyingPrice < sellingPrice) {
        updatedBalance = updatedBalance + proposal['payout'];
        collectionReference.doc(user.uid).update({'balance': updatedBalance});
        print("You Won");
    } else {
      print("Buying: $buyingPrice\nSelling: $sellingPrice\nSo: you lost :(");
    }
}