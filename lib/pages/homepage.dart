import 'package:flutter/material.dart';
import '../apistore/news.dart';
import '../components/newscontainer.dart';

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
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    "MARKET OVERVIEW",
                    style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                  ),
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
      ),
    );
  }
}
