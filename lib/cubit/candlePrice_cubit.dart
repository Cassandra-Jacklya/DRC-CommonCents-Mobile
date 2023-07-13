import 'dart:ffi';

import 'package:flutter_bloc/flutter_bloc.dart';

class candlePriceCubit extends Cubit<List<Map<String,dynamic>>> {
  candlePriceCubit() : super([]);

  void updateLiveLinePrice(List<Map<String,dynamic>> data) {
    emit(data);
    print(data);
  }

}