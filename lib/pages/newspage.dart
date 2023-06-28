import 'package:commoncents/apistore/news_lazyLoading.dart';
import 'package:flutter/material.dart';
import '../components/news_tabbar.dart';
import '../cubit/news_tabbar_cubit.dart';
import '../components/newscontainer.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final TextEditingController _textEditingController = TextEditingController();
  List<dynamic> _newsList = [];
  int _currentPage = 2;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchNews(); // Call the initial fetch function
    _scrollController.addListener(_scrollListener); // Add scroll listener
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener); // Remove scroll listener
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Reached the bottom of the scroll view
      setState(() {
        _currentPage++; // Increment the current page
      });
      _fetchNews(); // Fetch more news
    }
  }

  Future<void> _fetchNews() async {
    try {
      final news =
          await getNews(_currentPage); // Fetch news for the current page
      setState(() {
        _newsList.addAll(news); // Add fetched news to the list
      });
    } catch (e) {
      // Handle error if necessary
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
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
            NewsTabBar(),
            const SizedBox(height: 30),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _newsList.length + 1, // Add 1 for loading indicator
              itemBuilder: (context, index) {
                if (index < _newsList.length) {
                  final newsItem = _newsList[index];
                  return NewsContainer(feeds: [newsItem]);
                } else if (index == _newsList.length) {
                  return const CircularProgressIndicator();
                } else {
                  return null; // Return null for indices beyond the news list length
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
