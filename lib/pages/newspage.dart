import 'package:commoncents/apistore/news_lazyLoading.dart';
import 'package:commoncents/components/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final controller = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();
  List<dynamic> _NewsData = [];
  List<dynamic> _constantData = [];
  List<dynamic> _OriginalNewsList = [];
  List<dynamic> _newsList = [];
  bool isLoading = true;

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
    final newsTabBarCubit = context.read<NewsTabBarCubit>();
    final selectedTopic = newsTabBarCubit.state;
    _lazyFuture = getLazyNews(selectedTopic);
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetch();
      }
    });
  }

  Future<void> fetch() async {
    final int originalNewsListLength = _OriginalNewsList.length;
    const int takeCount = 8;
    final remainingNewsCount = _NewsData.length - originalNewsListLength;

    if (remainingNewsCount > 0) {
      final int newsToAddCount =
          remainingNewsCount < takeCount ? remainingNewsCount : takeCount;
      final newNewsList =
          _NewsData.skip(originalNewsListLength).take(newsToAddCount).toList();
      setState(() {
        _OriginalNewsList.addAll(newNewsList);
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "News",
        logo: "assets/images/commoncents-logo.png",
        hasBell: true,
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
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey),
                  ),
                  padding: const EdgeInsets.only(left: 20),
                  margin: const EdgeInsets.only(
                    top: 10,
                    left: 10,
                    right: 10,
                    bottom: 20,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textEditingController,
                          onChanged: _handleFilterChanged,
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
                          icon: const Icon(Icons.search),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          NewsTabBar(onTopicChanged: _handleTopicChanged),
          const SizedBox(height: 30),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _lazyFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  _NewsData = snapshot.data as List<dynamic>;
                  // print("News data: ${_NewsData.length}");
                  if (_textEditingController.text.isNotEmpty) {
                    // print("Before: ${_constantData.length}");
                    final filteredList =
                        _applyFilter(_NewsData, _textEditingController.text);
                    // print("Const: ${_constantData.length}");
                    return ListView.builder(
                        controller: controller,
                        itemCount: filteredList.length + 1,
                        itemBuilder: (context, index) {
                          if (index < filteredList.length) {
                            final news = filteredList[index];
                            return Container(
                              margin: const EdgeInsets.all(10),
                              height: 100,
                              color: Colors.grey[300],
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      Uri url = Uri.parse(news['url']);
                                      launchUrl(url);
                                    },
                                    child: Container(
                                      color: Colors.white,
                                      height: 80,
                                      width: 80,
                                      child: Image.network(
                                        (news['banner_image'] != null &&
                                                news['banner_image'] != "")
                                            ? news['banner_image']
                                            : 'https://static.vecteezy.com/system/resources/previews/000/440/213/original/question-mark-vector-icon.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      news[
                                          'title'], // Update this with the appropriate key for the news title
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        });
                  } else if (_textEditingController.text.isEmpty) {
                    bool once = true;
                    if (once) {
                      final int originalNewsListLength =
                          _OriginalNewsList.length;
                      const int takeCount = 8;
                      _OriginalNewsList.addAll(
                          _NewsData.skip(originalNewsListLength)
                              .take(takeCount));
                      once =!once;
                    }

                    print(_OriginalNewsList.length);
                    return ListView.builder(
                      controller: controller,
                      itemCount: _OriginalNewsList.length + 1,
                      itemBuilder: (context, index) {
                        if (index < _OriginalNewsList.length) {
                          final news = _OriginalNewsList[index];
                          return Container(
                            margin: const EdgeInsets.all(10),
                            height: 100,
                            color: Colors.grey[300],
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    Uri url = Uri.parse(news['url']);
                                    launchUrl(url);
                                  },
                                  child: Container(
                                    color: Colors.white,
                                    height: 80,
                                    width: 80,
                                    child: Image.network(
                                      (news['banner_image'] != null &&
                                              news['banner_image'] != "")
                                          ? news['banner_image']
                                          : 'https://static.vecteezy.com/system/resources/previews/000/440/213/original/question-mark-vector-icon.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    news[
                                        'title'], // Update this with the appropriate key for the news title
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return isLoading
                              ? const SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: CircularProgressIndicator())
                              : Container(
                                  color: Colors.red,
                                  child: const Text("No News Available"),
                                );
                        }
                      },
                    );
                  }
                }
                return const Text('No News Available');
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(
        index: 1,
      ),
    );
  }
}
