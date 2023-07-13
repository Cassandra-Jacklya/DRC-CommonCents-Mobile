import 'dart:ffi';

import 'package:flutter_bloc/flutter_bloc.dart';

class LiveLinePriceCubit extends Cubit<double> {
  LiveLinePriceCubit() : super(0.0);

  void updateLiveLinePrice(double price) {
    emit(price);
    print(price);
  }

}