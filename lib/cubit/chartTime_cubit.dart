import 'package:flutter_bloc/flutter_bloc.dart';

class ChartTimeCubit extends Cubit<String> {
  ChartTimeCubit() : super('Minutes');

  void updateChartTime(String unit) {
    emit(unit);
  }

}