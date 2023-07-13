import 'package:flutter_bloc/flutter_bloc.dart';

class LineTimeCubit extends Cubit<String> {
  LineTimeCubit() : super('Ticks');

  void updateLineTime(String unit) {
    emit(unit);
  }
}
