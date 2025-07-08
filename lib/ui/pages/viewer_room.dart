import 'package:flutter/material.dart';

class ViewerRoomPage extends StatefulWidget {
  final String vjName;
  final String status;

  const ViewerRoomPage({super.key, required this.vjName, required this.status});

  @override
  State<ViewerRoomPage> createState() => _ViewerRoomPageState();
}

class _ViewerRoomPageState extends State<ViewerRoomPage> {
  int coin = 1001;
  int exp = 0;
  int level = 2;
  bool showGiftPopup = false;
  bool showTopStats = false;

  final TextEditingController _chatController = TextEditingController();
  final List<Map<String, dynamic>> chatMessages = [];

  final List<Map<String, dynamic>> gifts = [
    {'name': 'ยูนิคอร์น', 'price': 199},
    {'name': 'หัวใจ', 'price': 10},
    {'name': 'ดอกไม้', 'price': 50},
  ];

  void sendGift(Map<String, dynamic> gift) {
    final price = (gift['price'] as num).toInt();
    if (coin >= price) {
      setState(() {
        coin -= price;
        exp += price;
        level = 1 + (exp / 100).floor();
        chatMessages.add({
          'type': 'gift',
          'msg': '🎁 ส่ง ${gift['name']}',
          'level': level,
        });
        showTopStats = true;
      });
    }
    setState(() => showGiftPopup = false);
  }

  void sendMessage() {
    final msg = _chatController.text.trim();
    if (msg.isNotEmpty) {
      setState(() {
        chatMessages.add({'type': 'chat', 'msg': msg, 'level': level});
        _chatController.clear();
        showTopStats = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            child: const Center(
              child: Icon(Icons.videocam, color: Colors.white30, size: 100),
            ),
          ),

          // Top left: Back + VJ info
          Positioned(
            top: 40,
            left: 16,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.vjName,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text(widget.status,
                        style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),

          // Top right: Coin + Level (เฉพาะตอนส่งของขวัญ/พิมพ์)
          if (showTopStats)
            Positioned(
              top: 40,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('💰 $coin', style: const TextStyle(color: Colors.white)),
                  Text('LV $level 🏅', style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),

          // Chat overlay
          Positioned(
            bottom: 130,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: chatMessages.reversed.take(5).map((msg) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: msg['type'] == 'gift' ? Colors.pinkAccent : Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'LV ${msg['level']} : ${msg['msg']}',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                );
              }).toList(),
            ),
          ),

          // Input box
          Positioned(
            bottom: 60,
            left: 16,
            right: 100,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _chatController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'พิมพ์ข้อความ...',
                        hintStyle: TextStyle(color: Colors.white60),
                        border: InputBorder.none,
                      ),
                      onTap: () => setState(() => showTopStats = true),
                      onSubmitted: (_) => sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.pink),
                    onPressed: sendMessage,
                  ),
                ],
              ),
            ),
          ),

          // Bottom buttons
          Positioned(
            bottom: 10,
            left: 32,
            right: 32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Icon(Icons.videocam, color: Colors.white),
                GestureDetector(
                  onTap: () => setState(() => showGiftPopup = true),
                  child: const Icon(Icons.card_giftcard, color: Colors.pinkAccent),
                ),
                const Icon(Icons.sports_martial_arts, color: Colors.white),
              ],
            ),
          ),

          // Gift popup
          if (showGiftPopup)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => showGiftPopup = false),
                child: Container(
                  color: Colors.black.withOpacity(0.8),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: gifts.map((gift) {
                          return ListTile(
                            title: Text('${gift['name']} - ${gift['price']} coin'),
                            trailing: ElevatedButton(
                              onPressed: () => sendGift(gift),
                              child: const Text('ส่ง'),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
