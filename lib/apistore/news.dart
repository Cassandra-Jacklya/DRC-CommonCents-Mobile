import 'dart:convert';
import 'package:http/http.dart' as http;

const apiKey = '2W7M76O2TLJVJQCQ';
Uri url = Uri.parse(
    'https://www.alphavantage.co/query?function=NEWS_SENTIMENT&sort=LATEST&limit=1000&apikey=$apiKey');

Future<List<dynamic>> getNews() async {
  var response = await http.get(url);

  List<dynamic> news = [];
  var data;

  if (response.statusCode == 200) {
    data = jsonDecode(response.body);
    final feed = data['feed'];
    news = feed.sublist(0, 8);

    return news;
  } else {
    throw Exception('Failed to load data');
  }
}
