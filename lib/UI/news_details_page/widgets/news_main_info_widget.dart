import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:lab_news_4/repositories/news_repository/DTO/news_details.dart';
import 'package:url_launcher/url_launcher.dart';

/// A subsystem for displaying widget with general information about food
/// on the "Place details" page for the user.
class NewsMainInfoWidget extends StatelessWidget
{
  final NewsDetails _newsItem;

  const NewsMainInfoWidget(this._newsItem, {super.key});

  @override
  Widget build(BuildContext context)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Title(
              color: Colors.black,
              child: Text(
                _newsItem.getTitle(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Link to publication
            InkWell(
              child: const Text(
                'Открыть оригинал',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18
                ),
              ),
              onTap: () => launch(_newsItem.getURL()),
            ),
            const SizedBox(height: 10),

            // Author and publication date
            Text(
              "${_newsItem.getAuthor()}, ${DateFormat('d MMMM y г. H:mm', 'ru').format(_newsItem.getPublicationDate())}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18
                ),
            ),

            // news' content
            SingleChildScrollView(
              child: Html(data: _newsItem.getContent()),
            )
          ],
        )
      ],
    );
  }
}
