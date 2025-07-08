import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class ViewerRoomPage extends StatefulWidget {
  final String channelName;

  const ViewerRoomPage({Key? key, required this.channelName}) : super(key: key);

  @override
  State<ViewerRoomPage> createState() => _ViewerRoomPageState();
}

class _ViewerRoomPageState extends State<ViewerRoomPage> {
  static const String appId = 'ba1f26c4d2c74113abd3a8db1082eb32';
  static const String token =
      '007eJxTYJhQK+O8eW/A94N3RR45T5m9WNLIbqJXUIqNQIxU3qUkq1sKDEmJhmlGZskmKUbJ5iaGhsaJSSnGiRYpSYYGFkapScZGaz0zMxoCGRm2T';
  RtcEngine? _engine;

  int coin = 1230;
  int exp = 200;
  int level = 5;
  List<String> chatMessages = [];

  final TextEditingController _chatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    _engine = createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(appId: appId));
    await _engine!.enableVideo();
    await _engine!.startPreview();
    await _engine!.joinChannel(
      token: token,
      channelId: widget.channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    _engine?.leaveChannel();
    _engine?.release();
    super.dispose();
  }

  void sendChatMessage() {
    final text = _chatController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        chatMessages.add('LV $level: $text');
        _chatController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(child: Text('🎥 LIVE STREAMING: ${widget.channelName}')),

          // Coin + EXP
          Positioned(
            top: 40,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('💰 $coin coin',
                  style: const TextStyle(color: Colors.white)),
            ),
          ),

          // EXP / Level
          Positioned(
            top: 40,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('LV $level 🎖️',
                  style: const TextStyle(color: Colors.white)),
            ),
          ),

          // แชท Overlay
          Positioned(
            bottom: 90,
            left: 12,
            right: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: chatMessages.map((msg) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(msg,
                      style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
            ),
          ),

          // พิมพ์แชท
          Positioned(
            bottom: 20,
            left: 12,
            right: 12,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    decoration: InputDecoration(
                      hintText: 'พิมพ์ข้อความ...',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendChatMessage,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
