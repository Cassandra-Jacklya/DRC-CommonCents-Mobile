import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../authStore/auth_error.dart';

class LoginStateBloc extends Cubit<LoginState> {
  LoginStateBloc() : super(AppStateInitial());
  
  void initFirebase(String email, String password) async{
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      }
      CollectionReference collectionReference = FirebaseFirestore.instance.collection('users');
      DocumentSnapshot<Object?> doc = await collectionReference.doc(FirebaseAuth.instance.currentUser!.uid).get();
      // if (doc.data() != null) {
        Map<String,dynamic> objData = doc.data() as Map<String, dynamic>;
        double roundedBalance = objData['balance'].toDouble();
        final String data = roundedBalance.toStringAsFixed(2);
        emit(AppStateLoggedIn(email: email, password: password, balance: data));
      // }
    } on FirebaseAuthException catch (e) {
      emit(AppStateError(error: authError(e.code)));
    }
  }

  

  AuthError authError(String code) {
    return AuthError.from(code);
  }

  void updateBalance(String email, String newBalance){
    emit(AppStateLoggedIn(email: email, password: "", balance: newBalance));
  }
}

abstract class LoginState {}

class AppStateLoggedIn extends LoginState {

  AppStateLoggedIn({required this.email, required this.password, required this.balance});

  final String email;
  final String password;
  final String balance;
}

class AppStateLoggedOut extends LoginState {}

class AppStateInitial extends LoginState {}

class AppStateError extends LoginState {
  AppStateError({required this.error});

  final AuthError error;
}