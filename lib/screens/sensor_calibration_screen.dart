import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SensorCalibrationScreen extends StatefulWidget {
  @override
  _SensorCalibrationScreenState createState() =>
      _SensorCalibrationScreenState();
}

class _SensorCalibrationScreenState extends State<SensorCalibrationScreen> {
  final TextEditingController _temperatureController =
      TextEditingController();
  final TextEditingController _gpsOffsetController = TextEditingController();
  final TextEditingController _humidityOffsetController = TextEditingController(); // New controller for humidity
  bool _isLoading = false;

  // Fungsi untuk mengirim data kalibrasi ke perangkat (misalnya Raspberry Pi)
  Future<void> _sendSensorCalibration() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('http://<Raspberry_Pi_IP>:5000/calibrate-sensor'); 
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: '''
        {
          "temperature_offset": "${_temperatureController.text}",
          "gps_offset": "${_gpsOffsetController.text}",
          "humidity_offset": "${_humidityOffsetController.text}"
        }
        ''',
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sensor calibration sent successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send calibration data. Please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor Calibration'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Temperature Offset Input Field
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _temperatureController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Temperature Offset (°C)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.thermostat),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _humidityOffsetController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Humidity Offset (%)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.opacity),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),

            // GPS Offset Input Field
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _gpsOffsetController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'GPS Offset (meters)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.gps_fixed),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Submit Button
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _sendSensorCalibration,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.teal,
                    ),
                    child: Text(
                      'Calibrate Sensor',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
