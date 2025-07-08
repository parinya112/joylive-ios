import 'package:flutter/material.dart';
import 'ui/pages/viewer_room.dart';

void main() {
  runApp(const JoyLivethApp());
}

class JoyLivethApp extends StatelessWidget {
  const JoyLivethApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JOY LIVETH',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Prompt',
        primaryColor: Colors.pinkAccent,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      home: const MainPage(),
      routes: {
        '/viewer': (context) => const ViewerRoomPage(
              vjName: 'VJ Sample',
              status: 'LIVE',
            ),
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    const ExplorePage(),
    const Placeholder(), // สำหรับ Live / Gift
    const Placeholder(), // สำหรับ Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => setState(() => selectedIndex = index),
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'Live'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
        ],
      ),
    );
  }
}

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> rooms = [
      {
        'cover': 'https://picsum.photos/300/500?random=1',
        'avatar': 'https://i.pravatar.cc/100?img=1',
        'name': 'น้องน้ำขิง',
      },
      {
        'cover': 'https://picsum.photos/300/500?random=2',
        'avatar': 'https://i.pravatar.cc/100?img=2',
        'name': 'VJ มายมิ้นท์',
      },
      {
        'cover': 'https://picsum.photos/300/500?random=3',
        'avatar': 'https://i.pravatar.cc/100?img=3',
        'name': 'VJ แพรว',
      },
      {
        'cover': 'https://picsum.photos/300/500?random=4',
        'avatar': 'https://i.pravatar.cc/100?img=4',
        'name': 'VJ ลูกหว้า',
      },
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.builder(
          itemCount: rooms.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index) {
            final room = rooms[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/viewer',
                  arguments: {
                    'vjName': room['name'],
                    'status': 'LIVE',
                  },
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        room['cover']!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.black.withOpacity(0.2),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(room['avatar']!),
                              radius: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                room['name']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
