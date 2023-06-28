import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../authStore/auth_error.dart';

class SignUpStateBloc extends Cubit<RegisterState> {
  SignUpStateBloc() : super(RegisterStateInitial());

  void signUp(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      emit(RegisterStateDone(email: email));
    } on FirebaseAuthException catch (e) {
      emit(RegisterStateError(error: authError(e.code)));
    }
  }
  
  AuthError authError(String code) {
    return AuthError.from(code);
  }
}

abstract class RegisterState {}

class RegisterStateDone extends RegisterState {
  RegisterStateDone({required this.email});

  final String email;
}

class RegisterStateInitial extends RegisterState {}

class RegisterStateError extends RegisterState {
  RegisterStateError({required this.error});

  final AuthError error;
}