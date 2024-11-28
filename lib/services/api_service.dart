import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sensor_data.dart';

class ApiService {
  final String baseUrl = 'http://YOUR_DEVICE_IP'; // Ganti dengan alamat ESP32/Raspberry Pi

  Future<SensorData> fetchSensorData() async {
    final response = await http.get(Uri.parse('$baseUrl/sensor'));

    if (response.statusCode == 200) {
      return SensorData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load sensor data');
    }
  }

  Future<void> sendControlCommand(String command) async {
    final response = await http.post(
      Uri.parse('$baseUrl/control'),
      body: jsonEncode({'command': command}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send control command');
    }
  }
}
