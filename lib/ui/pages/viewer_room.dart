import 'package:flutter/material.dart';

class ViewerRoomPage extends StatelessWidget {
  const ViewerRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    int userLevel = 1;
    int userExp = 50;
    int userCoins = 1230;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
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
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),

          // มุมซ้ายบน: LV
          Positioned(
            top: 40,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'LV $userLevel',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),

          // มุมขวาบน: Coin
          Positioned(
            top: 40,
            right: 80,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.amber.shade700,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                '💰 $userCoins',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),

          // ล่างสุด: EXP + ปุ่มของขวัญ + แชท
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // EXP Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: userExp / 100,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.purpleAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // ปุ่มส่งของขวัญ + ช่องแชท + ปุ่มส่ง
                Row(
                  children: [
                    // ปุ่มส่งของขวัญ
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: เปิด Gift Popup
                        },
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

                    // ช่องพิมพ์แชท
                    Expanded(
                      flex: 3,
                      child: TextField(
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

                    // ปุ่มส่งแชท
                    ElevatedButton(
                      onPressed: () {
                        // TODO: ส่งแชท
                      },
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
