import '../../enums/news_channel.dart';

/// A subsystem for reading data about certain news passed from the NewsRepository.
class NewsDetails
{
  final String _id;
  final String _title;
  final String _author;
  final NewsChannel _channel;
  final DateTime _publishedAt;
  final String _content;
  final String _url;
  bool _isWatched;

  NewsDetails({required String id, required String title, required String author, required NewsChannel channel, required DateTime publishedAt, required String content, required String url, required bool isWatched}) : _id = id, _title = title, _author = author, _channel = channel, _publishedAt = publishedAt, _content = content, _url = url, _isWatched = isWatched;

  String getId() => _id;
  String getTitle() => _title;
  String getAuthor() => _author;
  NewsChannel getChannel() => _channel;
  DateTime getPublicationDate() => _publishedAt.toLocal();
  String getContent() => _content;
  String getURL() => _url;
  bool isWatched() => _isWatched;
  void markAsWatched() => _isWatched = true;
}
