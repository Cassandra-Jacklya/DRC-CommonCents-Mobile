import 'package:commoncents/components/navbar.dart';
import 'package:commoncents/cubit/navbar_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../apistore/news.dart';
import '../components/newscontainer.dart';
import '../cubit/login_cubit.dart';
import '../firebase_options.dart';
import 'auth_pages/login.dart';
import 'auth_pages/register.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<dynamic>>? _newsFuture;

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
        BlocProvider<BottomNavBarCubit>(
          create: ((context) => BottomNavBarCubit())
        )
      ], 
      child: Scaffold(
      body: FutureBuilder(
        future:  Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
            final User? user = FirebaseAuth.instance.currentUser;
            if (user == null) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "MARKET OVERVIEW",
                            style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                          ),
                          ElevatedButton(
                            style:  const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
                              side: MaterialStatePropertyAll<BorderSide>(BorderSide(
                                color: Color.fromRGBO(51,102,255, 1),
                                width: 2,
                                style: BorderStyle.solid,
                                strokeAlign: BorderSide.strokeAlignCenter
                              )),
                            ),
                            onPressed: () async {
                              Navigator.push(context, 
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const LoginView();
                                  })
                              );
                            }, 
                            child: const Text("Log In", style: TextStyle(color: Colors.black),)
                            )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      color: Colors.grey[300],
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
                                    color: Colors.white,
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
                          return NewsContainer(feeds: newsList);
                        } else {
                          return const Text('No news available.');
                        }
                      },
                    ),
                  ],
                ),
              );
            }
            else {
              BlocProvider.of<LoginStateBloc>(context).initFirebase('','');
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "MARKET OVERVIEW",
                            style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                          ),
                          BlocBuilder<LoginStateBloc, LoginState>(
                            builder: ((context, state) {
                              if (state is AppStateInitial) {}
                              else if (state is AppStateLoggedIn) {
                                return Text(state.balance);
                              }
                              else if (state is AppStateError){
                                return const Text("null");
                              }
                              return const CircularProgressIndicator();
                            })
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      color: Colors.grey[300],
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
                                    color: Colors.white,
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
                          return NewsContainer(feeds: newsList);
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
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "MARKET OVERVIEW",
                            style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                          ),
                          ElevatedButton(
                            style:  const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
                              side: MaterialStatePropertyAll<BorderSide>(BorderSide(
                                color: Color.fromRGBO(51,102,255, 1),
                                width: 2,
                                style: BorderStyle.solid,
                                strokeAlign: BorderSide.strokeAlignCenter
                              )),
                            ),
                            onPressed: () async {
                              Navigator.push(context, 
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const RegisterView();
                                  })
                              );
                            }, 
                            child: const Text("Register", style: TextStyle(color: Colors.black),)
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      color: Colors.grey[300],
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
                                    color: Colors.white,
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
                          return NewsContainer(feeds: newsList);
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
      ),
    )
    );
  }
}