// ignore_for_file: curly_braces_in_flow_control_structures

import 'DTO/news_details.dart';
import 'errors/update_news_errors.dart';
import 'view_models/find_news_view_model.dart';
import 'package:lab_news_4/repositories/enums/news_channel.dart';
import 'package:lab_news_4/repositories/news_repository/news_filter.dart';
import 'package:lab_news_4/repositories/news_repository/DTO/news_list_item.dart';
import 'package:lab_news_4/repositories/news_repository/news_cache/news_cache.dart';
import 'package:lab_news_4/repositories/news_repository/rss_downloader/rss_downloader.dart';
import 'package:lab_news_4/repositories/news_repository/rss_downloader/errors/rss_fetch_errors.dart';

/// A subsystem for interacting with stored data on news.
class NewsRepository
{
  NewsCache? _news;
  bool _isInitialized = false;

  /// Initializes [NewsRepository]
  Future<void> init() async
  {
    if (_isInitialized)
      return;
    _isInitialized = true;

    _news = NewsCache();
    await _news!.init();
  }

  /// Synchronizes the stored data with the data from news channels
  Future<void> synchronize(UpdateNewsErrors errors) async
  {
    if (! _isInitialized)
      throw Exception('NewsRepository not initialized');

    List<NewsDetails> newsList = [];
    final rss = RssDownloader();
    for (NewsChannel channel in NewsChannel.values)
    {
      final fetchErrors = RssFetchErrors();
      newsList.addAll(await rss.fetch(channel, fetchErrors));

      if (fetchErrors.hasAny())
      {
        if (fetchErrors.isInternetConnectionMissing())
          errors.add(errors.INTERNET_CONNECTION_MISSING);
        if (fetchErrors.isInternalErrorOccurred())
          errors.add(errors.INTERNAL);
        break;
      }
    }

    await _news!.add(newsList);
  }

  /// Retrieves news' information
  ///
  /// Returns `null` if error occurred or news was not found.
  NewsDetails? get(String newsId)
  {
    if (! _isInitialized)
      throw Exception('NewsRepository not initialized');

    for (NewsDetails newsItem in _news!.getAll())
      if (newsItem.getId() == newsId)
        return newsItem;
    return null;
  }

  /// Marks [news] as watched by user
  ///
  /// If [news] not exists, nothing will happen.
  Future<void> markAsWatched(String newsId) async
  {
    if (! _isInitialized)
      throw Exception('NewsRepository not initialized');

    await _news!.markAsWatched(newsId);
  }

  List<NewsListItem> _convertNewsDetailsToListItems(List<NewsDetails> news)
  {
    return news.map((e) => NewsListItem(id: e.getId(),
                                        title: e.getTitle(),
                                        channel: e.getChannel(),
                                        publishedAt: e.getPublicationDate(),
                                        isWatched: e.isWatched())).toList();
  }

  /// Retrieves a list of relevant news from news channel
  ///
  /// Returns an empty list if error occurred.
  List<NewsListItem> find(NewsChannel channel, FindNewsViewModel search)
  {
    if (! _isInitialized)
      throw Exception('NewsRepository not initialized');

    List<NewsDetails> news = _news!.getAll();

    // Filtering news
    NewsFilter filter = NewsFilter();
    filter.byChannel(news, channel);
    if ((search.from != null) || (search.to != null))
    {
      if ((search.from != null) && (search.to != null))
        filter.byDate(news, search.from!, search.to!);
      else if (search.from != null)
      {
        DateTime maxDate = DateTime.utc(275760,09,13);
        filter.byDate(news, search.from!, maxDate);
      }
      else
      {
        DateTime minDate = DateTime.utc(-271821,04,20);
        filter.byDate(news, minDate, search.to!);
      }
    }
    if (search.ignoreWatchedNews)
      filter.onlyNotWatched(news);
    if (search.query != null)
      filter.byQuery(news, search.query!);

    return _convertNewsDetailsToListItems(news);
  }
}
