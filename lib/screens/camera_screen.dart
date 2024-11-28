import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late VlcPlayerController _vlcPlayerController;
  bool cameraFeedActive = false;
  
  @override
  void initState() {
    super.initState();
    _vlcPlayerController = VlcPlayerController.network(
      'rtsp://192.168.1.25:8554/unicast', 
      autoPlay: false,
      options: VlcPlayerOptions(),
    );
  }

  @override
  void dispose() {
    _vlcPlayerController.dispose();
    super.dispose();
  }

  Future<void> toggleCameraFeed() async {
    setState(() {
      cameraFeedActive = !cameraFeedActive;
    });

    if (cameraFeedActive) {
      await _vlcPlayerController.play();
    } else {
      await _vlcPlayerController.pause();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Kamera ${cameraFeedActive ? 'aktif' : 'mati'}",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: cameraFeedActive ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Camera System',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.green[700],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        color: Colors.green[50],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Kontrol Kamera Raspberry Pi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: cameraFeedActive
                    ? VlcPlayer(
                        controller: _vlcPlayerController,
                        aspectRatio: 16 / 9,
                        placeholder: Center(child: CircularProgressIndicator()),
                      )
                    : Text(
                        'Kamera Tidak Aktif',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: toggleCameraFeed,
              icon: Icon(cameraFeedActive ? Icons.videocam_off : Icons.videocam),
              label: Text(
                cameraFeedActive ? 'Matikan Kamera' : 'Aktifkan Kamera',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: cameraFeedActive ? Colors.red : Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          // Update navigasi sesuai kebutuhan
        },
        backgroundColor: Colors.green[700],
        selectedItemColor: Colors.green[900],
        unselectedItemColor: Colors.green[500],
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_rounded),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_remote),
            label: 'Control',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_rounded),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
