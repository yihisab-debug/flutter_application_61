import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2340),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF2D3561), width: 1),
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(13)),
              child: Image.network(
                movie.posterUrl,
                width: 90,
                height: 130,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 90,
                  height: 130,
                  color: const Color(0xFF2D3561),
                  child: const Icon(Icons.broken_image, color: Colors.white38),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      movie.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [

                        const Icon(Icons.star, color: Color(0xFFFFD700), size: 14),

                        const SizedBox(width: 4),

                        Text(
                          movie.voteAverage.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Color(0xFFFFD700),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                      ],
                    ),

                    const SizedBox(height: 6),

                    if (movie.releaseDate.isNotEmpty)

                      Row(
                        children: [

                          const Icon(Icons.calendar_today, color: Colors.white38, size: 12),

                          const SizedBox(width: 4),

                          Text(
                            movie.releaseDate,
                            style: const TextStyle(color: Colors.white54, fontSize: 12),
                          ),

                        ],
                      ),

                    const SizedBox(height: 8),

                    Text(
                      movie.overview,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white60, fontSize: 12, height: 1.4),
                    ),
                    
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}