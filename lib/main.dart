import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const JoyLiveApp());

class JoyLiveApp extends StatelessWidget {
  const JoyLiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JOY LIVETH',
      theme: ThemeData.light().copyWith(
        textTheme: GoogleFonts.promptTextTheme(ThemeData.light().textTheme),
        scaffoldBackgroundColor: const Color(0xFFFDF6F0),
      ),
      debugShowCheckedModeBanner: false,
      home: const MainTabs(),
    );
  }
}

class MainTabs extends StatefulWidget {
  const MainTabs({super.key});
  @override
  State<MainTabs> createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    ExplorePage(),
    PlaceholderWidget("Live (VJ)"),
    WalletPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFFF7EFE8),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'Live'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  final List<Map<String, String>> vjs = const [
    {"name": "VJ Miko1", "status": "LIVE"},
    {"name": "VJ Miko2", "status": "PK"},
    {"name": "VJ Miko3", "status": "Audio"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore", style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        padding: const EdgeInsets.all(12),
        children: vjs.map((vj) {
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ViewerRoomPage(
                  vjName: vj['name']!,
                  status: vj['status']!,
                ),
              ),
            ),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _cardColor(vj['status']!),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 8)],
              ),
              child: Stack(
                children: [
                  const Positioned.fill(
                    child: Center(child: Icon(Icons.person_outline, size: 48, color: Colors.black26)),
                  ),
                  Positioned(top: 10, left: 10, child: _badge(vj['status']!)),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Text(
                      vj['name']!,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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

  Color _cardColor(String status) {
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

  Widget _badge(String status) {
    Color color;
    switch (status) {
      case 'LIVE':
        color = Colors.redAccent;
        break;
      case 'PK':
        color = Colors.purpleAccent;
        break;
      case 'Audio':
        color = Colors.lightBlue;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 12)),
    );
  }
}

class ViewerRoomPage extends StatefulWidget {
  final String vjName;
  final String status;

  const ViewerRoomPage({
    super.key,
    required this.vjName,
    required this.status,
  });

  @override
  State<ViewerRoomPage> createState() => _ViewerRoomPageState();
}

class _ViewerRoomPageState extends State<ViewerRoomPage> {
  int userLevel = 2;
  int userExp = 80;
  int userCoins = 1230;
  int vjEarned = 0;

  final TextEditingController _chatController = TextEditingController();
  final List<String> chatMessages = [];
  final List<String> giftAnimations = [];

  void _sendChat() {
    if (_chatController.text.trim().isEmpty) return;
    setState(() {
      chatMessages.add('🎖 LV$userLevel: ${_chatController.text.trim()}');
      _chatController.clear();
    });
  }

  void _sendGift() {
    setState(() {
      int giftValue = 499;
      userCoins -= giftValue;
      userExp += 20;
      if (userExp >= 100) {
        userLevel++;
        userExp -= 100;
      }
      vjEarned = giftValue;
      giftAnimations.add('🎁 ส่งของขวัญ $giftValue coin ให้ ${widget.vjName}!');
    });

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        vjEarned = 0;
        if (giftAnimations.isNotEmpty) {
          giftAnimations.removeAt(0);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // VJ Info Center
          Center(
            child: Text('${widget.vjName} - ${widget.status}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // Exit button
          Positioned(
            top: 40,
            right: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 25,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // Viewer LV
          Positioned(
            top: 40,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(20)),
              child: Text('LV $userLevel', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),

          // Coin Display
          Positioned(
            top: 40,
            left: 100,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.amber.shade100, borderRadius: BorderRadius.circular(20)),
              child: Text('💰 $userCoins coin', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),

          // VJ Earn Display
          if (vjEarned > 0)
            Positioned(
              top: 70,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text('🎉 ${widget.vjName} ได้รับ $vjEarned coin!',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),

          // Gift Animations
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: Column(
              children: giftAnimations.map((text) => AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: 1.0,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(text, style: const TextStyle(fontSize: 14)),
                ),
              )).toList(),
            ),
          ),

          // Chat Overlay
          Positioned(
            bottom: 150,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: chatMessages.map((msg) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Text(msg, style: const TextStyle(color: Colors.white, fontSize: 12)),
                ),
              )).toList(),
            ),
          ),

          // Bottom bar: EXP bar + Gift + Chat
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: userExp.clamp(0, 100) / 100,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.purpleAccent),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _sendGift,
                      icon: const Icon(Icons.card_giftcard, color: Colors.red),
                      label: const Text("ส่งของขวัญ"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.purple,
                        backgroundColor: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _chatController,
                        decoration: InputDecoration(
                          hintText: "พิมพ์แชท...",
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: (_) => _sendChat(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _sendChat,
                      child: const Text("ส่ง"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Wallet Page (เติม coin / QR)", style: TextStyle(fontSize: 20))),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Profile Page", style: TextStyle(fontSize: 20))),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final String title;
  const PlaceholderWidget(this.title, {super.key});
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(title, style: const TextStyle(fontSize: 24)));
  }
}
