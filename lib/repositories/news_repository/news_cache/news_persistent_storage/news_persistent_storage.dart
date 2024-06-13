// ignore_for_file: constant_identifier_names, curly_braces_in_flow_control_structures

import 'dart:convert';
import 'package:lab_news_4/repositories/enums/news_channel.dart';

import '../../DTO/news_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A subsystem for interacting with news data stored in a persistent storage
/// (database or file)
class NewsPersistentStorage
{
  static const KEY = 'news';
  static SharedPreferences? _storage;

  /// Initializes the [NewsPersistentStorage]
  Future<void> init() async
  {
    _storage = _storage ?? await SharedPreferences.getInstance();
  }

  String _newsToJson(NewsDetails news)
  {
    return jsonEncode({
      'id': news.getId(),
      'title': news.getTitle(),
      'author': news.getAuthor(),
      'channel': news.getChannel().index,
      'publishedAt': news.getPublicationDate().toIso8601String(),
      'content': news.getContent(),
      'url': news.getURL(),
      'isWatched': news.isWatched()
    });
  }

  NewsDetails _jsonToNews(String json)
  {
    return NewsDetails(
      id: jsonDecode(json)['id'],
      title: jsonDecode(json)['title'],
      author: jsonDecode(json)['author'],
      channel: NewsChannel.values[jsonDecode(json)['channel']],
      publishedAt: DateTime.parse(jsonDecode(json)['publishedAt']),
      content: jsonDecode(json)['content'],
      url: jsonDecode(json)['url'],
      isWatched: jsonDecode(json)['isWatched']
    );
  }

  /// Retrieves all news
	List<NewsDetails> getAll()
  {
    if (_storage == null)
      throw Exception('NewsPersistentStorage not initialized');

    return _storage!.getStringList(KEY)?.map((json) => _jsonToNews(json)).toList() ?? [];
  }

  /// Replaces all news
	Future<void> set(List<NewsDetails> news) async
  {
    if (_storage == null)
      throw Exception('NewsPersistentStorage not initialized');

    await _storage!.setStringList(KEY, news.map((newsItem) => _newsToJson(newsItem)).toList());
  }
}
