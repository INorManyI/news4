// ignore_for_file: curly_braces_in_flow_control_structures

import '../DTO/news_details.dart';
import 'news_persistent_storage/news_persistent_storage.dart';

/// A subsystem for interacting with locally stored news data
class NewsCache
{
  static List<NewsDetails> _news = [];
  static List<String> _newsIdentifiers = [];
  static NewsPersistentStorage? _storage;
  static bool _isInitialized = false;

  /// Initializes the [NewsCache]
  Future<void> init() async
  {
    if (_isInitialized)
      return;
    _isInitialized = true;

    _storage = NewsPersistentStorage();
    await _storage!.init();
    _news = _storage!.getAll();
    _newsIdentifiers = _news.map((newsItem) => newsItem.getId()).toList();
  }

  /// Retrieves all news
	List<NewsDetails> getAll()
  {
    // returning shallow clone of the list
    return List<NewsDetails>.from(_news);
  }

  bool _exists(NewsDetails newsItem)
  {
    return _newsIdentifiers.contains(newsItem.getId());
  }

  void _sortByDate(List<NewsDetails> news)
  {
    news.sort((a, b) => b.getPublicationDate().compareTo(a.getPublicationDate()));
  }

  /// Adds [news]
  ///
  /// If [news] already exists, it will be ignored.
	Future<void> add(List<NewsDetails> news) async
  {
    int lenBefore = _newsIdentifiers.length;
    for (NewsDetails newsItem in news)
    {
      if (_exists(newsItem))
        continue;

      _newsIdentifiers.add(newsItem.getId());
      _news.add(newsItem);
    }
    int lenAfter = _newsIdentifiers.length;

    if (lenBefore == lenAfter)
      return;

    _sortByDate(_news);
    await _storage!.set(_news);
  }

  /// Marks [news] as watched by user
  ///
  /// If [news] not exists, nothing will happen.
  Future<void> markAsWatched(String newsId) async
  {
    // Check if exists
    if (! _newsIdentifiers.contains(newsId))
      return;

    int i = _news.indexWhere((item) => item.getId() == newsId);
    _news[i].markAsWatched();

    await _storage!.set(_news);
  }
}
