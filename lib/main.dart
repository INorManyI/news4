// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:intl/date_symbol_data_local.dart';
import 'package:lab_news_4/UI/news_page/news_page.dart';
import 'package:lab_news_4/repositories/enums/news_channel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lab_news_4/repositories/news_repository/news_repository.dart';

class NewsApp extends StatefulWidget
{
  final NewsRepository news;

  const NewsApp({super.key, required this.news});

  @override
  NewsAppState createState() => NewsAppState();
}

class NewsAppState extends State<NewsApp>
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: 'Новости',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          onBackground: Colors.deepPurple,
        ),
        textTheme: GoogleFonts.manropeTextTheme(
          const TextTheme(
            bodyMedium: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            bodySmall: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            bodyLarge: TextStyle(
              color: Colors.black,
              fontSize: 22,
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
        ),
      ),
      home: Scaffold(
        body: NewsPage(
          channel: NewsChannel.habr,
          news: widget.news,
        ),
      ),
    );
  }
}

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  NewsRepository news = NewsRepository();
  await news.init();

  initializeDateFormatting('ru');

  NewsApp app = NewsApp(news: news);
  runApp(app);
}
