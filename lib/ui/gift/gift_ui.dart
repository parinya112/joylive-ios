import 'package:flutter/material.dart';

class GiftUI extends StatelessWidget {
  final void Function(String giftName, int coinCost) onSend;

  const GiftUI({super.key, required this.onSend});

  final List<Map<String, dynamic>> gifts = const [
    {"name": "หัวใจ", "coin": 10},
    {"name": "ช็อกโกแลต", "coin": 50},
    {"name": "กุหลาบ", "coin": 99},
    {"name": "แหวนเพชร", "coin": 199},
    {"name": "ยูนิคอร์น", "coin": 999},
    {"name": "เรือยอชต์", "coin": 2999},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text("🎁 เลือกของขวัญ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 1,
              children: gifts.map((gift) {
                return GestureDetector(
                  onTap: () => onSend(gift['name'], gift['coin']),
                  child: Card(
                    color: Colors.orange.shade50,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.card_giftcard, size: 32, color: Colors.deepOrange),
                          const SizedBox(height: 4),
                          Text(gift['name'], style: const TextStyle(fontSize: 14)),
                          Text("${gift['coin']} 💰", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
