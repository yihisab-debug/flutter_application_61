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

  Future<List<Movie>> fetchNowPlaying() async {
    final urlBearer = Uri.parse("$_baseUrl/movie/now_playing?language=en-US&page=1");
    final responseBearer = await http.get(urlBearer, headers: _headers);

    if (responseBearer.statusCode == 200) {
      final jsonData = json.decode(responseBearer.body);
      final List results = jsonData['results'];
      return results.map((movie) => Movie.fromJson(movie)).toList();
    }

    final url = Uri.parse(
      "$_baseUrl/movie/now_playing?api_key=$API_KEY&language=en-US&page=1",
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List results = jsonData['results'];
      return results.map((movie) => Movie.fromJson(movie)).toList();
    }

    final errorBody = json.decode(response.body);
    throw Exception(
      errorBody['status_message'] ?? 'Failed to load movies (${response.statusCode})',
    );
  }

  Future<List<Movie>> searchMovies(String query) async {
    if (query.trim().isEmpty) return [];

    final urlBearer = Uri.parse(
      "$_baseUrl/search/movie?language=en-US&query=${Uri.encodeComponent(query)}&page=1",
    );
    final responseBearer = await http.get(urlBearer, headers: _headers);

    if (responseBearer.statusCode == 200) {
      final jsonData = json.decode(responseBearer.body);
      final List results = jsonData['results'];
      return results.map((movie) => Movie.fromJson(movie)).toList();
    }

    final url = Uri.parse(
      "$_baseUrl/search/movie?api_key=$API_KEY&language=en-US&query=${Uri.encodeComponent(query)}&page=1",
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List results = jsonData['results'];
      return results.map((movie) => Movie.fromJson(movie)).toList();
    }

    final errorBody = json.decode(response.body);
    throw Exception(
      errorBody['status_message'] ?? 'Search failed (${response.statusCode})',
    );
  }
}