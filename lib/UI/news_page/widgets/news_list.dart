import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:lab_news_4/UI/news_details_page/news_details_page.dart';
import 'package:lab_news_4/repositories/news_repository/DTO/news_list_item.dart';
import 'package:lab_news_4/repositories/news_repository/news_repository.dart';

/// A subsystem for displaying "List of news" widget of "news" page to the user.
class NewsListWidget extends StatelessWidget
{
  final NewsRepository news;
  final List<NewsListItem> newsList;
  final void Function() updateNewsList;

  const NewsListWidget({super.key, required this.news, required this.newsList, required this.updateNewsList});

  @override
  Widget build(BuildContext context)
  {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10.0)
        ),
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: newsList.length,
          itemBuilder: (BuildContext context, int index)
          {
            NewsListItem newsItem = newsList[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                title: Text(
                  newsItem.getTitle(),
                  style:
                  TextStyle(
                    fontWeight: newsItem.isWatched() ? FontWeight.normal : FontWeight.bold
                  ),
                ),
                subtitle: Text(
                  DateFormat('d MMMM y г.', 'ru').format(newsItem.getPublicationDate()),
                  style: const TextStyle(color: Colors.black),
                ),
                onTap: ()
                {
                  news.markAsWatched(newsItem.getId());
                  updateNewsList();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsDetailsPage(newsItemId: newsItem.getId(), news: news)
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
