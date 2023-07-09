import 'package:flutter/material.dart';

import '../components/card.dart';
import '../components/carousel_chart.dart';
import '../components/newscontainer.dart';

class HomePageGuest extends StatefulWidget {
  final Future<List<dynamic>>? newsFuture;

  const HomePageGuest({Key? key, this.newsFuture}) : super(key: key);

  @override
  _HomePageGuestState createState() => _HomePageGuestState();
}

class _HomePageGuestState extends State<HomePageGuest> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 30),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "MARKET OVERVIEW",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity, height: 180, //220
            // padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: const CarouselChart(),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 8,
              itemBuilder: (context, index) {
                return const MarketCard();
              },
            ),
          ),
          const SizedBox(height: 30),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: const Text(
              "NEWS HEADLINE",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          FutureBuilder<List<dynamic>>(
            future: widget.newsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                final newsList = snapshot.data;
                return NewsContainer(
                  feeds: newsList,
                  scrollable: false,
                  scrollController: null,
                );
              } else {
                return const Text('No news available.');
              }
            },
          ),
        ],
      ),
    );
  }
}
