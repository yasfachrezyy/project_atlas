import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ControlScreen extends StatefulWidget {
  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  String _controlStatus = "Idle"; // Status kontrol saat ini
  final String apiUrl =
      "http://192.168.1.100:5000/control"; // URL server Raspberry Pi

  Future<void> _sendCommandToRaspberryPi(String command) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'command': command},
      );

      if (response.statusCode == 200) {
        setState(() {
          _controlStatus = "$command executed successfully";
        });
      } else {
        setState(() {
          _controlStatus = "Failed to execute $command";
        });
      }
    } catch (e) {
      setState(() {
        _controlStatus = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Control System',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.green[700] ?? Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Control System for Transplanter',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[800] ?? Colors.green,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Status: $_controlStatus',
              style: TextStyle(
                  fontSize: 16, color: Colors.green[800] ?? Colors.green),
            ),
            SizedBox(height: 20),
            // Joysticks Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Joystick for Up/Down (Forward / Backward)
                _buildJoystickButton(
                  Icons.arrow_upward,
                  'Up',
                  Colors.green[700] ?? Colors.green,
                  () => _sendCommandToRaspberryPi('forward'),
                ),
                _buildJoystickButton(
                  Icons.arrow_downward,
                  'Down',
                  Colors.green[700] ?? Colors.green,
                  () => _sendCommandToRaspberryPi('backward'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Joystick for Left/Right (Turn Left / Right)
                _buildJoystickButton(
                  Icons.arrow_back,
                  'Left',
                  Colors.green[700] ?? Colors.green,
                  () => _sendCommandToRaspberryPi('left'),
                ),
                _buildJoystickButton(
                  Icons.arrow_forward,
                  'Right',
                  Colors.green[700] ?? Colors.green,
                  () => _sendCommandToRaspberryPi('right'),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Planting Controls (Buttons for actions)
            Column(
              children: [
                _buildControlButton(
                  'Start Planting',
                  Icons.play_arrow,
                  Colors.green[700] ?? Colors.green,
                  () => _sendCommandToRaspberryPi('start'),
                ),
                SizedBox(height: 20),
                _buildControlButton(
                  'Pause Planting',
                  Icons.pause,
                  Colors.orange[700] ?? Colors.orange,
                  () => _sendCommandToRaspberryPi('pause'),
                ),
                SizedBox(height: 20),
                _buildControlButton(
                  'Stop Planting',
                  Icons.stop,
                  Colors.red[700] ?? Colors.red,
                  () => _sendCommandToRaspberryPi('stop'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk membuat tombol joystick
  Widget _buildJoystickButton(
      IconData icon, String label, Color color, VoidCallback onPressed) {
    return RawMaterialButton(
      onPressed: onPressed,
      shape: CircleBorder(),
      fillColor: color,
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.white),
          SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // Widget untuk kontrol tindakan (Start, Pause, Stop)
  Widget _buildControlButton(
      String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(200, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
