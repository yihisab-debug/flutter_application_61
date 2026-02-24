import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/movie.dart';
import '../widgets/movie_card.dart';
import '../widgets/search_bar_widget.dart';
import 'movie_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  late Future<List<Movie>> _movies;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _movies = _apiService.fetchNowPlaying();
  }

  void _onSearch(String query) {
    if (query.trim().isEmpty) {
      _onClear();
      return;
    }
    setState(() {
      _isSearching = true;
      _movies = _apiService.searchMovies(query);
    });
  }

  void _onClear() {
    setState(() {
      _isSearching = false;
      _movies = _apiService.fetchNowPlaying();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0F1E),
        elevation: 0,

        title: Row(
          children: [

            const Icon(Icons.movie_filter, color: Color(0xFF01B4E4), size: 28),

            const SizedBox(width: 8),

            Text(
              _isSearching ? 'Search Results' : 'Now Playing',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),

          ],
        ),
      ),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: SearchBarWidget(
              onSearch: _onSearch,
              onClear: _onClear,
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Movie>>(
              future: _movies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF01B4E4)),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),

                        const SizedBox(height: 16),

                        Text(
                          "Error: ${snapshot.error}",
                          style: const TextStyle(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),

                      ],
                    ),
                  );
                }

                final movies = snapshot.data!;

                if (movies.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Icon(Icons.search_off, color: Colors.white38, size: 48),

                        SizedBox(height: 16),

                        Text(
                          "No movies found",
                          style: TextStyle(color: Colors.white54, fontSize: 16),
                        ),

                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    return MovieCard(
                      movie: movies[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MovieDetailsPage(movie: movies[index]),
                          ),
                        );
                      },
                    );
                  },
                );
                
              },
            ),
          ),
        ],
      ),
    );
  }
}