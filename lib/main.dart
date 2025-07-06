import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

// *** นี่คือ App ID ของคุณที่ผมใส่ให้แล้วนะครับ ***
const String appId = "ba1f26c4d2c74113abd3a8db1082eb32";
// *** ชื่อ Channel สำหรับการไลฟ์สด (ต้องเหมือนกันสำหรับ Streamer และ Viewer) ***
const String channelId = 'test_channel_live'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live Streaming App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LiveHomePage(), // นี่คือหน้าแรกที่เราจะสร้าง
    );
  }
}

// เราจะสร้าง Widget สำหรับหน้าแรกของเราที่นี่
class LiveHomePage extends StatefulWidget {
  const LiveHomePage({super.key});

  @override
  State<LiveHomePage> createState() => _LiveHomePageState();
}

class _LiveHomePageState extends State<LiveHomePage> {
  late final RtcEngine _engine; // Agora RtcEngine instance
  int? _remoteUid; // UID of the remote user (for simplicity, only one remote user for now)
  bool _localUserJoined = false; // Flag to check if local user has joined channel
  bool _isFrontCamera = true; // Track current camera (front/back)

  @override
  void initState() {
    super.initState();
    _initAgoraRtcEngine();
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  Future<void> _initAgoraRtcEngine() async {
    // ขอสิทธิ์เข้าถึงกล้องและไมโครโฟน
    await [Permission.microphone, Permission.camera].request();

    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
    ));

    // ตั้งค่า Event Handlers สำหรับ Agora
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("Local user ${connection.localUid} joined the channel");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("Remote user $remoteUid joined the channel");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          debugPrint("Remote user $remoteUid left the channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          debugPrint("Local user left the channel");
          setState(() {
            _localUserJoined = false;
          });
        },
        onError: (ErrorCodeType err, String msg) {
          debugPrint("Agora Error: $err, Message: $msg");
        },
      ),
    );

    // เปิดใช้งานวิดีโอ
    await _engine.enableVideo();
    await _engine.startPreview(); // แสดงวิดีโอพรีวิวจากกล้องตัวเอง

    // กำหนดบทบาทเป็น Broadcaster (ผู้ถ่ายทอดสด)
    await _engine.setClientRole(ClientRoleType.clientRoleBroadcaster);
  }

  // ฟังก์ชันสำหรับเข้าร่วม Channel
  Future<void> _joinChannel() async {
    await _engine.joinChannel(
      token: null, // สำหรับโปรเจกต์ทดลอง ใช้ null ได้ หรือใส่ Token ถ้ามีการ Generate
      channelId: channelId, // ใช้ channelId ที่ประกาศไว้
      uid: 0, // 0 หมายถึง Agora จะกำหนด UID ให้เอง
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster, // เข้าร่วมเป็นผู้ถ่ายทอด
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting, // โปรไฟล์สำหรับการไลฟ์สด
      ),
    );
  }

  // ฟังก์ชันสำหรับออกจาก Channel
  Future<void> _leaveChannel() async {
    await _engine.leaveChannel();
  }

  // ฟังก์ชันสลับกล้อง
  Future<void> _switchCamera() async {
    await _engine.switchCamera();
    setState(() {
      _isFrontCamera = !_isFrontCamera;
    });
  }

  // UI สำหรับแสดงวิดีโอ
  Widget _videoPanel() {
    return Stack(
      children: <Widget>[
        // วิดีโอของผู้เข้าร่วมคนอื่น (เต็มจอ หรืออยู่ตรงกลางถ้าไม่มีวิดีโอตัวเอง)
        Center(
          child: _rtcVideoView(),
        ),
        // วิดีโอพรีวิวของตัวเอง (มุมบนซ้าย)
        Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 100,
            height: 100,
            child: Center(
              child: _localUserJoined
                  ? AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: _engine,
                        canvasId: 0, // Local user (Streamer)
                      ),
                    )
                  : const CircularProgressIndicator(), // หรือ Text('Joining...')
            ),
          ),
        ),
        _toolbar(), // Toolbar ด้านล่าง (ปุ่มโทรเข้า/ออก)
      ],
    );
  }

  // แสดงวิดีโอหลัก (ของ remote user หรือข้อความรอ)
  Widget _rtcVideoView() {
    if (_remoteUid != null) {
      // แสดงวิดีโอของผู้เข้าร่วมคนอื่น
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvasId: _remoteUid!,
          connection: RtcConnection(channelId: channelId, localUid: 0), // ต้องระบุ channelId ด้วย
        ),
      );
    } else {
      // ถ้าไม่มีผู้เข้าร่วมคนอื่น แสดงวิดีโอพรีวิวของตัวเอง
      return Center(
        child: _localUserJoined
            ? AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: _engine,
                  canvasId: 0, // Local user's own video preview
                ),
              )
            : const Text(
                'Join a channel to start streaming or watching!',
                textAlign: TextAlign.center,
              ),
      );
    }
  }

  // Toolbar สำหรับปุ่มเข้าร่วม/ออกและสลับกล้อง
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // ปุ่มเข้าร่วม/ออก
          RawMaterialButton(
            onPressed: _localUserJoined ? _leaveChannel : _joinChannel,
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: _localUserJoined ? Colors.redAccent : Colors.green,
            padding: const EdgeInsets.all(15.0),
            child: Icon(
              _localUserJoined ? Icons.call_end : Icons.call,
              color: Colors.white,
              size: 35.0,
            ),
          ),
          // ปุ่มสลับกล้อง (แสดงเมื่ออยู่ในไลฟ์)
          if (_localUserJoined)
            RawMaterialButton(
              onPressed: _switchCamera,
              shape: const CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.blueAccent,
              padding: const EdgeInsets.all(15.0),
              child: Icon(
                _isFrontCamera ? Icons.camera_front : Icons.camera_rear,
                color: Colors.white,
                size: 35.0,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Stream App'),
      ),
      body: _videoPanel(), // เปลี่ยน body ให้แสดงวิดีโอ
    );
  }
}