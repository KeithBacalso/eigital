import 'package:eigital_test/models/news.dart';
import 'package:flutter/material.dart';

import 'news_card.dart';

class NewsListview extends StatelessWidget {
  final NewsList newsList;

  const NewsListview({Key? key, required this.newsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: newsList.news.length,
        itemBuilder: (context, index) {
          final news = newsList.news[index];

          return NewsCard(
            thumbnail: news.urlToImage.toString(),
            title: news.title != null ? news.title.toString() : "[NO TITLE]",
            description: news.description != null
                ? news.title.toString()
                : "[NO DESCRIPTION]",
            author:
                news.author != null ? news.author.toString() : "[NO AUTHOR]",
            publishDate: news.publishedAt != null
                ? news.publishedAt.toString()
                : "[NO PUBLISH DATE]",
            newsUrl: news.url.toString(),
          );
        });
  }
}
