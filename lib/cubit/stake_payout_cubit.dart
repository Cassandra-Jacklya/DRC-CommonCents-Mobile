import 'package:flutter_bloc/flutter_bloc.dart';

class StakePayoutCubit extends Cubit<int>{
  StakePayoutCubit() : super(0);

  void updateStakePayout(int index){
    emit(index);
  }

}