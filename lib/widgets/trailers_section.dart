import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/video_result.dart';

class TrailersSection extends StatelessWidget {
  final Future<List<VideoResult>> future;

  const TrailersSection({super.key, required this.future});

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<VideoResult>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: CircularProgressIndicator(color: Color(0xFF01B4E4)),
            ),
          );
        }

        final videos = snapshot.data ?? [];
        if (videos.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 24),

            const Text(
              'Trailers & Videos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final video = videos[index];
                  return _TrailerCard(
                    video: video,
                    onTap: () => _open(video.youtubeUrl),
                  );
                },
              ),
            ),

          ],
        );
      },
    );
  }
}

class _TrailerCard extends StatelessWidget {
  final VideoResult video;
  final VoidCallback onTap;

  const _TrailerCard({required this.video, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF1E2340),
          border: Border.all(color: const Color(0xFF2D3561), width: 1),
        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [

              Image.network(
                video.youtubeThumbnail,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(

                  color: const Color(0xFF1E2340),

                  child: const Icon(Icons.movie,
                      color: Colors.white24, size: 40),

                ),
              ),

              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.05),
                      Colors.black.withOpacity(0.72),
                    ],
                  ),
                ),
              ),

              Center(
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.4),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),

                  child: const Icon(Icons.play_arrow,
                      color: Colors.white, size: 30),

                ),
              ),

              Positioned(
                left: 8,
                right: 8,
                bottom: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: video.type == 'Trailer'
                            ? Colors.red.withOpacity(0.85)
                            : Colors.blueGrey.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(4),
                      ),

                      child: Text(
                        video.type,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      video.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}