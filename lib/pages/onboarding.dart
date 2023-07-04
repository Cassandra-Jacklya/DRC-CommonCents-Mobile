import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../components/appbar.dart';
import 'auth_pages/login.dart';
import 'auth_pages/register.dart';
import 'homepage.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(50, 90, 56, 90),
            child: Text("Welcome to our CommonCents Community",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20
              ),
            ),
          ),
          const Image(image: AssetImage('assets/images/trading-onboarding.jpg'),
            height: 170,
            width: 217,
          ),
          const Padding(
            padding:  EdgeInsets.fromLTRB(0, 36, 0, 0),
            child:  Text("Zero real money.",
              style: TextStyle(
                fontSize: 15
              ),
            ),
          ),
          const Text("Experience real trading.",
            style: TextStyle(
              fontSize: 15
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {}, 
                  icon: const FaIcon(FontAwesomeIcons.solidCircle,
                    size: 10,
                    color: Color(0xFF5F5F5F),
                  )
                ),
                IconButton(
                  onPressed: () {}, 
                  icon: const FaIcon(FontAwesomeIcons.solidCircle,
                    size: 10,
                    color: Color(0xFFD9D9D9),
                  )
                ),
                IconButton(
                  onPressed: () {}, 
                  icon: const FaIcon(FontAwesomeIcons.solidCircle,
                    size: 10,
                    color: Color(0xFFD9D9D9),
                  )
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.push(context, 
                MaterialPageRoute(
                  builder: (context) {
                    return const RegisterView();
                  }
                )
              );
            },  
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3366FF),
              fixedSize: const Size(298, 44)
            ),
            child: const Text("Create Account",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                fontFamily: 'Roboto',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 17, 0, 0),
            child: ElevatedButton(
              onPressed: () async {
                Navigator.push(context, 
                  MaterialPageRoute(
                    builder: (context) {
                      return const LoginView();
                    }
                  )
                );
              }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD9D9D9),
                fixedSize: const Size(298, 44)
              ),
              child: const Text("Log In",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Roboto',
                  color: Colors.black
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 12, 0 ,0),
            child: GestureDetector(
              child: const Text("Enter as Guest",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF3366FF)
                ),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
          )
        ],
        ),
      )
    );
  }
}