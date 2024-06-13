import 'package:lab_news_4/repositories/enums/news_channel.dart';

/// A subsystem for reading data from the NewsRepository needed to
/// generate a list of news
class NewsListItem
{
  final String _id;
  final String _title;
  final NewsChannel _channel;
  final DateTime _publishedAt;
  final bool _isWatched;

  NewsListItem({required String id, required String title, required NewsChannel channel, required DateTime publishedAt, required bool isWatched}) : _id = id, _title = title, _channel = channel, _publishedAt = publishedAt, _isWatched = isWatched;

  String getId() => _id;
  String getTitle() => _title;
  NewsChannel getChannel() => _channel;
  DateTime getPublicationDate() => _publishedAt;
  bool isWatched() => _isWatched;
}
