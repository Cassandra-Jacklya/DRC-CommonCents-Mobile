import 'package:flutter_bloc/flutter_bloc.dart';

class LiveLinePriceCubit extends Cubit<List<double>> {
  LiveLinePriceCubit() : super([]);

  void updateLiveLinePrice(List<double> price) {
    emit([...price]);
  }

}