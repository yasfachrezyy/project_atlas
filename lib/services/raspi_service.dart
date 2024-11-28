import 'package:http/http.dart' as http;

class RaspiService {
  static const String baseUrl = 'http://192.168.'; 

  static Future<void> controlDevice(String action) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/control_device'),
        body: {'action': action},
      );

      if (response.statusCode == 200) {
        print('Action $action berhasil');
      } else {
        print('Gagal: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  static Future<void> controlCamera(String action) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/control_camera'),
        body: {'action': action},
      );

      if (response.statusCode == 200) {
        print('Camera $action berhasil');
      } else {
        print('Gagal: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
