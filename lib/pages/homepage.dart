import 'package:commoncents/components/carousel_chart.dart';
import 'package:commoncents/components/navbar.dart';
import 'package:commoncents/components/walletbutton.dart';
import 'package:commoncents/pages/homepage_guest.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import '../apistore/news.dart';
import '../components/appbar.dart';
import '../components/card.dart';
import '../components/newscontainer.dart';
import '../cubit/candlestick_cubit.dart';
import '../cubit/isCandle_cubit.dart';
import '../cubit/login_cubit.dart';
import '../cubit/markets_cubit.dart';
import '../cubit/miniChart_cubit.dart';
import '../cubit/navbar_cubit.dart';
import '../cubit/news_tabbar_cubit.dart';
import '../cubit/numberpicker_cubit.dart';
import '../cubit/register_cubit.dart';
import '../cubit/stake_payout_cubit.dart';
import '../cubit/stock_data_cubit.dart';
import '../cubit/ticks_cubit.dart';
import '../firebase_options.dart';
import 'auth_pages/login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<dynamic>>? _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = getNews();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<LoginStateBloc>(
            create: (context) => LoginStateBloc(),
        ),
        BlocProvider<MiniChartCubit>(create: (context) => MiniChartCubit(),)
      ], 
      child: Scaffold(
      appBar: const CustomAppBar(
        title: "CommonCents",
        logo: "assets/images/commoncents-logo.png",
        hasBell: true,
      ),
      body: FutureBuilder(
        future:  Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final User? user = FirebaseAuth.instance.currentUser;
            if (user == null) {
              return HomePageGuest(newsFuture: _newsFuture,);

            }
            else {
              BlocProvider.of<LoginStateBloc>(context).initFirebase('','');
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                          "SYNTHETIC INDICES",
                          style: TextStyle(
                            fontSize: 15, 
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold
                            ),
                          ),
                          WalletButton(loginStateBloc: LoginStateBloc(),)
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(width: double.infinity, height: 180, //220
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
                          return const Padding(
                            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: MarketCard(),
                          );
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
                      future: _newsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          final newsList = snapshot.data;
                          return NewsContainer(feeds: newsList, scrollable: false,scrollController: null,);
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
                          fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.white,
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.grey,
                                ),
                                height: 75,
                                width: 75,
                              ),
                              const SizedBox(height: 15),
                              const Text("Stock price"),
                            ],
                          ),
                        );
                      },
                    ),
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
                  // FutureBuilder<List<dynamic>>(
                  //   future: _newsFuture,
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return const CircularProgressIndicator();
                  //     } else if (snapshot.hasError) {
                  //       return Text('Error: ${snapshot.error}');
                  //     } else if (snapshot.hasData) {
                  //       final newsList = snapshot.data;
                  //       return NewsContainer(feeds: newsList, scrollable: false,);
                  //     } else {
                  //       return const Text('No news available.');
                  //     }
                  //   },
                  // ),
                ],
              ),
            );
          }
        }
      ),
      bottomNavigationBar: const BottomNavBar(index: 0,),
    )
    );
  }
}
