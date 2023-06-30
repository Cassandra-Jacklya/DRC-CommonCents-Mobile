import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentAmountCubit extends Cubit<int> {
  CurrentAmountCubit() : super(0);

  void increment() {
  final currentAmount = state;
  emit(currentAmount + 1);
    }
  

  void decrement() {
  final currentAmount = state;
  emit(currentAmount - 1);
  }

  void setCurrentAmount(int amount) {
    emit(amount.clamp(0, 100));
  }
}