import 'package:flutter/material.dart';
import '../pages/viewer_room.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  final List<Map<String, String>> vjs = const [
    {"name": "VJ Miko1", "status": "LIVE"},
    {"name": "VJ Miko2", "status": "PK"},
    {"name": "VJ Miko3", "status": "Audio"},
    {"name": "VJ Miko4", "status": "LIVE"},
    {"name": "VJ Miko5", "status": "PK"},
    {"name": "VJ Miko6", "status": "Audio"},
  ];

  Color cardColor(String status) {
    switch (status) {
      case 'LIVE':
        return const Color(0xFFFFE9D2);
      case 'PK':
        return const Color(0xFFFFE0F7);
      case 'Audio':
        return const Color(0xFFE0F7FF);
      default:
        return const Color(0xFFFDF6F0);
    }
  }

  Color badgeColor(String status) {
    switch (status) {
      case 'LIVE':
        return Colors.redAccent;
      case 'PK':
        return Colors.purpleAccent;
      case 'Audio':
        return Colors.lightBlue;
      default:
        return Colors.deepOrange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Explore", style: TextStyle(fontSize: 28, color: Colors.black87)),
        elevation: 0,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        padding: const EdgeInsets.all(12),
        children: vjs.map((vj) {
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
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: cardColor(vj['status']!),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  const Positioned.fill(
                    child: Center(
                      child: Icon(Icons.person_outline, size: 48, color: Colors.black26),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
