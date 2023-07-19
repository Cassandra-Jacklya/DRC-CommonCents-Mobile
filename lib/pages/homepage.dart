import 'package:commoncents/apistore/miniChartData.dart';
import 'package:commoncents/apistore/news_lazyLoading.dart';
import 'package:commoncents/components/carousel_chart.dart';
import 'package:commoncents/components/navbar.dart';
import 'package:commoncents/components/walletbutton.dart';
import 'package:commoncents/pages/homepage_guest.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../apistore/news.dart';
import '../components/appbar.dart';
import '../components/card.dart';
import '../components/newscontainer.dart';
import '../components/popup.dart';
import '../cubit/login_cubit.dart';
import '../cubit/miniChart_cubit.dart';
import '../cubit/resetwallet_cubit.dart';
import '../firebase_options.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<dynamic>>? _newsFuture;

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
    'Commodity is a risky investment because their market is impacted by uncertainties such as unusual weather patterns, epidemics, and disasters both natural and human-made.',
    'A basket trade is a type of order used by traders to buy or sell a group of securities simultaneously. These baskets are typically composed of securities that have some common characteristics.',
    'Cryptocurrency is buying or selling digital currencies with the aim of making a profit from the changing value of the underlying asset. They use cryptography for security and operate on a blockchain.',
    "Foreign exchange market is a global marketplace for exchanging national currencies which is the world's largest and most liquid asset markets due to the worldwide reach of trade, commerce and finance. ",
    "A trading strategy in which traders combine various positions like short, long, put or call to mirror another asset's position s quickly without closing the previous positions.",
  ];

  @override
  void initState() {
    super.initState();
    _newsFuture = getNews();
  }

  @override
  void dispose() {
    closeMiniWebSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<LoginStateBloc>(
            create: (context) => LoginStateBloc(),
          ),
          BlocProvider<MiniChartCubit>(
            create: (context) => MiniChartCubit(),
          ),
          BlocProvider<ResetWalletBloc>(
            create: (context) => ResetWalletBloc(),
          )
        ],
        child: Scaffold(
          appBar: const CustomAppBar(
            title: "CommonCents",
            logo: "assets/images/commoncents-logo.png",
            isTradingPage: false,
          ),
          body: FutureBuilder(
              future: Firebase.initializeApp(
                options: DefaultFirebaseOptions.currentPlatform,
              ),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    final User? user = FirebaseAuth.instance.currentUser;
                    if (user == null) {
                      return HomePageGuest(
                        newsFuture: _newsFuture,
                      );
                    } else {
                      BlocProvider.of<LoginStateBloc>(context)
                          .initFirebase(context,'', '');
                          print("Name ${user.displayName}");
                          print("Email ${user.email}");
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        "SYNTHETIC INDICES",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.bold),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext
                                                syntheticContext) {
                                              return const SyntheticDetails();
                                            },
                                          );
                                        },
                                        child: const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(5, 0, 0, 0),
                                          child: Icon(
                                            Iconsax.info_circle,
                                            color: Color(0xFFCCCCCC),
                                            size: 17,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  WalletButton(),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
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
                                  return MarketCard(
                                      image: images[index],
                                      title: title[index],
                                      content: content[index]);
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
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
                              future: _newsFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
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
                  default:
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
                          const Center(child: CircularProgressIndicator()),
                          Container(
                            padding: const EdgeInsets.all(10),
                            color: Colors.white,
                            height: 400,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 6,
                              itemBuilder: (context, index) {
                                return MarketCard(
                                    image: images[index],
                                    title: title[index],
                                    content: content[index]);
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
                        ],
                      ),
                    );
                }
              }),
          bottomNavigationBar: const BottomNavBar(
            index: 0,
          ),
        ));
  }
}
