import 'package:commoncents/apistore/news_lazyLoading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../components/news_tabbar.dart';
import '../cubit/news_tabbar_cubit.dart';
import '../components/newscontainer.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  Future<List<dynamic>>? _lazyFuture;
  final TextEditingController _textEditingController = TextEditingController();
  List<dynamic> _newsList = [];

  String formatTopicForAPI(String topic) {
    switch (topic) {
      case 'All':
        return 'All';
      case 'Blockchain':
        return 'blockchain';
      case 'Earnings':
        return 'earnings';
      case 'IPO':
        return 'ipo';
      case 'Mergers & Acquisition':
        return 'mergers_and_acquisition';
      case 'Financial Markets':
        return 'financial_markets';
      case 'Econ - Fiscal Policy':
        return 'economy_fiscal';
      case 'Econ - Monetary Policy':
        return 'economy_monetary';
      case 'Econ - Macro/Overall':
        return 'economy_macro';
      case 'Finance':
        return 'finance';
      case 'Retail & Wholesale':
        return 'retail_wholesale';
      case 'Technology':
        return 'technology';
      default:
        return topic.toLowerCase().replaceAll(' ', '_');
    }
  }

  void _handleTopicChanged(String topic) {
    final formattedTopic = formatTopicForAPI(topic); // Format the topic
    setState(() {
      _lazyFuture = getLazyNews(formattedTopic);
    });
  }

  @override
  void initState() {
    super.initState();
    final newsTabBarCubit = context.read<NewsTabBarCubit>();
    final selectedTopic = newsTabBarCubit.state;
    _lazyFuture = getLazyNews(selectedTopic);
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
            NewsTabBar(onTopicChanged: _handleTopicChanged),
            const SizedBox(height: 30),
            FutureBuilder<List<dynamic>>(
              future: _lazyFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final newsList = snapshot.data;
                  print(newsList?.length);
                  return NewsContainer(feeds: newsList);
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
