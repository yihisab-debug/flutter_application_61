import 'package:flutter/material.dart';
import '../models/actor.dart';

class ActorDetailsPage extends StatelessWidget {
  final Actor actor;

  const ActorDetailsPage({required this.actor, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0F1E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),

        title: Text(
          actor.name,
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
                    actor.profileUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 400,
                      color: const Color(0xFF1E2340),

                      child: const Center(
                        child: Icon(Icons.person, color: Colors.white38, size: 80),
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
                    actor.name,
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
                      if (actor.knownForDepartment.isNotEmpty)

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF01B4E4).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFF01B4E4), width: 1.5),
                          ),

                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              const Icon(Icons.work_outline, color: Color(0xFF01B4E4), size: 14),

                              const SizedBox(width: 6),

                              Text(
                                actor.knownForDepartment,
                                style: const TextStyle(
                                  color: Color(0xFF01B4E4),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),

                            ],
                          ),
                        ),

                      const SizedBox(width: 12),

                      Row(
                        children: [

                          const Icon(Icons.trending_up, color: Colors.white54, size: 14),

                          const SizedBox(width: 6),

                          Text(
                            'Popularity: ${actor.popularity.toStringAsFixed(1)}',
                            style: const TextStyle(color: Colors.white54, fontSize: 14),
                          ),

                        ],
                      ),

                    ],
                  ),

                  if (actor.knownFor.isNotEmpty) ...[

                    const SizedBox(height: 20),

                    const Text(
                      "Known For",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    ...actor.knownFor.map(
                      (title) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [

                            const Icon(Icons.play_circle_outline,
                                color: Color(0xFF01B4E4), size: 16),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                  height: 1.4,
                                ),
                              ),
                            ),

                          ],
                        ),
                        
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}