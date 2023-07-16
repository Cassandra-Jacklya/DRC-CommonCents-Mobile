import 'package:commoncents/components/navbar.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../components/card.dart';
import '../components/carousel_chart.dart';
import '../components/newscontainer.dart';
import '../components/popup.dart';

class HomePageGuest extends StatefulWidget {
  final Future<List<dynamic>>? newsFuture;

  const HomePageGuest({Key? key, this.newsFuture}) : super(key: key);

  @override
  _HomePageGuestState createState() => _HomePageGuestState();
}

class _HomePageGuestState extends State<HomePageGuest> {
    List<String> images = [
    'assets/images/stock.png',
    'assets/images/commodity.png',
    'assets/images/market.png',
    'assets/images/cryptocurrency.png',
    'assets/images/trading.png',
    'assets/images/bull.png',
  ];

  List<String> title = [
    'Stock Trading',
    'Commodity Trading',
    'Basket Trading',
    'Cryptocurrency Trading',
    'Forex Trading',
    'Synthetic Trading',
  ];

  List<String> content = [
    'Stock trading broadly refers to any buying and selling of stock, but is colloquially used to refer to more shorter-term investments made by very active investors.',
    'Commodities are known to be a risky investment propositions because their market is impacted by uncertainties such as unusual weather patterns, epidemics, and disasters both natural and human-made.',
    'A basket trade is a type of order used by traders to buy or sell a group of securities simultaneously.',
    'Cryptocurrency is buying or selling digital currencies with the aim of making a profit from the changing value of the underlying asset.',
    "Foreign exchange market is a global marketplace for exchanging national currencies which is the world's largest and most liquid asset markets due to the worldwide reach of trade, commerce and finance. ",
    "A trading strategy in which traders combine various positions like short, long, put or call to mirror another asset's position s quickly without closing the previous positions.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                      "SYNTHETIC INDICES",
                      style: TextStyle(
                        fontSize: 15, 
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext syntheticContext) {
                              return const SyntheticDetails();
                            },
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: Icon(Iconsax.info_circle,
                          color: Color(0xFFCCCCCC),
                          size: 17,
                          ),
                        ),
                      ),
                    ],
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
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (context, index) {
                  return MarketCard(image: images[index], title: title[index],content: content[index],);
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
      ),
    );
  }
}
