class Movie {
  final int id;
  final String title;
  final String? posterPath;
  final String overview;
  final String releaseDate;
  final double voteAverage;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.releaseDate,
    required this.voteAverage,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      posterPath: json['poster_path'],
      overview: json['overview'] ?? '',
      releaseDate: json['release_date'] ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
    );
  }

  String get posterUrl {
    if (posterPath == null || posterPath!.isEmpty) {
      return "https://via.placeholder.com/150";
    }
    return "https://image.tmdb.org/t/p/w500$posterPath";
  }
}