import 'package:flutter/material.dart';
import '../components/appbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(scrollDirection: Axis.vertical,
        child: Column(children:[
          const SizedBox(height: 30),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text(
                  "MARKET OVERVIEW",
                  style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: const EdgeInsets.only(top: 15),
              color: Colors.grey,
              height: 150,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 13),
                        color: Colors.white,
                        height: 70,
                        width: 70),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 13),
                        color: Colors.white,
                        height: 70,
                        width: 70),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 13),
                        color: Colors.white,
                        height: 70,
                        width: 70),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 13),
                        color: Colors.white,
                        height: 70,
                        width: 70),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 13),
                        color: Colors.white,
                        height: 70,
                        width: 70),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 13),
                        color: Colors.white,
                        height: 70,
                        width: 70),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 13),
                        color: Colors.white,
                        height: 70,
                        width: 70),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text(
                  "NEWS HEADLINE",
                  style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(margin: const EdgeInsets.all(10), width: 400, height: 100, color: Colors.grey,),
              Container(margin: const EdgeInsets.all(10), width: 400, height: 100, color: Colors.grey,),
              Container(margin: const EdgeInsets.all(10), width: 400, height: 100, color: Colors.grey,),
              Container(margin: const EdgeInsets.all(10), width: 400, height: 100, color: Colors.grey,),
              Container(margin: const EdgeInsets.all(10), width: 400, height: 100, color: Colors.grey,),
              Container(margin: const EdgeInsets.all(10), width: 400, height: 100, color: Colors.grey,),
              Container(margin: const EdgeInsets.all(10), width: 400, height: 100, color: Colors.grey,),

            ],
          )
        ],)
      ),
      
    );
  }
}
