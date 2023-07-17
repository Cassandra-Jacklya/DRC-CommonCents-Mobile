import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentAmountCubit extends Cubit<int> {
  CurrentAmountCubit() : super(0);

  void increment(int amount) {
  emit(amount + 1);
    }
  

  void decrement(int amount) {
  emit(amount - 1);
  }

  void setCurrentAmount(int amount) {
    emit(amount.clamp(1, 500));
  }
}