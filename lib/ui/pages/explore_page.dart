import 'package:flutter/material.dart';
import 'viewer_room.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  final List<Map<String, String>> vjs = const [
    {"name": "VJ Miko1", "status": "LIVE"},
    {"name": "VJ Miko2", "status": "PK"},
    {"name": "VJ Miko3", "status": "LIVE"},
    {"name": "VJ Miko4", "status": "PK"},
  ];

  Color cardColor(String status) {
    switch (status) {
      case 'LIVE':
        return const Color(0xFF181818);
      case 'PK':
        return const Color(0xFF2A002A);
      default:
        return Colors.grey.shade800;
    }
  }

  Color badgeColor(String status) {
    switch (status) {
      case 'LIVE':
        return Colors.redAccent;
      case 'PK':
        return Colors.purpleAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: vjs.length,
        itemBuilder: (context, index) {
          final vj = vjs[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ViewerRoomPage(
                    vjName: vj['name']!,
                    status: vj['status']!,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: cardColor(vj['status']!),
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: AssetImage('assets/images/vj_preview.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeColor(vj['status']!),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        vj['status']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Text(
                      vj['name']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
