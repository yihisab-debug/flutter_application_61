import 'package:flutter/material.dart';

class AppLanguage extends ChangeNotifier {
  String _language = 'en'; // 'en' или 'ru'

  String get language => _language;
  bool get isRussian => _language == 'ru';

  String get apiLanguage => _language == 'ru' ? 'ru-RU' : 'en-US';

  void toggle() {
    _language = _language == 'en' ? 'ru' : 'en';
    notifyListeners();
  }

  String get nowPlaying     => isRussian ? 'В прокате'     : 'Now Playing';
  String get popular        => isRussian ? 'Популярное'    : 'Popular';
  String get series         => isRussian ? 'Сериалы'       : 'Series';
  String get actors         => isRussian ? 'Актёры'        : 'Actors';
  String get topRated       => isRussian ? 'Топ рейтинга'  : 'Top Rated';
  String get searchHint     => isRussian ? 'Поиск...'      : 'Search...';
  String get searchResults  => isRussian ? 'Результаты'    : 'Search Results';
  String get noMovies       => isRussian ? 'Фильмы не найдены'   : 'No movies found';
  String get noShows        => isRussian ? 'Сериалы не найдены'  : 'No TV shows found';
  String get noActors       => isRussian ? 'Актёры не найдены'   : 'No actors found';
  String get overview       => isRussian ? 'Описание'      : 'Overview';
  String get noDescription  => isRussian ? 'Нет описания.' : 'No description available.';
  String get trailersTitle  => isRussian ? 'Трейлеры и видео' : 'Trailers & Videos';
  String get knownFor       => isRussian ? 'Известен по:'  : 'Known for:';
  String get knownForTitle  => isRussian ? 'Известен по'   : 'Known For';
  String get popularity     => isRussian ? 'Популярность'  : 'Popularity';
  String get appTitle       => isRussian ? 'Кино БД'       : 'Movie DB';
  String get popularActors  => isRussian ? 'Популярные актёры' : 'Popular Actors';
  String get results        => isRussian ? 'Результаты'    : 'Results';
}