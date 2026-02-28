import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/movie.dart';
import '../models/tv_show.dart';
import '../models/actor.dart';
import '../widgets/movie_card.dart';
import '../widgets/tv_show_card.dart';
import '../widgets/actor_card.dart';
import '../widgets/search_bar_widget.dart';
import '../app_languages.dart';
import 'movie_details_page.dart';
import 'tv_show_details_page.dart';
import 'actor_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Movie>> _nowPlayingMovies;
  late Future<List<Movie>> _popularMovies;
  late Future<List<TvShow>> _popularTvShows;
  late Future<List<Actor>> _popularActors;

  bool _isSearching = false;
  Future<List<Movie>>? _movieSearchResults;
  Future<List<TvShow>>? _tvSearchResults;
  Future<List<Actor>>? _actorSearchResults;

  String _lastLanguage = '';

  ApiService _api(BuildContext context) {
    final lang = context.read<AppLanguage>().apiLanguage;
    return ApiService(language: lang);
  }

  void _loadData(String language) {
    final api = ApiService(language: language);
    _nowPlayingMovies = api.fetchNowPlaying();
    _popularMovies    = api.fetchPopular();
    _popularTvShows   = api.fetchPopularTv();
    _popularActors    = api.fetchPopularActors();
    _lastLanguage = language;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData('en-US');

    _tabController.addListener(() {
      if (_isSearching) _onClear();
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final lang = context.read<AppLanguage>().apiLanguage;
    if (lang != _lastLanguage) {
      setState(() {
        _onClear();
        _loadData(lang);
      });
    }
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
    final api = _api(context);
    setState(() {
      _isSearching = true;
      _movieSearchResults = api.searchMovies(query);
      _tvSearchResults    = api.searchTvShows(query);
      _actorSearchResults = api.searchActors(query);
    });
  }

  void _onClear() {
    setState(() {
      _isSearching = false;
      _movieSearchResults = null;
      _tvSearchResults    = null;
      _actorSearchResults = null;
    });
  }

  void _openMovie(BuildContext context, Movie movie) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => MovieDetailsPage(movie: movie)));
  }

  void _openTvShow(BuildContext context, TvShow show) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => TvShowDetailsPage(show: show)));
  }

  void _openActor(BuildContext context, Actor actor) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => ActorDetailsPage(actor: actor)));
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

  Widget _buildHorizontalCarousel(List<Movie> movies, AppLanguage lang) {
    final topMovies = (movies.toList()
          ..sort((a, b) => b.voteAverage.compareTo(a.voteAverage)))
        .take(10)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        _sectionHeader(lang.topRated),

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

        _sectionHeader(_tabController.index == 0 ? lang.nowPlaying : lang.popular),

      ],
    );
  }

  Widget _buildTvHorizontalCarousel(List<TvShow> shows, AppLanguage lang) {
    final topShows = (shows.toList()
          ..sort((a, b) => b.voteAverage.compareTo(a.voteAverage)))
        .take(10)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        _sectionHeader(lang.topRated),

        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16, right: 8),
            itemCount: topShows.length,
            itemBuilder: (context, index) {
              final show = topShows[index];
              return _HorizontalTvPosterCard(show: show);
            },
          ),
        ),

        const SizedBox(height: 16),

        _sectionHeader(lang.popular),

      ],
    );
  }

  Widget _buildMovieTabContent(Future<List<Movie>> future,
      {bool isSearch = false, required AppLanguage lang}) {
    return FutureBuilder<List<Movie>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFF01B4E4)));
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

              const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),

              const SizedBox(height: 16),

              Text("Error: ${snapshot.error}",
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center),

            ]),
          );
        }
        final movies = snapshot.data ?? [];
        if (movies.isEmpty) {
          return Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

              const Icon(Icons.search_off, color: Colors.white38, size: 48),

              const SizedBox(height: 16),

              Text(lang.noMovies,
                  style: const TextStyle(color: Colors.white54, fontSize: 16)),

            ]),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 16),
          itemCount: movies.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return isSearch
                  ? _sectionHeader(lang.results)
                  : _buildHorizontalCarousel(movies, lang);
            }
            final movie = movies[index - 1];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MovieCard(
                  movie: movie, onTap: () => _openMovie(context, movie)),
            );
          },
        );

      },
    );
  }

  Widget _buildTvTabContent(Future<List<TvShow>> future,
      {bool isSearch = false, required AppLanguage lang}) {
    return FutureBuilder<List<TvShow>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFF01B4E4)));
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

              const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),

              const SizedBox(height: 16),

              Text("Error: ${snapshot.error}",
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center),

            ]),
          );
        }
        final shows = snapshot.data ?? [];
        if (shows.isEmpty) {
          return Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

              const Icon(Icons.search_off, color: Colors.white38, size: 48),

              const SizedBox(height: 16),

              Text(lang.noShows,
                  style: const TextStyle(color: Colors.white54, fontSize: 16)),

            ]),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 16),
          itemCount: shows.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return isSearch
                  ? _sectionHeader(lang.results)
                  : _buildTvHorizontalCarousel(shows, lang);
            }
            final show = shows[index - 1];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TvShowCard(
                  show: show, onTap: () => _openTvShow(context, show)),
            );
          },
        );

      },
    );
  }

  Widget _buildActorTabContent(Future<List<Actor>> future,
      {bool isSearch = false, required AppLanguage lang}) {
    return FutureBuilder<List<Actor>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFF01B4E4)));
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

              const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),

              const SizedBox(height: 16),

              Text("Error: ${snapshot.error}",
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center),

            ]),
          );
        }

        final actors = snapshot.data ?? [];
        if (actors.isEmpty) {
          return Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

              const Icon(Icons.person_off, color: Colors.white38, size: 48),

              const SizedBox(height: 16),

              Text(lang.noActors,
                  style: const TextStyle(color: Colors.white54, fontSize: 16)),

            ]),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 16),
          itemCount: actors.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _sectionHeader(
                  isSearch ? lang.results : lang.popularActors);
            }
            final actor = actors[index - 1];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ActorCard(
                  actor: actor, onTap: () => _openActor(context, actor)),
            );
          },
        );

      },
    );
  }

  Widget _buildCurrentTabContent(AppLanguage lang) {
    if (_isSearching) {
      switch (_tabController.index) {
        case 0:
        case 1:
          return _buildMovieTabContent(_movieSearchResults!,
              isSearch: true, lang: lang);
        case 2:
          return _buildTvTabContent(_tvSearchResults!,
              isSearch: true, lang: lang);
        case 3:
          return _buildActorTabContent(_actorSearchResults!,
              isSearch: true, lang: lang);
      }
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<AppLanguage>();

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0F1E),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [

            const Icon(Icons.movie_filter, color: Color(0xFF01B4E4), size: 28),

            const SizedBox(width: 8),

            Text(
              _isSearching ? lang.searchResults : lang.appTitle,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),

          ],
        ),
        actions: [

          GestureDetector(
            onTap: () {
              context.read<AppLanguage>().toggle();
            },

            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(

                color: const Color(0xFF1E2340),

                borderRadius: BorderRadius.circular(20),

                border: Border.all(color: const Color(0xFF01B4E4), width: 1.5),

              ),

              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Text(
                    lang.isRussian ? '🇷🇺' : '🇺🇸',
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(width: 4),

                  Text(
                    lang.isRussian ? 'RU' : 'EN',
                    style: const TextStyle(
                      color: Color(0xFF01B4E4),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),

                ],
              ),

            ),
          ),
        ],

        bottom: _isSearching
            ? null
            : TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xFF01B4E4),
                indicatorWeight: 3,
                labelColor: const Color(0xFF01B4E4),
                unselectedLabelColor: Colors.white54,
                tabAlignment: TabAlignment.fill,
                labelPadding: EdgeInsets.zero,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),

                tabs: [

                  Tab(
                    icon: const Icon(Icons.play_circle_outline, size: 16),
                    text: lang.nowPlaying,
                    iconMargin: const EdgeInsets.only(bottom: 2),
                  ),

                  Tab(
                    icon: const Icon(Icons.local_fire_department_outlined, size: 16),
                    text: lang.popular,
                    iconMargin: const EdgeInsets.only(bottom: 2),
                  ),

                  Tab(
                    icon: const Icon(Icons.tv, size: 16),
                    text: lang.series,
                    iconMargin: const EdgeInsets.only(bottom: 2),
                  ),

                  Tab(
                    icon: const Icon(Icons.people_outline, size: 16),
                    text: lang.actors,
                    iconMargin: const EdgeInsets.only(bottom: 2),
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
                ? _buildCurrentTabContent(lang)
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildMovieTabContent(_nowPlayingMovies, lang: lang),
                      _buildMovieTabContent(_popularMovies, lang: lang),
                      _buildTvTabContent(_popularTvShows, lang: lang),
                      _buildActorTabContent(_popularActors, lang: lang),
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

class _HorizontalTvPosterCard extends StatelessWidget {
  final TvShow show;

  const _HorizontalTvPosterCard({required this.show});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                    show.posterUrl,
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
                            show.voteAverage.toStringAsFixed(1),
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
              show.name,
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
    );
  }
}