import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const JoyLiveApp());

class JoyLiveApp extends StatelessWidget {
  const JoyLiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JOY LIVETH',
      theme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.promptTextTheme(
          ThemeData.dark().textTheme,
        ),
        scaffoldBackgroundColor: Colors.black,
      ),
      debugShowCheckedModeBanner: false,
      home: const ExplorePage(),
    );
  }
}

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

  Color statusColor(String status) {
    switch (status) {
      case 'LIVE':
        return Colors.redAccent;
      case 'PK':
        return Colors.purple;
      case 'Audio':
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore", style: TextStyle(fontSize: 28)),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        padding: const EdgeInsets.all(12),
        children: vjs.map((vj) {
          return Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // 🔳 Placeholder ภาพ
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey.shade800,
                    ),
                    child: const Center(
                      child: Icon(Icons.person, size: 48, color: Colors.white24),
                    ),
                  ),
                ),
                // 🔴 Badge สถานะ
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: statusColor(vj['status']!),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: statusColor(vj['status']!).withOpacity(0.6),
                          blurRadius: 10,
                        ),
                      ],
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
                // 👤 ชื่อ VJ
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Text(
                    vj['name']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(blurRadius: 2, color: Colors.black),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.amberAccent,
        unselectedItemColor: Colors.white38,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'Live'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          // TODO: Navigation future
        },
      ),
    );
  }
}
