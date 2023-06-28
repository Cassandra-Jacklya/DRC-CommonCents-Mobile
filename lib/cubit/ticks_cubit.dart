import 'package:flutter_bloc/flutter_bloc.dart';

class TicksCubit extends Cubit<double>{
  TicksCubit() : super(1);

  void updateSelectedValue(double selectedValue) {
    emit(selectedValue);

  }
}
