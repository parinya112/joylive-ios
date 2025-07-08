import 'package:flutter/material.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    int coinBalance = 12890; // ตัวอย่างยอด coin ที่มี

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5E5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Wallet", style: TextStyle(color: Colors.black87)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // 💰 ยอด Coin
          Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBC6),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.shade100,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  "ยอด Coin ของคุณ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Text(
                  "$coinBalance",
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // ➕ ปุ่มเติม Coin
          ElevatedButton.icon(
            onPressed: () => _showTopupDialog(context),
            icon: const Icon(Icons.add_circle_outline),
            label: const Text("เติม Coin", style: TextStyle(fontSize: 18)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrangeAccent,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTopupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("ติดต่อแอดมินเพื่อเติม Coin"),
        content: const Text("Line ID: @joyliveth\n\nแคปหน้านี้แล้วแอดไลน์เพื่อเติม Coin ผ่านตัวแทนได้เลย"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("ตกลง"),
          )
        ],
      ),
    );
  }
}
