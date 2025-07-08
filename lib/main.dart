import 'package:flutter/material.dart';
import 'viewer_room.dart';

void main() => runApp(const JoyLivethApp());

class JoyLivethApp extends StatelessWidget {
  const JoyLivethApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JOY LIVETH',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Prompt',
        scaffoldBackgroundColor: const Color(0xFFFDF6F0),
      ),
      home: const ViewerRoomPage(
        vjName: "VJ Miko",
        status: "LIVE",
      ),
    );
  }
}
