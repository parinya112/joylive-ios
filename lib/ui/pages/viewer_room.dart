import 'package:flutter/material.dart';

class ViewerRoomPage extends StatefulWidget {
  final String vjName;
  final String status;

  const ViewerRoomPage({super.key, required this.vjName, required this.status});

  @override
  State<ViewerRoomPage> createState() => _ViewerRoomPageState();
}

class _ViewerRoomPageState extends State<ViewerRoomPage> {
  int coin = 1000;
  int exp = 0;
  int level = 1;
  bool showGiftPopup = false;
  bool showInfo = true;

  final TextEditingController _chatController = TextEditingController();
  List<Map<String, String>> chatMessages = [];

  final List<Map<String, dynamic>> gifts = [
    {"name": "เค้กน่ารัก", "price": 10},
    {"name": "ครัวซองต์", "price": 99},
    {"name": "แซนด์วิช", "price": 299},
    {"name": "เค้กธงลาว", "price": 999},
  ];

  void _sendGift(Map<String, dynamic> gift) {
    if (coin >= gift['price']) {
      setState(() {
        coin -= gift['price'];
        exp += gift['price'] * 10;
        level = ((exp ~/ 100) + 1).toInt(); // ✅ แก้ type
        chatMessages.add({
          "text": "ส่ง ${gift['name']} 🎁 (${gift['price']} coin)",
          "level": "Lv.$level"
        });
        showGiftPopup = false;
        showInfo = true;
      });
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() => showInfo = false);
      });
    }
  }

  void _sendChat() {
    final text = _chatController.text;
    if (text.trim().isNotEmpty) {
      setState(() {
        chatMessages.add({
          "text": text.trim(),
          "level": "Lv.$level"
        });
        _chatController.clear();
        showInfo = true;
      });
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() => showInfo = false);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => showInfo = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ไลฟ์จำลอง (พื้นหลัง)
          Container(color: Colors.black87),

          // Chat overlay
          Positioned(
            bottom: 130,
            left: 10,
            right: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: chatMessages.map((msg) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${msg['level']} : ${msg['text']}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // ปุ่มพิมพ์แชท & ส่งของขวัญ
          Positioned(
            bottom: 60,
            left: 10,
            right: 10,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "พิมพ์ข้อความ...",
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.black45,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    onSubmitted: (_) => _sendChat(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.card_giftcard, color: Colors.pinkAccent),
                  onPressed: () => setState(() => showGiftPopup = true),
                ),
              ],
            ),
          ),

          // ป๊อปอัปเลือกของขวัญ
          if (showGiftPopup)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("เลือกของขวัญ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 120,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: gifts.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final gift = gifts[index];
                          return GestureDetector(
                            onTap: () => _sendGift(gift),
                            child: Container(
                              width: 100,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.pink.shade50,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.pinkAccent),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(gift['name'], style: const TextStyle(fontSize: 14)),
                                  const SizedBox(height: 8),
                                  Text('${gift['price']} coin', style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => setState(() => showGiftPopup = false),
                      child: const Text("ปิด"),
                    ),
                  ],
                ),
              ),
            ),

          // Coin / EXP แสดงเฉพาะตอนเข้า + หลังพิมพ์/ส่งของขวัญ
          if (showInfo)
            Positioned(
              top: 40,
              right: 16,
              child: AnimatedOpacity(
                opacity: 1,
                duration: const Duration(milliseconds: 500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("💰 $coin coin", style: const TextStyle(color: Colors.white, fontSize: 14)),
                    Text("EXP: $exp", style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
