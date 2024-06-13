/// A subsystem for passing data into method "find" of NewsRepository.
class FindNewsViewModel
{
  final String? query;
  final DateTime? from;
  final DateTime? to;
  late final bool ignoreWatchedNews;

  FindNewsViewModel(this.query, this.from, this.to, this.ignoreWatchedNews);
}
