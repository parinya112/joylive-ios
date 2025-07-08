import 'package:flutter/material.dart';

class ViewerRoomPage extends StatefulWidget {
  final String vjName;
  final String status;

  const ViewerRoomPage({super.key, required this.vjName, required this.status});

  @override
  State<ViewerRoomPage> createState() => _ViewerRoomPageState();
}

class _ViewerRoomPageState extends State<ViewerRoomPage> {
  int coin = 1200;
  int exp = 0;
  int level = 1;
  bool showGiftPopup = false;

  final TextEditingController _chatController = TextEditingController();
  final List<Map<String, dynamic>> chatMessages = [];

  final List<Map<String, dynamic>> gifts = [
    {'name': 'หัวใจ', 'price': 10},
    {'name': 'ดอกไม้', 'price': 50},
    {'name': 'ยูนิคอร์น', 'price': 199},
  ];

  void sendGift(Map<String, dynamic> gift) {
    if (coin >= gift['price']) {
      setState(() {
        coin -= gift['price'];
        exp += gift['price'];
        level = 1 + (exp ~/ 100);
        chatMessages.add({
          'type': 'gift',
          'msg': '🎁 ส่ง ${gift['name']}',
          'level': level,
        });
      });
    }
    setState(() => showGiftPopup = false);
  }

  void sendMessage() {
    final msg = _chatController.text.trim();
    if (msg.isNotEmpty) {
      setState(() {
        chatMessages.add({
          'type': 'chat',
          'msg': msg,
          'level': level,
        });
        _chatController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ไลฟ์จำลอง
          Container(
            color: Colors.black,
            child: Center(
              child: Icon(Icons.videocam, size: 100, color: Colors.white30),
            ),
          ),

          // UI ด้านบน
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // VJ Info
                Row(
                  children: [
                    CircleAvatar(backgroundColor: Colors.pink, child: Text(widget.vjName[0])),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.vjName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        Text(widget.status, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                // Coin / EXP
                Column(
                  children: [
                    Text('💰 $coin', style: const TextStyle(color: Colors.white)),
                    Text('LV $level 🎖️', style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),

          // แชท overlay
          Positioned(
            bottom: 120,
            left: 16,
            right: 16,
            child: Column(
              children: chatMessages.reversed.take(6).map((msg) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: msg['type'] == 'gift' ? Colors.pinkAccent.withOpacity(0.7) : Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'LV ${msg['level']} : ${msg['msg']}',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // กล่องพิมพ์ข้อความ
          Positioned(
            bottom: 70,
            left: 16,
            right: 100,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _chatController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'พิมพ์ข้อความ...',
                      ),
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

          // Bottom Buttons
          Positioned(
            bottom: 10,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(icon: const Icon(Icons.videocam, color: Colors.white), onPressed: () {}),
                IconButton(
                  icon: const Icon(Icons.card_giftcard, color: Colors.pinkAccent),
                  onPressed: () => setState(() => showGiftPopup = true),
                ),
                IconButton(icon: const Icon(Icons.swords, color: Colors.white), onPressed: () {}),
              ],
            ),
          ),

          // Gift Popup
          if (showGiftPopup)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => showGiftPopup = false),
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
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
