import 'dart:convert';

import 'package:eigital_test/models/news.dart';
import 'package:http/http.dart' as http;

class NewsNetwork {
  Future fetchNewsData() async {
    final apiUrl = Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=ph&apiKey=4e02fb288ad54b9e8c679263a2c09e6c");
    final response = await http.get(apiUrl);

    if (response.statusCode != 200) {
      throw Exception('Error fetching news!');
    }

    final newsJson = jsonDecode(response.body)['articles'];
    final newsList = NewsList.fromJson(newsJson);
    return newsList;
  }
}
