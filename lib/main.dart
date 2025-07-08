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
              MaterialPageRoute(builder: (_) => ViewerRoom(vjName: vj['name']!, status: vj['status']!)),
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
                  Positioned(
                    top: 10,
                    left: 10,
                    child: _badge(vj['status']!),
                  ),
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
      case 'LIVE': return const Color(0xFFFFE9D2);
      case 'PK': return const Color(0xFFFFE0F7);
      case 'Audio': return const Color(0xFFE0F7FF);
      default: return const Color(0xFFFDF6F0);
    }
  }

  Widget _badge(String status) {
    Color color;
    switch (status) {
      case 'LIVE': color = Colors.redAccent; break;
      case 'PK': color = Colors.purpleAccent; break;
      case 'Audio': color = Colors.lightBlue; break;
      default: color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 12)),
    );
  }
}

class ViewerRoom extends StatefulWidget {
  final String vjName;
  final String status;
  const ViewerRoom({super.key, required this.vjName, required this.status});

  @override
  State<ViewerRoom> createState() => _ViewerRoomState();
}

class _ViewerRoomState extends State<ViewerRoom> {
  int userLevel = 1;
  int userExp = 0;
  final int expPerLevel = 100;
  final TextEditingController _chatController = TextEditingController();
  final List<String> chatMessages = [];

  void _sendGift() {
    setState(() {
      userExp += 25;
      if (userExp >= expPerLevel) {
        userExp -= expPerLevel;
        userLevel++;
      }
    });
  }

  void _sendChat() {
    if (_chatController.text.isEmpty) return;
    setState(() {
      chatMessages.add(_chatController.text);
      _chatController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(child: Text('${widget.vjName} - ${widget.status}', style: const TextStyle(fontSize: 24))),
          Positioned(top: 40, right: 20, child: _exitButton(context)),
          Positioned(top: 40, left: 20, child: _levelBadge()),
          Positioned(bottom: 80, left: 20, right: 20, child: _giftAndChatBar()),
          Positioned(bottom: 140, left: 20, right: 20, child: _chatList()),
        ],
      ),
    );
  }

  Widget _exitButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showExitDialog(context),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
        ),
        padding: const EdgeInsets.all(12),
        child: const Icon(Icons.close, color: Colors.redAccent),
      ),
    );
  }

  Widget _levelBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(color: Colors.deepOrange, borderRadius: BorderRadius.circular(20)),
      child: Text('LV $userLevel', style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _giftAndChatBar() {
    return Row(
      children: [
        ElevatedButton(onPressed: _sendGift, child: const Text("🎁 ส่งของขวัญ")),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: _chatController,
            decoration: InputDecoration(
              hintText: "พิมพ์แชท...",
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onSubmitted: (_) => _sendChat(),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(onPressed: _sendChat, child: const Text("ส่ง")),
      ],
    );
  }

  Widget _chatList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: chatMessages.map((msg) => Text(msg, style: const TextStyle(color: Colors.black87))).toList(),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("ออกจากห้องนี้?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("ยกเลิก")),
          TextButton(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: const Text("ออก", style: TextStyle(color: Colors.redAccent)),
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
      body: Center(child: Text("Wallet Page (แสดง QR / LINE แอด)", style: TextStyle(fontSize: 20))),
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
