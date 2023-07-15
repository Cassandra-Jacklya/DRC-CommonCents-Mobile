import 'package:flutter_bloc/flutter_bloc.dart';

class StockDataCubit extends Cubit<List<Map<String, dynamic>>>
    implements StateStreamable<List<Map<String, dynamic>>> {
  StockDataCubit() : super([]);

  void updateSameStockData(List<Map<String, dynamic>> newData){
    emit(newData);
  }

  void updateStockData(List<Map<String, dynamic>> newData) {
    emit([...newData]);
  }

  void clearStockData() {
    emit([]);
  }
}
