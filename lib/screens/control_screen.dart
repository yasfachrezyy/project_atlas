import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ControlScreen extends StatefulWidget {
  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  String _controlStatus = "Connected"; // Status kontrol saat ini
  bool _isAutonomous = false; // Flag for autonomous mode
  bool _isControlMode = false; // Flag for control system mode (manual or automatic)

  Future<void> _sendCommandToRaspberryPi(String command) async {
    // Simplified command sending (no HTML request)
    try {
      setState(() {
        _controlStatus = 'Sending command: $command';
      });
      await Future.delayed(Duration(seconds: 1)); // Simulate delay for command execution

      setState(() {
        _controlStatus = "$command executed successfully";
      });
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
            // Display status as simple text
            Text(
              'Status: $_controlStatus',
              style: TextStyle(fontSize: 16, color: Colors.green[800] ?? Colors.green),
            ),
            SizedBox(height: 20),
            // Switch for switching between manual and autonomous mode
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Autonomous Mode: ',
                    style: TextStyle(
                        fontSize: 16, color: Colors.green[700] ?? Colors.green)),
                Switch(
                  value: _isAutonomous,
                  onChanged: (value) {
                    setState(() {
                      _isAutonomous = value;
                      String modeCommand = _isAutonomous ? 'autonomous' : 'manual';
                      _sendCommandToRaspberryPi(modeCommand);
                    });
                  },
                  activeColor: Colors.green[700],
                  inactiveThumbColor: Colors.red[700],
                ),
              ],
            ),
            SizedBox(height: 20),
            // Control System Mode Switch
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Control Mode: ',
                    style: TextStyle(
                        fontSize: 16, color: Colors.green[700] ?? Colors.green)),
                Switch(
                  value: _isControlMode,
                  onChanged: (value) {
                    setState(() {
                      _isControlMode = value;
                      String controlCommand =
                          _isControlMode ? 'manual_control' : 'automatic_control';
                      _sendCommandToRaspberryPi(controlCommand);
                    });
                  },
                  activeColor: Colors.blue[700],
                  inactiveThumbColor: Colors.orange[700],
                ),
              ],
            ),
            SizedBox(height: 20),
            // Joysticks Section (Only visible when Control Mode is ON)
            if (_isControlMode) ...[
              // Only show joystick controls in Control Mode (ON)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
            ],
            // Autonomous Mode Control Buttons (Only visible in Autonomous Mode)
            if (_isAutonomous) ...[
              // Start and Stop buttons only visible in Autonomous Mode
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
                    'Stop Planting',
                    Icons.stop,
                    Colors.red[700] ?? Colors.red,
                    () => _sendCommandToRaspberryPi('stop'),
                  ),
                ],
              ),
            ],
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
