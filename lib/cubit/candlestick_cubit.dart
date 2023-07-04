import 'package:flutter_bloc/flutter_bloc.dart';

class CandlestickCubit extends Cubit<List<Map<String, dynamic>>>
    implements StateStreamable<List<Map<String, dynamic>>> {
  CandlestickCubit() : super([]);

  void updateCandlestickData(List<Map<String, dynamic>> newData) {
    emit([...newData]);
  }

  void clearStockData() {
    emit([]);
  }
}
