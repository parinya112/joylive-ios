import 'package:flutter/material.dart';

class ViewerRoomPage extends StatefulWidget {
  final String vjName;
  final String status;

  const ViewerRoomPage({
    super.key,
    required this.vjName,
    required this.status,
  });

  @override
  State<ViewerRoomPage> createState() => _ViewerRoomPageState();
}

class _ViewerRoomPageState extends State<ViewerRoomPage> {
  int userLevel = 2;
  int userExp = 80;
  int userCoins = 1230;
  int vjEarned = 0;
  bool showLevelTemp = true;
  bool showGiftPopup = false;

  final TextEditingController _chatController = TextEditingController();
  final List<String> chatMessages = [];
  final List<String> giftAnimations = [];

  final List<Map<String, dynamic>> gifts = [
    {'name': '🌹 กุหลาบ', 'price': 10},
    {'name': '🚗 รถหรู', 'price': 999},
    {'name': '🛩️ เครื่องบิน', 'price': 4999},
  ];

  void _sendChat() {
    if (_chatController.text.trim().isEmpty) return;
    setState(() {
      chatMessages.add('🎖 LV$userLevel: ${_chatController.text.trim()}');
      _chatController.clear();
      showLevelTemp = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() => showLevelTemp = false);
    });
  }

  void _sendGift(Map<String, dynamic> gift) {
    final int price = gift['price'];
    setState(() {
      userCoins -= price;
      int gainedExp = price * 10;
      userExp += gainedExp;
      while (userExp >= 100) {
        userLevel++;
        userExp -= 100;
      }
      vjEarned = price;
      giftAnimations.add('🎁 ${gift['name']} (${price} coins) ให้ ${widget.vjName}');
      showLevelTemp = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        vjEarned = 0;
        if (giftAnimations.isNotEmpty) giftAnimations.removeAt(0);
        showLevelTemp = false;
      });
    });
  }

  void _openGiftPopup() {
    setState(() => showGiftPopup = true);
  }

  void _closeGiftPopup() {
    setState(() => showGiftPopup = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Text('${widget.vjName} - ${widget.status}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),

          // ปุ่มออกจากห้อง
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // LV ชั่วคราว
          if (showLevelTemp)
            Positioned(
              top: 40,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('LV $userLevel', style: const TextStyle(color: Colors.white)),
              ),
            ),

          // Coin
          Positioned(
            top: 40,
            right: 80,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('💰 $userCoins coin', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),

          // รายได้ VJ
          if (vjEarned > 0)
            Positioned(
              top: 80,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('🎉 ${widget.vjName} ได้รับ $vjEarned coin!',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),

          // Gift Animation
          Positioned(
            top: 120,
            left: 20,
            right: 20,
            child: Column(
              children: giftAnimations
                  .map((text) => AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: 1.0,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(text, style: const TextStyle(fontSize: 14)),
                        ),
                      ))
                  .toList(),
            ),
          ),

          // Chat Overlay
          Positioned(
            bottom: 150,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: chatMessages
                  .map((msg) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(msg, style: const TextStyle(color: Colors.white)),
                        ),
                      ))
                  .toList(),
            ),
          ),

          // EXP + Chat + Gift
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: userExp.clamp(0, 100) / 100,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.purpleAccent),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _openGiftPopup,
                      icon: const Icon(Icons.card_giftcard, color: Colors.red),
                      label: const Text("ของขวัญ"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.purple,
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _chatController,
                        onSubmitted: (_) => _sendChat(),
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
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _sendChat,
                      child: const Text("ส่ง"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Gift Popup
          if (showGiftPopup)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 300,
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('💰 $userCoins', style: const TextStyle(fontWeight: FontWeight.bold)),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                onPressed: _closeGiftPopup,
                              ),
                            ],
                          ),
                          const Divider(),
                          Expanded(
                            child: GridView.count(
                              crossAxisCount: 3,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              children: gifts
                                  .map((gift) => ElevatedButton(
                                        onPressed: () {
                                          _sendGift(gift);
                                          _closeGiftPopup();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.amber.shade50,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(gift['name'], style: const TextStyle(fontSize: 18)),
                                            const SizedBox(height: 6),
                                            Text('${gift['price']} coin', style: const TextStyle(fontSize: 12)),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
