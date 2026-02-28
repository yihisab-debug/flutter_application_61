import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../models/video_result.dart';
import '../services/api_service.dart';
import '../widgets/trailers_section.dart';

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailsPage({required this.movie, super.key});

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  final ApiService _apiService = ApiService();
  late final Future<List<VideoResult>> _videosFuture;

  @override
  void initState() {
    super.initState();
    _videosFuture = _apiService.fetchMovieVideos(widget.movie.id);
  }

  Color _ratingColor(double rating) {
    if (rating >= 7) return const Color(0xFF21D07A);
    if (rating >= 5) return const Color(0xFFD2D531);
    return const Color(0xFFDB2360);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0F1E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.movie.title,
          style: const TextStyle(color: Colors.white, fontSize: 18),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Stack(
              children: [

                SizedBox(
                  width: double.infinity,
                  height: 400,
                  child: Image.network(
                    widget.movie.posterUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 400,
                      color: const Color(0xFF1E2340),
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.white38, size: 64),
                      ),
                    ),
                  ),
                ),

                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.5, 1.0],
                        colors: [Colors.transparent, Color(0xFF0D0F1E)],
                      ),
                    ),
                  ),
                ),

              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    widget.movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _ratingColor(widget.movie.voteAverage).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: _ratingColor(widget.movie.voteAverage), width: 1.5),
                        ),

                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            Icon(Icons.star,
                                color: _ratingColor(widget.movie.voteAverage), size: 16),
                            const SizedBox(width: 4),

                            Text(
                              widget.movie.voteAverage.toStringAsFixed(1),
                              style: TextStyle(
                                color: _ratingColor(widget.movie.voteAverage),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),

                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      if (widget.movie.releaseDate.isNotEmpty)

                        Row(
                          children: [
                            const Icon(Icons.calendar_today, color: Colors.white54, size: 14),
                            const SizedBox(width: 6),
                            Text(
                              widget.movie.releaseDate,
                              style: const TextStyle(color: Colors.white54, fontSize: 14),
                            ),
                          ],
                        ),

                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Overview',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    widget.movie.overview.isEmpty
                        ? 'No description available.'
                        : widget.movie.overview,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),

                  TrailersSection(future: _videosFuture),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}