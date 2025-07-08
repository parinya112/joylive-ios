import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class ViewerRoomPage extends StatefulWidget {
  final String vjName;
  final String status;

  const ViewerRoomPage({super.key, required this.vjName, required this.status});

  @override
  State<ViewerRoomPage> createState() => _ViewerRoomPageState();
}

class _ViewerRoomPageState extends State<ViewerRoomPage> {
  static const String appId = 'ba1f26c4d2c74113abd3a8db1082eb32';
  static const String channelName = 'test';
  static const String token = null; // หรือใส่ Token ถ้ามี

  int coin = 1000;
  int exp = 0;
  int level = 1;
  final TextEditingController _chatController = TextEditingController();
  final List<Map<String, dynamic>> chatMessages = [];

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  Future<void> _initAgora() async {
    await AgoraRtcEngine.create(appId);
    await AgoraRtcEngine.enableVideo();
    await AgoraRtcEngine.startPreview();
    await AgoraRtcEngine.joinChannel(token, channelName, null, 0);
  }

  void sendGift(int amount) {
    if (coin >= amount) {
      setState(() {
        coin -= amount;
        exp += amount;
        chatMessages.add({
          'level': level,
          'text': '🎁 ส่งของขวัญ ($amount coin)',
        });
        if (exp > level * 100) {
          level += 1;
          exp = 0;
        }
      });
    }
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      chatMessages.add({'level': level, 'text': text});
      _chatController.clear();
    });
  }

  @override
  void dispose() {
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Center(child: Text('🔴 กำลังชมไลฟ์...')), // Mock video
          Positioned(
            top: 40,
            left: 20,
            child: Row(
              children: [
                CircleAvatar(backgroundColor: Colors.white, child: Text(widget.vjName[0])),
                const SizedBox(width: 8),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.vjName, style: const TextStyle(color: Colors.white)),
                  const Text('🎖️ VJ', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ]),
              ],
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('💰 $coin', style: const TextStyle(color: Colors.white)),
            ),
          ),
          Positioned(
            bottom: 140,
            left: 10,
            right: 10,
            child: Column(
              children: chatMessages.map((msg) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text('LV${msg['level']} : ${msg['text']}',
                      style: const TextStyle(color: Colors.white, fontSize: 14)),
                );
              }).toList(),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 10,
            right: 90,
            child: TextField(
              controller: _chatController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'พิมพ์ข้อความ...',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.black45,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onSubmitted: sendMessage,
            ),
          ),
          Positioned(
            bottom: 80,
            right: 10,
            child: Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.card_giftcard, color: Colors.pinkAccent),
                  onPressed: () => sendGift(100),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
