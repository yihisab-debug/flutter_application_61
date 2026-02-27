class Actor {
  final int id;
  final String name;
  final String? profilePath;
  final String knownForDepartment;
  final double popularity;
  final List<String> knownFor;

  Actor({
    required this.id,
    required this.name,
    required this.profilePath,
    required this.knownForDepartment,
    required this.popularity,
    required this.knownFor,
  });

  factory Actor.fromJson(Map<String, dynamic> json) {
    final knownForList = (json['known_for'] as List? ?? [])
        .map((item) => (item['title'] ?? item['name'] ?? '') as String)
        .where((s) => s.isNotEmpty)
        .toList();

    return Actor(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      profilePath: json['profile_path'],
      knownForDepartment: json['known_for_department'] ?? '',
      popularity: (json['popularity'] ?? 0).toDouble(),
      knownFor: knownForList,
    );
  }

  String get profileUrl {
    if (profilePath == null || profilePath!.isEmpty) {
      return "https://via.placeholder.com/150";
    }
    return "https://image.tmdb.org/t/p/w500$profilePath";
  }
}