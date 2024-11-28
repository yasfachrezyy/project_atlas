import 'package:flutter/material.dart';
import 'gsm_settings_screen.dart';
import 'sensor_calibration_screen.dart'; 

class SettingsScreen extends StatelessWidget {
  void _openGSMSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GSMSettingsScreen()),
    );
  }

  void _openSensorCalibration(BuildContext context) {
  
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SensorCalibrationScreen()),
    );
  }

  void _openAboutPage(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Tentang Aplikasi'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat datang di Aplikasi ATLAS!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Aplikasi ini dirancang untuk mendukung otomatisasi transplanter dalam pertanian berkelanjutan. '
              'Dengan aplikasi ini, Anda dapat memantau dan mengendalikan berbagai perangkat IoT yang terintegrasi dalam sistem pertanian, '
              'sehingga meningkatkan efisiensi dan produktivitas pertanian dengan teknologi terbaru.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Fitur Utama:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              '- Sistem Monitoring: Memantau kondisi tanaman, kelembaban tanah, dan parameter lingkungan secara real-time.\n'
              '- Sistem Kendali: Mengendalikan perangkat seperti transplanter, irigasi, dan alat lainnya dari jarak jauh.\n'
              '- Sistem AI: Menggunakan kecerdasan buatan untuk analisis data pertanian dan pengambilan keputusan otomatis dalam proses pertanian.\n',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Versi: 1.0',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Tutup'),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.greenAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.greenAccent, Colors.teal],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            // GSM Settings Card 
            Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 10,
              shadowColor: Colors.black38,
              child: ListTile(
                leading: Icon(Icons.settings_cell, color: Colors.blueAccent),
                title: Text('GSM Settings',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text('Configure GSM connection for Raspberry Pi'),
                onTap: () => _openGSMSettings(context),
              ),
            ),
            // Sensor Calibration Card
            Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 10,
              shadowColor: Colors.black38,
              child: ListTile(
                leading: Icon(Icons.tune, color: Colors.blueAccent),
                title: Text('Sensor Calibration',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text(
                    'Adjust settings for sensor calibration (e.g., temperature or GPS)'),
                onTap: () => _openSensorCalibration(context),
              ),
            ),
            // About Section Card
            Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 10,
              shadowColor: Colors.black38,
              child: ListTile(
                leading: Icon(Icons.info, color: Colors.blueAccent),
                title: Text('About',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text('Learn more about the app'),
                onTap: () => _openAboutPage(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
