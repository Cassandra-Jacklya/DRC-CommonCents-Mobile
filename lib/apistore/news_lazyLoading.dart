import 'dart:convert';
import 'package:http/http.dart' as http;

const apiKey = '2W7M76O2TLJVJQCQ';

Future<List<dynamic>> getLazyNews(String topic) async {
  final bool isAllTopic = topic == 'All';
  List<dynamic> news = [];
  var data;
  if (isAllTopic) {
    Uri url = Uri.parse(
        'https://www.alphavantage.co/query?function=NEWS_SENTIMENT&sort=LATEST&limit=1000&apikey=$apiKey');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      final feed = data['feed'];
      if (feed != null) {
        news = feed;
      }
      return news;
    } else {
      throw Exception('Failed to load data');
    }
  } else {
    Uri url = Uri.parse(
        'https://www.alphavantage.co/query?function=NEWS_SENTIMENT&topics=$topic&limit=1000&apikey=$apiKey');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      final feed = data['feed'];
      if (feed != null) {
        // news = feed;
        news = feed.sublist(0, 8);
      }
      return news;
    } else {
      throw Exception('Failed to load data');
    }
  }
}


