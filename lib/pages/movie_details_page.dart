import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieDetailsPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailsPage({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Image.network(movie.posterUrl),

            const SizedBox(height: 16),

            Text(
              movie.overview,
              style: const TextStyle(fontSize: 16),
            ),
            
          ],
        ),
      ),
    );
  }
}