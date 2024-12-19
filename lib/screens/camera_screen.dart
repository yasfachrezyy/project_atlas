import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:flutter/services.dart';

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
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(300), // Menambah cache stream
        ]),
      ),
    );

    // Tambahkan listener untuk memantau error
    _vlcPlayerController.addListener(() {
      if (_vlcPlayerController.value.hasError) {
        _showSnackbar(
          "Terjadi kesalahan: ${_vlcPlayerController.value.errorDescription}",
          Colors.red,
        );
        setState(() {
          cameraFeedActive = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _vlcPlayerController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Future<void> toggleCameraFeed() async {
    try {
      setState(() {
        cameraFeedActive = !cameraFeedActive;
      });

      if (cameraFeedActive) {
        await _vlcPlayerController.play();
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      } else {
        await _vlcPlayerController.pause();
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }

      _showSnackbar(
        "Kamera ${cameraFeedActive ? 'aktif' : 'mati'}",
        cameraFeedActive ? Colors.green : Colors.red,
      );
    } catch (e) {
      setState(() {
        cameraFeedActive = false;
      });
      _showSnackbar("Gagal mengakses kamera: $e", Colors.red);
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: color,
      ),
    );
  }

  void _onBottomNavTapped(int index) {
    if (index == 1) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/control');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/map');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
    }
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
                child: MediaQuery.of(context).orientation == Orientation.landscape
                    ? (cameraFeedActive
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
                          ))
                    : Text(
                        'Putar perangkat ke mode landscape untuk melihat kamera.',
                        style: TextStyle(fontSize: 16, color: Colors.green[800]),
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
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  cameraFeedActive ? Icons.check_circle : Icons.cancel,
                  color: cameraFeedActive ? Colors.green : Colors.red,
                ),
                SizedBox(width: 8),
                Text(
                  cameraFeedActive ? 'Kamera Aktif' : 'Kamera Tidak Aktif',
                  style: TextStyle(
                    fontSize: 16,
                    color: cameraFeedActive ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: _onBottomNavTapped,
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
