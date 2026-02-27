class TvShow {
  final int id;
  final String name;
  final String? posterPath;
  final String overview;
  final String firstAirDate;
  final double voteAverage;

  TvShow({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.overview,
    required this.firstAirDate,
    required this.voteAverage,
  });

  factory TvShow.fromJson(Map<String, dynamic> json) {
    return TvShow(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      posterPath: json['poster_path'],
      overview: json['overview'] ?? '',
      firstAirDate: json['first_air_date'] ?? '',
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