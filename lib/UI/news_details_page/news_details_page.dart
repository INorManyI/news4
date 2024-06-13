// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:lab_news_4/UI/localization/news_channel_localization.dart';
import 'package:lab_news_4/repositories/news_repository/DTO/news_details.dart';
import 'package:lab_news_4/repositories/news_repository/news_repository.dart';

import 'widgets/news_main_info_widget.dart';

class NewsDetailsPage extends StatefulWidget
{
  final NewsRepository news;
  final String newsItemId;

  const NewsDetailsPage({super.key, required this.news, required this.newsItemId});

  @override
  NewsDetailsPageState createState() => NewsDetailsPageState();
}

class NewsDetailsPageState extends State<NewsDetailsPage>
{
  NewsDetails? _newsItem;

  void showErrorMessage(String message)
  {
      final snackBar = SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState()
  {
    super.initState();
    setState(() {
      _newsItem = widget.news.get(widget.newsItemId);
    });
    widget.news.markAsWatched(_newsItem!.getId());
  }

  String? _getTitle()
  {
    if (_newsItem == null)
      return null;

    return NewsChannelLocalization.localize(_newsItem!.getChannel());
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle() ?? ''),
      ),

      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(10)
              ),
              padding: const EdgeInsets.all(16.0),

              child: _newsItem == null
               ? const Center(child: CircularProgressIndicator())
               : SingleChildScrollView(child: NewsMainInfoWidget(_newsItem!))
            ),
          )
        ],
      ),
    );
  }
}
