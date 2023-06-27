import 'package:flutter/material.dart';
import '../components/news_tabbar.dart';
import '../cubit/news_tabbar_cubit.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final TextEditingController _textEditingController = TextEditingController();

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
            Container(
              margin: const EdgeInsets.all(10),
              color: Colors.grey[400],
              height: 500,
            )
          ],
        ),
      ),
    );
  }
}


