import 'dart:convert';
import 'package:http/http.dart' as http;

const apiKey = '2W7M76O2TLJVJQCQ';
Uri url = Uri.parse(
    'https://www.alphavantage.co/query?function=NEWS_SENTIMENT&sort=LATEST&limit=200&apikey=$apiKey');

Future<List<dynamic>> getNews(int page) async {
  var response = await http.get(url);

  List<dynamic> news = [];
  var data;

  if (response.statusCode == 200) {
    data = jsonDecode(response.body);
    final feed = data['feed'];
    if (page == 1) {
      news = feed.sublist(0, 8);
    } else if (page == 2) {
      final startIndex = (page - 1) * 8;
      final endIndex = startIndex + 8;
      if (startIndex < feed.length) {
        news = feed.sublist(startIndex, endIndex);
      }
    } 
    return news;
  } else {
    throw Exception('Failed to load data');
  }
}
