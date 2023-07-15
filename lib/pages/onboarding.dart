import 'dart:async';

import 'package:flutter/material.dart';
import 'auth_pages/login.dart';
import 'auth_pages/register.dart';
import 'homepage.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> with SingleTickerProviderStateMixin {
  
  int _currentPage = 0;
  int _currentText = 0;
  late Timer _timer;
  final PageController _pageController = PageController(
    initialPage: 0,
  );
  final PageController _contentController = PageController(
    initialPage: 0,
  );
  late AnimationController _controller;
  bool isRotated = false;

  List<String> images = [
    "assets/images/trading-onboarding.jpg",
    "assets/images/news-onboarding.jpg",
    "assets/images/forum-onboarding.png"
  ];

  List<String> text = [
    "Zero real money",
    "Experience real trading.",
    "Discover the latest",
    "trading news.",
    "Connect with real",
    "users globally."
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _timer = Timer.periodic(
      const Duration(seconds: 3), 
      (Timer timer) {
        if (_currentPage < 2) {
          if (_controller.status == AnimationStatus.completed) {
            _controller.reset();
          }
          _currentPage++;
          _controller.forward();
        }
        else {
          if (_controller.status == AnimationStatus.completed) {
            _controller.reset();
          }
          _currentPage = 0;
          _controller.forward();     
        }

        if (_currentText < 2) {
          _currentText++;
        }
        else {
          _currentText = 0;
        }

        // setState(() {
        //   isRotated = !isRotated;
        // });
        

        _pageController.animateToPage(
          _currentPage, 
          duration: const Duration(milliseconds: 400), 
          curve: Curves.easeIn,
        );

        _contentController.animateToPage(_currentText, 
        duration: const Duration(milliseconds: 400), 
        curve: Curves.linear);

        _contentController.animateToPage(_currentText, 
        duration: const Duration(milliseconds: 400), 
        curve: Curves.linear); 
      }
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [Column(
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
            SizedBox(
              height: 170,
              width: 217,
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage(images[0]),
                      fit: BoxFit.cover
                        )
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage(images[1]),
                      fit: BoxFit.cover
                      )
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage(images[2]),
                      fit: BoxFit.cover
                      )
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 100,
              width: 300,
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _contentController,
                children: [
                  Padding(
                    padding:  const EdgeInsets.fromLTRB(0, 36, 0, 0),
                    child:  Column(
                      children: [
                        Text(text[0],
                          style: const TextStyle(
                            fontSize: 15
                          ),
                        ),
                        Text(text[1],
                          style: const TextStyle(
                            fontSize: 15
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:  const EdgeInsets.fromLTRB(0, 36, 0, 0),
                    child:  Column(
                      children: [
                        Text(text[2],
                          style: const TextStyle(
                            fontSize: 15
                          ),
                        ),
                        Text(text[3],
                          style: const TextStyle(
                            fontSize: 15
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:  const EdgeInsets.fromLTRB(0, 36, 0, 0),
                    child:  Column(
                      children: [
                        Text(text[4],
                          style: const TextStyle(
                            fontSize: 15
                          ),
                        ),
                        Text(text[5],
                          style: const TextStyle(
                            fontSize: 15
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 91, 0, 0),
              child: ElevatedButton(
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
            // !isRotated 
            // ? Positioned(
            //   height: 46.17,
            //   width: 42,
            //   top: 375,
            //   left: 160,
            //   child: Container(
            //     decoration: const BoxDecoration(
            //       image: DecorationImage(image: AssetImage("assets/images/commoncents-logo.png"),
            //       )
            //     ),
            //   ),
            // )
            
            Positioned(
                height: 46.17,
                width: 42,
                top: 375,
                left: 160,
              child: RotationTransition(
                turns: Tween(begin: 0.0, end: 2.0).animate(_controller),
                child: RotatedBox(
                    quarterTurns: 1,
                    child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(image: AssetImage("assets/images/commoncents-logo.png"),
                      )
                    ),
                  ),
                  ),
              ),
            ),
          ],
        ),
      )
    );
  }
}