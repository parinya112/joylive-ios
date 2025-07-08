import 'package:flutter/material.dart';

class ViewerRoomPage extends StatefulWidget {
  const ViewerRoomPage({super.key});

  @override
  State<ViewerRoomPage> createState() => _ViewerRoomPageState();
}

class _ViewerRoomPageState extends State<ViewerRoomPage> {
  int userExp = 50;
  int userLevel = 1;
  int viewerCoin = 1230;
  int vjCoinEarned = 0;

  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<String> chatMessages = [];

  void _sendGift() {
    if (viewerCoin >= 35) {
      setState(() {
        viewerCoin -= 35;
        userExp += 15;
        vjCoinEarned += 35;
        if (userExp >= 100) {
          userExp -= 100;
          userLevel += 1;
        }
        chatMessages.add("🎁 คุณส่งของขวัญให้ VJ (+35 coin, +15 EXP)");
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ส่งของขวัญสำเร็จ!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("coin ไม่พอ!")),
      );
    }
  }

  void _sendChat() {
    String text = _chatController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        chatMessages.add("LV$userLevel 👤: $text");
        _chatController.clear();
      });
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent + 60);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // LIVE Title
          const Align(
            alignment: Alignment.center,
            child: Text(
              'VJ Miko3 - Audio',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // ปุ่มออก
          Positioned(
            top: 40,
            right: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 24,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // coin ของ VJ (มุมซ้ายบน)
          Positioned(
            top: 40,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.amber.shade700,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                '🎖️ $vjCoinEarned',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),

          // แสดงแชทแบบ overlay
          Positioned(
            top: 100,
            left: 12,
            right: 12,
            bottom: 130,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: chatMessages.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(chatMessages[index]),
              ),
            ),
          ),

          // ด้านล่าง: EXP bar + gift/chat
          Positioned(
            bottom: 20,
            left: 12,
            right: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // EXP bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: userExp / 100,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: const AlwaysStoppedAnimation(Colors.purple),
                  ),
                ),
                const SizedBox(height: 10),

                // แถวของขวัญ + แชท
                Row(
                  children: [
                    // ปุ่มของขวัญ
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

                    // ช่องพิมพ์
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

                    // ปุ่มส่ง
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
