import 'package:flutter/material.dart';
import '../widgets/chat_input.dart';
import '../widgets/level_badge.dart';

class ViewerRoom extends StatelessWidget {
  final String vjName;
  final String status;

  const ViewerRoom({
    super.key,
    required this.vjName,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 👤 VJ Preview (จำลองกล้อง VJ)
          Positioned.fill(
            child: Container(
              color: const Color(0xFFF8F3ED),
              child: const Center(
                child: Icon(Icons.videocam, size: 100, color: Colors.black12),
              ),
            ),
          ),

          // 🆔 แสดงชื่อ VJ + Level
          Positioned(
            top: 60,
            left: 20,
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.orangeAccent,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vjName,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    const LevelBadge(level: 25),
                  ],
                ),
              ],
            ),
          ),

          // ❌ ปุ่มออก
          Positioned(
            top: 60,
            right: 20,
            child: GestureDetector(
              onTap: () => _showExitDialog(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                ),
                child: const Icon(Icons.close, color: Colors.redAccent),
              ),
            ),
          ),

          // 💬 ช่องแชท + ส่งข้อความ
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: ChatInput(onSend: (message) {
              // TODO: ส่งข้อความ
              print('ส่งแชท: $message');
            }),
          ),
        ],
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("ออกจากห้องนี้?", style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("ยกเลิก"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: const Text("ออก", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
