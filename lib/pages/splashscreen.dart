// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import './homepage.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     checkFirstLaunch();
//   }

//   void checkFirstLaunch() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

//     if (isFirstLaunch) {
//       await prefs.setBool('isFirstLaunch', false);

//       Future.delayed(const Duration(seconds: 2), () {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const HomePage()),
//         );
//       });
//     } else {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const HomePage()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: Text("Welcome to CommonCents"),
//       ),
//     );
//   }
// }
