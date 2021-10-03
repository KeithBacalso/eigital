import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({
    Key? key,
    required this.thumbnail,
    required this.title,
    required this.description,
    required this.author,
    required this.publishDate,
    required this.newsUrl,
  }) : super(key: key);

  final String thumbnail;
  final String title;
  final String description;
  final String author;
  final String publishDate;
  final String newsUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: InkWell(
        onTap: () async {
          try {
            if (await canLaunch(newsUrl)) {
              await launch(
                newsUrl,
                forceWebView: true,
                forceSafariVC: true,
                enableJavaScript: true,
              );
            } else {
              throw 'Could not launch url!';
            }
          } catch (e) {
            print(e);
          }
        },
        child: Material(
          elevation: 3,
          child: SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.5,
                  child: Image.network(thumbnail),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                    child: _ArticleContents(
                      title: title,
                      description: description,
                      author: author,
                      publishDate: publishDate,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ArticleContents extends StatelessWidget {
  const _ArticleContents({
    Key? key,
    required this.title,
    required this.description,
    required this.author,
    required this.publishDate,
  }) : super(key: key);

  final String title;
  final String description;
  final String author;
  final String publishDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 2.0)),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                author,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black87,
                ),
              ),
              Text(
                DateFormat('MM/dd/yy').format(
                  DateTime.parse(publishDate),
                ),
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
