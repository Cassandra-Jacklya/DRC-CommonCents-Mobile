import 'package:flutter_bloc/flutter_bloc.dart';

class MarketsCubit extends Cubit<String> {
  MarketsCubit() : super('Volatility 50');

  void updateMarkets(String market) {
    emit(market);
    print("Here: $market");
  }

}