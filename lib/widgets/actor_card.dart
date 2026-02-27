import 'package:flutter/material.dart';
import '../models/actor.dart';

class ActorCard extends StatelessWidget {
  final Actor actor;
  final VoidCallback onTap;

  const ActorCard({
    super.key,
    required this.actor,
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
                actor.profileUrl,
                width: 90,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 90,
                  height: 120,

                  color: const Color(0xFF2D3561),

                  child: const Icon(Icons.person, color: Colors.white38, size: 40),

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
                      actor.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    if (actor.knownForDepartment.isNotEmpty)

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF01B4E4).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFF01B4E4).withOpacity(0.4)),
                        ),

                        child: Text(
                          actor.knownForDepartment,
                          style: const TextStyle(
                            color: Color(0xFF01B4E4),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                      ),

                    const SizedBox(height: 8),

                    if (actor.knownFor.isNotEmpty) ...[

                      const Text(
                        'Known for:',
                        style: TextStyle(color: Colors.white38, fontSize: 11),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        actor.knownFor.take(3).join(', '),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),

                    ],
                    
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