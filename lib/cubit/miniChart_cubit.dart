import 'package:flutter_bloc/flutter_bloc.dart';

class MiniChartCubit extends Cubit<List<Map<String, dynamic>>>
    implements StateStreamable<List<Map<String, dynamic>>> {
  MiniChartCubit() : super([]);

  void updateMiniChart(List<Map<String, dynamic>> newData) {
    emit([...newData]);
  }

  void clearMiniChart() {
    emit([]);
  }
}
