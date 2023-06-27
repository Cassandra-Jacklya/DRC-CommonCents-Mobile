import 'package:flutter_bloc/flutter_bloc.dart';

class NewsTabBarCubit extends Cubit<String>{
  NewsTabBarCubit() : super('All');

  void updatedTopic(String topic){
    emit(topic);
  }

}