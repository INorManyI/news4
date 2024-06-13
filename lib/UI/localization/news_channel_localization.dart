import 'package:lab_news_4/repositories/enums/news_channel.dart';

/// Subsystem to translate [NewsChannel] values into user-readable strings.
class NewsChannelLocalization
{
  static final _localizations = {
    NewsChannel.archLinux: 'Arch Linux',
    NewsChannel.habr: 'Habr',
  };

  static String localize(NewsChannel type)
  {
    return _localizations[type]!;
  }
}
