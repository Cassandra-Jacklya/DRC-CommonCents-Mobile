import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commoncents/cubit/login_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../apistore/stockdata.dart';

// ignore: non_constant_identifier_names
bool Highstrategy = false;

Future<void> handleBuy(BuildContext context, int ticks, String stakePayout,
    int currentAmount, String? strategy) async {
  if (strategy == 'high') {
    Highstrategy = true;
  } else if(strategy =='low'){
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
    "symbol": "R_100"
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
    double balance = userData['balance'].toDouble() ?? 0;
    double updatedBalance = balance - currentAmount;
    await collectionReference.doc(user.uid).update({'balance': updatedBalance});
    context
        .read<LoginStateBloc>()
        .updateBalance(userData['displayName'], updatedBalance.toString());
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
    double currentBalance = userData['balance'].toDouble() ?? 0;
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

  final Map<String, dynamic> proposal = decodedData['proposal'];
  capital = decodedData['echo_req']['amount'].toDouble();

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference collectionReference =
      firebaseFirestore.collection('users');

  DocumentSnapshot userSnapshot =
      await collectionReference.doc(user!.uid).get();
  Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

  double balance = userData!['balance'].toDouble() ?? 0;

  buyingPrice = ticks.last['close'];
  await Future.delayed(const Duration(seconds: 3));
  sellingPrice = ticks.last['close'];

  print(Highstrategy);

  if (Highstrategy) {
    if (buyingPrice < sellingPrice) {
      //strategy = high
      updatedBalance = balance + proposal['payout'];
      collectionReference.doc(user.uid).update({'balance': updatedBalance});
      final loginStateBloc = BlocProvider.of<LoginStateBloc>(
          context as BuildContext,
          listen: false);
      loginStateBloc.updateBalance(
          userData['displayName'], updatedBalance.toString());
      print("You Won");
    }
  } else {
    if (buyingPrice > sellingPrice) {
      //strategy = high
      updatedBalance = balance + proposal['payout'];
      collectionReference.doc(user.uid).update({'balance': updatedBalance});
      final loginStateBloc = BlocProvider.of<LoginStateBloc>(
          context as BuildContext,
          listen: false);
      loginStateBloc.updateBalance(
          userData['displayName'], updatedBalance.toString());
      print("You Won");
    }
  }
}
