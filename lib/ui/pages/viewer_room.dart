import 'package:flutter/material.dart';

class ViewerRoomPage extends StatefulWidget {
  const ViewerRoomPage({super.key});

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
      giftAnimations.add('🎁 ส่งของขวัญ $giftValue coin ให้ VJ!');
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
          const Center(
            child: Text(
              'VJ Miko2 - PK',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // ปุ่มออกจากห้อง
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

          // มุมบนซ้าย: LV ผู้ชม
          Positioned(
            top: 40,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('LV $userLevel', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),

          // มุมบนกลาง: Coin ผู้ชม
          Positioned(
            top: 40,
            left: 100,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('💰 $userCoins coin', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),

          // แสดงรายได้ VJ ชั่วคราว
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
                child: Text('🎉 VJ ได้รับ $vjEarned coin!', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),

          // Gift Animation
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

          // แสดงแชท Overlay
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

          // EXP Bar + Gift/Chat Input
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                // EXP Progress
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

                // ปุ่มส่งของขวัญ + แชท
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: _sendGift,
                        icon: const Icon(Icons.card_giftcard, color: Colors.red),
                        label: const Text("ส่งของขวัญ"),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.purple,
                          backgroundColor: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    Expanded(
                      flex: 3,
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
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
