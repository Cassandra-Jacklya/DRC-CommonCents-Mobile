import 'package:commoncents/components/appbar.dart';
import 'package:commoncents/components/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:commoncents/pages/homepage.dart';
import 'package:commoncents/pages/newspage.dart';
import 'package:commoncents/pages/simulationpage.dart';
import 'package:commoncents/pages/profilepage.dart';


void main() {
  runApp(const MaterialApp(
    home: MainApp()
  ));
}

class MainApp extends StatefulWidget{

  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      primaryColor: const Color(0xFF1956FC),
      primaryColorLight: const Color(0xFFA4D8EF),
      primaryColorDark: const Color(0xFF155AC1),
      scaffoldBackgroundColor: Colors.white,
      textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
    );

    return MultiBlocProvider(providers: [BlocProvider<BottomNavBarCubit>(create: (context)=>BottomNavBarCubit(),),
    ],child: MaterialApp(
      theme: theme,
      home: BlocBuilder<BottomNavBarCubit, int>(
        builder: (context, selectedIndex){
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: const CustomAppBar(),
            body: _getPage(selectedIndex),
            bottomNavigationBar: const BottomNavBar(),
          );
        },
      ),
    )
    );
  }

  Widget _getPage(int index){
  switch(index){
    case 0:
    return const HomePage();
    case 1:
    return const NewsPage();
    case 2:
    return const SimulationPage();
    case 3:
    return const ProfilePage();
    default:
    return Container();
  }
  }
}