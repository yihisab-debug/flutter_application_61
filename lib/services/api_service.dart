import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../models/tv_show.dart';
import '../models/actor.dart';
import '../secrets.dart';

class ApiService {
  static const String _baseUrl = "https://api.themoviedb.org/3";

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $API_KEY',
    'Content-Type': 'application/json',
  };

  Future<Map<String, dynamic>> _getRaw(String endpoint) async {
    final urlBearer = Uri.parse("$_baseUrl$endpoint");
    final responseBearer = await http.get(urlBearer, headers: _headers);

    if (responseBearer.statusCode == 200) {
      return json.decode(responseBearer.body);
    }

    final separator = endpoint.contains('?') ? '&' : '?';
    final url = Uri.parse("$_baseUrl$endpoint${separator}api_key=$API_KEY");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }

    final errorBody = json.decode(response.body);
    throw Exception(
      errorBody['status_message'] ?? 'Request failed (${response.statusCode})',
    );
  }

  Future<List<Movie>> _getMovies(String endpoint) async {
    final data = await _getRaw(endpoint);
    final List results = data['results'];
    return results.map((movie) => Movie.fromJson(movie)).toList();
  }

  Future<List<TvShow>> _getTvShows(String endpoint) async {
    final data = await _getRaw(endpoint);
    final List results = data['results'];
    return results.map((show) => TvShow.fromJson(show)).toList();
  }

  Future<List<Actor>> _getActors(String endpoint) async {
    final data = await _getRaw(endpoint);
    final List results = data['results'];
    return results.map((actor) => Actor.fromJson(actor)).toList();
  }

  Future<List<Movie>> fetchNowPlaying() =>
      _getMovies('/movie/now_playing?language=en-US&page=1');

  Future<List<Movie>> fetchPopular() =>
      _getMovies('/movie/popular?language=en-US&page=1');

  Future<List<Movie>> searchMovies(String query) async {
    if (query.trim().isEmpty) return [];
    return _getMovies(
      '/search/movie?language=en-US&query=${Uri.encodeComponent(query)}&page=1',
    );
  }

  Future<List<TvShow>> fetchOnAirTv() =>
      _getTvShows('/tv/on_the_air?language=en-US&page=1');

  Future<List<TvShow>> fetchPopularTv() =>
      _getTvShows('/tv/popular?language=en-US&page=1');

  Future<List<TvShow>> searchTvShows(String query) async {
    if (query.trim().isEmpty) return [];
    return _getTvShows(
      '/search/tv?language=en-US&query=${Uri.encodeComponent(query)}&page=1',
    );
  }

  Future<List<Actor>> fetchPopularActors() =>
      _getActors('/person/popular?language=en-US&page=1');

  Future<List<Actor>> searchActors(String query) async {
    if (query.trim().isEmpty) return [];
    return _getActors(
      '/search/person?language=en-US&query=${Uri.encodeComponent(query)}&page=1',
    );
  }
}