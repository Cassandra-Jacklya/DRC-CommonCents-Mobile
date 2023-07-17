import 'package:commoncents/apistore/news_lazyLoading.dart';
import 'package:commoncents/components/navbar.dart';
import 'package:commoncents/components/newscontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/appbar.dart';
import '../components/news_tabbar.dart';
import '../cubit/news_tabbar_cubit.dart';
import '../components/formatString.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  Future<List<dynamic>>? _lazyFuture;
  final TextEditingController _textEditingController = TextEditingController();
  List<dynamic> _NewsData = [];
  List<dynamic> _constantData = [];
  List<dynamic> _OriginalNewsList = [];
  List<dynamic> _newsList = [];
  bool isLoading = true;
  ScrollController _scrollController = ScrollController();

  void displayProgressIndicator() {
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  void _handleTopicChanged(String topic) {
    final formattedTopic = formatTopicForAPI(topic);
    setState(() {
      _NewsData = []; // Clear _NewsData
      _OriginalNewsList = []; // Clear _OriginalNewsList
      _newsList = []; // Clear _newsList
      _lazyFuture = getLazyNews(formattedTopic);
    });
  }

  void _handleFilterChanged(String filterText) {
    setState(() {
      _newsList = _applyFilter(_constantData, filterText);
    });
  }

  List<dynamic> _applyFilter(List<dynamic> newsList, String filterText) {
    if (filterText.isEmpty) {
      return newsList;
    } else {
      return newsList.where((news) {
        final title = news['title'].toString().toLowerCase();
        final formattedFilterText = filterText.toLowerCase();
        return title.contains(formattedFilterText);
      }).toList();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NewsTabBarCubit>(create: (context) => NewsTabBarCubit())
      ],
      child: BlocBuilder<NewsTabBarCubit, String>(
        builder: (context, state) {
          _lazyFuture = getLazyNews(state);
          return Scaffold(
            appBar: const CustomAppBar(
              title: "News",
              logo: "assets/images/commoncents-logo.png",
              isTradingPage: false,
            ),
            body: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                        ),
                        padding: const EdgeInsets.only(left: 20),
                        margin: const EdgeInsets.only(
                          top: 24,
                          left: 16,
                          right: 16,
                          bottom: 10,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _textEditingController,
                                onSubmitted: _handleFilterChanged,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                style: const TextStyle(
                                  fontSize: 23,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(Iconsax.search_normal_1),
                                iconSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22,),
                NewsTabBar(onTopicChanged: _handleTopicChanged),
                const SizedBox(height: 20),
                Expanded(
                  child: FutureBuilder<List<dynamic>>(
                    future: _lazyFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Scaffold(
                          body: Center(
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator()),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        _NewsData = snapshot.data as List<dynamic>;
                        if (_textEditingController.text.isNotEmpty) {
                          final filteredList =
                              _applyFilter(_NewsData, _textEditingController.text);
                          return NewsContainer(
                            feeds: filteredList,
                            scrollable: true,
                            scrollController: _scrollController,
                          );
                        } else if (_textEditingController.text.isEmpty) {
                          return NewsContainer(
                            feeds: _NewsData,
                            scrollable: true,
                            scrollController: _scrollController,
                          );
                        }
                      }
                      return const Text('No News Available');
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // Scroll to top when the button is pressed
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: const Icon(Icons.arrow_upward),
            ),
            bottomNavigationBar: const BottomNavBar(
              index: 1,
            ),
          );
        }
      ),
    );
  }
}



                    // bool once = true;
                    // if (once) {
                    //   final int originalNewsListLength =
                    //       _OriginalNewsList.length;
                    //   const int takeCount = 8;
                    //   _OriginalNewsList.addAll(
                    //       _NewsData.skip(originalNewsListLength)
                    //           .take(takeCount));
                    //   once = !once;
                    // }
                    // print(_OriginalNewsList.length);

                        // scrollController.addListener(() {
    //   if (scrollController.position.maxScrollExtent ==
    //       scrollController.offset) {
    //     print("yes");
    //     fetch();
    //   }
    // });