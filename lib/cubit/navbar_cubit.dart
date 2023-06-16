import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavBarCubit extends Cubit<int> {
  BottomNavBarCubit() : super(0);

  void updatePageIndex(int index) {
    emit(index);

    print(index);
  }
}