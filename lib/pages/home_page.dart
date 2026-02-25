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

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();

  late TabController _tabController;
  late Future<List<Movie>> _nowPlayingMovies;
  late Future<List<Movie>> _popularMovies;

  bool _isSearching = false;
  Future<List<Movie>>? _searchResults;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _nowPlayingMovies = _apiService.fetchNowPlaying();
    _popularMovies = _apiService.fetchPopular();

    _tabController.addListener(() {
      if (_isSearching) _onClear();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.trim().isEmpty) {
      _onClear();
      return;
    }
    setState(() {
      _isSearching = true;
      _searchResults = _apiService.searchMovies(query);
    });
  }

  void _onClear() {
    setState(() {
      _isSearching = false;
      _searchResults = null;
    });
  }

  Future<List<Movie>> _currentMovies() {
    if (_isSearching) return _searchResults!;
    return _tabController.index == 0 ? _nowPlayingMovies : _popularMovies;
  }

  void _openMovie(BuildContext context, Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MovieDetailsPage(movie: movie)),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 16,
            decoration: BoxDecoration(
              color: const Color(0xFF01B4E4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalCarousel(List<Movie> movies) {
    final topMovies = (movies.toList()
          ..sort((a, b) => b.voteAverage.compareTo(a.voteAverage)))
        .take(10)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Top Rated'),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16, right: 8),
            itemCount: topMovies.length,
            itemBuilder: (context, index) {
              final movie = topMovies[index];
              return _HorizontalPosterCard(
                movie: movie,
                onTap: () => _openMovie(context, movie),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        _sectionHeader(
          _tabController.index == 0 ? 'Now Playing' : 'Popular',
        ),
      ],
    );
  }

  Widget _buildTabContent() {
    return FutureBuilder<List<Movie>>(
      future: _currentMovies(),
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

        final movies = snapshot.data ?? [];

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
          padding: const EdgeInsets.only(bottom: 16),

          itemCount: movies.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _isSearching
                  ? _sectionHeader('Results')
                  : _buildHorizontalCarousel(movies);
            }
            final movie = movies[index - 1];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MovieCard(
                movie: movie,
                onTap: () => _openMovie(context, movie),
              ),
            );
          },
        );
      },
    );
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
              _isSearching ? 'Search Results' : 'Movie DB',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),

          ],
        ),
        bottom: _isSearching
            ? null
            : TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xFF01B4E4),
                indicatorWeight: 3,
                labelColor: const Color(0xFF01B4E4),
                unselectedLabelColor: Colors.white54,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                tabs: const [

                  Tab(
                    icon: Icon(Icons.play_circle_outline, size: 18),
                    text: 'Now Playing',
                    iconMargin: EdgeInsets.only(bottom: 2),
                  ),

                  Tab(
                    icon: Icon(Icons.local_fire_department_outlined, size: 18),
                    text: 'Popular',
                    iconMargin: EdgeInsets.only(bottom: 2),
                  ),
                  
                ],
              ),
      ),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: SearchBarWidget(
              onSearch: _onSearch,
              onClear: _onClear,
            ),
          ),

          Expanded(
            child: _isSearching
                ? _buildTabContent()
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTabContent(),
                      _buildTabContent(),
                    ],
                  ),
          ),

        ],
      ),
    );
  }
}

class _HorizontalPosterCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const _HorizontalPosterCard({required this.movie, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 110,
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [

                    Image.network(
                      movie.posterUrl,
                      width: 110,
                      height: 155,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 110,
                        height: 155,
                        color: const Color(0xFF1E2340),

                        child: const Icon(Icons.broken_image,
                            color: Colors.white38, size: 32),

                      ),
                    ),

                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.72),
                          borderRadius: BorderRadius.circular(6),
                        ),

                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            const Icon(Icons.star,
                                color: Color(0xFFFFD700), size: 10),

                            const SizedBox(width: 2),

                            Text(
                              movie.voteAverage.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                          ],
                        ),

                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 5),

              Text(
                movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}