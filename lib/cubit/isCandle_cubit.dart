import 'package:flutter_bloc/flutter_bloc.dart';

class IsCandleCubit extends Cubit<bool> {
  IsCandleCubit() : super(false);

  void isItCandles(bool isCandle) {
    emit(isCandle);
  }

}