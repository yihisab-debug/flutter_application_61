import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../secrets.dart';

class ApiService {
  static const String _baseUrl = "https://api.themoviedb.org/3";

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $API_KEY',
    'Content-Type': 'application/json',
  };

  Future<List<Movie>> _getMovies(String endpoint) async {
    final urlBearer = Uri.parse("$_baseUrl$endpoint");
    final responseBearer = await http.get(urlBearer, headers: _headers);

    if (responseBearer.statusCode == 200) {
      final jsonData = json.decode(responseBearer.body);
      final List results = jsonData['results'];
      return results.map((movie) => Movie.fromJson(movie)).toList();
    }

    final separator = endpoint.contains('?') ? '&' : '?';
    final url = Uri.parse("$_baseUrl$endpoint${separator}api_key=$API_KEY");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List results = jsonData['results'];
      return results.map((movie) => Movie.fromJson(movie)).toList();
    }

    final errorBody = json.decode(response.body);
    throw Exception(
      errorBody['status_message'] ?? 'Request failed (${response.statusCode})',
    );
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
}