import 'package:flutter/material.dart';

void main() {
  runApp(JoyLiveApp());
}

class JoyLiveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JOY LIVETH',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.purpleAccent,
      ),
      home: ExplorePage(),
    );
  }
}

class ExplorePage extends StatelessWidget {
  final List<Map<String, dynamic>> rooms = List.generate(
    12,
    (index) => {
      'name': 'VJ Miko${index + 1}',
      'status': ['LIVE', 'PK', 'Audio'][index % 3],
      'image': 'https://i.imgur.com/${['B9ZxkDd.png','Z9U0kJb.png','RmT0GzU.png','Jf7Ub7A.png','MQA8LMH.png','oHkRmTk.png','uV3y8UB.png','6mBz8tD.png','NHZr2LU.png','uOPkPH7.png','kLnczQ7.png','5B0cVtD.png'][index]}',
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Explore",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  itemCount: rooms.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final room = rooms[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LiveRoomPage(vjName: room['name'], image: room['image'], status: room['status']),
                          ),
                        );
                      },
                      child: RoomCard(
                        name: room['name'],
                        status: room['status'],
                        image: room['image'],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class RoomCard extends StatelessWidget {
  final String name;
  final String status;
  final String image;

  RoomCard({required this.name, required this.status, required this.image});

  Color getBadgeColor(String status) {
    switch (status) {
      case 'LIVE':
        return Colors.redAccent;
      case 'PK':
        return Colors.deepPurple;
      case 'Audio':
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            image,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: getBadgeColor(status),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        )
      ],
    );
  }
}

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.black,
      selectedItemColor: Colors.purpleAccent,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
        BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: "Live"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
      currentIndex: 1,
      onTap: (index) {},
    );
  }
}

class LiveRoomPage extends StatelessWidget {
  final String vjName;
  final String image;
  final String status;

  const LiveRoomPage({super.key, required this.vjName, required this.image, required this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Image.network(
            image,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vjName, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(status, style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}