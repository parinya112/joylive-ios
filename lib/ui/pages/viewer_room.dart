import 'package:flutter/material.dart';

class ViewerRoomPage extends StatefulWidget {
  const ViewerRoomPage({super.key});

  @override
  State<ViewerRoomPage> createState() => _ViewerRoomPageState();
}

class _ViewerRoomPageState extends State<ViewerRoomPage> {
  int userLevel = 1;
  int userExp = 40;
  int userCoins = 1230;
  int vjCoins = 89456;

  final TextEditingController _chatController = TextEditingController();
  final List<String> chatMessages = [];

  void sendChat() {
    if (_chatController.text.trim().isEmpty) return;
    setState(() {
      chatMessages.add('LV $userLevel 🎖️: ${_chatController.text}');
    });
    _chatController.clear();
  }

  void sendGift() {
    setState(() {
      userCoins -= 35;
      userExp += 20;
      vjCoins += 35;
      chatMessages.add('🎁 คุณส่งของขวัญ! (+20 EXP)');
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎁 ส่งของขวัญสำเร็จ! VJ ได้รับ +35 coin'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black87,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Title Live
          const Center(
            child: Text(
              'VJ Miko1 - LIVE',
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

          // Avatar + Coin VJ
          Positioned(
            top: 40,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/avatar.jpg'), // ใส่รูปจริงตรงนี้
                    radius: 15,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('VJ Miko1', style: TextStyle(color: Colors.white, fontSize: 12)),
                      Text(
                        '💰 $vjCoins',
                        style: const TextStyle(color: Colors.amber, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // แสดงแชท Overlay
          Positioned(
            bottom: 150,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: chatMessages
                  .take(4)
                  .toList()
                  .reversed
                  .map((msg) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(msg, style: const TextStyle(fontSize: 14, color: Colors.black)),
                      ))
                  .toList(),
            ),
          ),

          // EXP bar + ของขวัญ + แชท
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                // EXP BAR
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: userExp / 100,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                  ),
                ),
                const SizedBox(height: 12),

                // ปุ่ม + แชท
                Row(
                  children: [
                    // ส่งของขวัญ
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: sendGift,
                        icon: const Icon(Icons.card_giftcard, color: Colors.red),
                        label: const Text("ส่งของขวัญ"),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.purple,
                          backgroundColor: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // ช่องพิมพ์
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: _chatController,
                        onSubmitted: (_) => sendChat(),
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
                      ),
                    ),
                    const SizedBox(width: 8),

                    // ส่งข้อความ
                    ElevatedButton(
                      onPressed: sendChat,
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
