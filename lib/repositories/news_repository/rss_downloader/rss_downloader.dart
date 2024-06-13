// ignore_for_file: curly_braces_in_flow_control_structures

import '../../../config.dart';
import 'package:intl/intl.dart';
import '../DTO/news_details.dart';
import 'errors/rss_fetch_errors.dart';
import '../../enums/news_channel.dart';
import 'package:dart_rss/dart_rss.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// A subsystem for fetching news from RSS news feeds
class RssDownloader
{
  /// Checks if device is connected to the internet
  Future<bool> _isConnectedToInternet() async
  {
      return await InternetConnection().hasInternetAccess;
  }

  String _getRssUrl(NewsChannel channel)
  {
    switch (channel) {
      case NewsChannel.archLinux:
        return Config.RSS_URL_ARCH_LINUX;
      case NewsChannel.habr:
        return Config.RSS_URL_HABR;
      default:
        throw Exception('Unknown RSS');
    }
  }

  Future<List<RssItem>> _getRssItems(NewsChannel channel, RssFetchErrors errors) async
  {
    if (! (await _isConnectedToInternet()))
    {
      errors.add(errors.INTERNET_CONNECTION_MISSING);
      return [];
    }

    http.Response response = await http.get(Uri.parse(_getRssUrl(channel)));

    if (response.statusCode != 200)
    {
      errors.add(errors.INTERNAL);
      return [];
    }

    return RssFeed.parse(response.body).items;
  }

  DateTime _parseDateString(String dateString)
  {
    DateFormat format = DateFormat("E, dd MMM yyyy HH:mm:ss Z");

    return format.parse(dateString);
  }

  List<NewsDetails> _convertToNewsDetails(NewsChannel channel, List<RssItem> rssItems)
  {
    List<NewsDetails> result = [];

    for (RssItem rssItem in rssItems)
    {
      String id = rssItem.guid!;
      String title = rssItem.title!;
      String author = rssItem.dc!.creator!;
      DateTime publishedAt = _parseDateString(rssItem.pubDate!);
      String content = rssItem.description!;
      String url = rssItem.link!;

      result.add(NewsDetails(
        id: id,
        title: title,
        author: author,
        channel: channel,
        publishedAt: publishedAt,
        content: content,
        url: url,
        isWatched: false
      ));
    }

    return result;
  }

  /// Fetches news from RSS news feed
  ///
  /// Returns an empty list if error occurred
	Future<List<NewsDetails>> fetch(NewsChannel channel, RssFetchErrors errors) async
	{
    List<RssItem> rssItems = await _getRssItems(channel, errors);
    if (errors.hasAny())
      return [];
    return _convertToNewsDetails(channel, rssItems);
	}
}
