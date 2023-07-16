import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetWalletBloc extends Cubit<ResetWallet> {
  ResetWalletBloc() : super(ResetWalletLoading());

  void initialize() {
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        CollectionReference collectionReference =
            firebaseFirestore.collection('users');
        DocumentReference userDocument = collectionReference.doc(user.uid);
        
        userDocument.get().then((value) {
          Map<String,dynamic> objData;
          objData = value.data() as Map<String, dynamic>;
          double currBalance = objData['balance'].toDouble();
          emit(ResetWalletInitial(balance: currBalance));
        });
      }
    } catch(error) {
      print("error emitting state");
    }
    
  }

  Future<void> resetBalance() async {
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        CollectionReference collectionReference =
            firebaseFirestore.collection('users');
        DocumentReference userDocument = collectionReference.doc(user.uid);

        double updatedBalance = 100000.00; // Set the updated balance value

        await userDocument.update({
          'balance': updatedBalance,
        });
        emit(ResetWalletExecuted(balance: updatedBalance));
      }
    } catch(error) {
      print("error resetting balance");
    }
   
    
  }
}

abstract class ResetWallet {}

class ResetWalletInitial extends ResetWallet {
  final double balance;

  ResetWalletInitial({required this.balance});

}

class ResetWalletExecuted extends ResetWallet {
  final double balance;

  ResetWalletExecuted({required this.balance});
}

class ResetWalletLoading extends ResetWallet {}