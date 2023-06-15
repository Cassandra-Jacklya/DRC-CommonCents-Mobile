// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../pages/homepage.dart';
import '../pages/newspage.dart';
import '../pages/simulationpage.dart';
import '../pages/profilepage.dart';

class BottomNavBarCubit extends Cubit<int>{
  BottomNavBarCubit() : super(0);

  void updatePageIndex(int index){
    emit(index);
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  static const List<Widget> _pages = [HomePage(), NewsPage(), SimulationPage(), ProfilePage(),];

  Widget _currentPage = HomePage();

  final List<BottomNavigationBarItem> _BottomNavBarItems = [

    const BottomNavigationBarItem(
      icon: Icon(
        Icons.home,
        color: Colors.blueAccent,
        size: 40,
      ),
      label: 'Home',
      // backgroundColor: Colors.blueAccent,
    ),

    const BottomNavigationBarItem(
      icon: Icon(
        Icons.newspaper,
        color: Colors.blueAccent,
        size: 40,

      ),
      label: 'News',
      // backgroundColor: Colors.blueAccent,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.forum, color: Colors.blueAccent,size:40,),
      label: 'Players',
      
      // backgroundColor: Colors.blueAccent,
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.person,
        color: Colors.blueAccent,
        size: 40,
        
      ),
      label: 'Favourites',
      // backgroundColor: Colors.blueAccent,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomNavBarCubit = context.watch<BottomNavBarCubit>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 4,
              blurRadius: 1,
              offset: const Offset(0, 3)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          items: _BottomNavBarItems,
          currentIndex: bottomNavBarCubit.state,
          onTap: (index) => bottomNavBarCubit.updatePageIndex(index),
          selectedItemColor: Colors.blue,
        ),
      ),
    );
  }
}