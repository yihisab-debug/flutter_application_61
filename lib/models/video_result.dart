class VideoResult {
  final String id;
  final String name;
  final String key;
  final String site;
  final String type;
  final bool official;

  VideoResult({
    required this.id,
    required this.name,
    required this.key,
    required this.site,
    required this.type,
    required this.official,
  });

  factory VideoResult.fromJson(Map<String, dynamic> json) {
    return VideoResult(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      key: json['key'] ?? '',
      site: json['site'] ?? '',
      type: json['type'] ?? '',
      official: json['official'] ?? false,
    );
  }

  bool get isYouTube => site == 'YouTube';

  String get youtubeUrl => 'https://www.youtube.com/watch?v=$key';

  String get youtubeThumbnail =>
      'https://img.youtube.com/vi/$key/hqdefault.jpg';
}