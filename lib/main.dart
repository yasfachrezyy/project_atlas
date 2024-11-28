import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/control_screen.dart'; 
import 'screens/camera_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/map_screen.dart';

void main() {
  runApp(TransplanterApp());
}

class TransplanterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi ATLAS',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => HomeScreen(),
        '/control': (context) => ControlScreen(),
        '/camera': (context) => CameraScreen(),
        '/settings': (context) => SettingsScreen(),
        '/map': (context) => MapScreen(waypoints: [
          LatLng(-6.3435487, 107.3278789),
          LatLng(-6.3432128, 107.3278722),
          LatLng(-6.3432108, 107.3278787),
          LatLng(-6.343556, 107.3278937),
          LatLng(-6.343558, 107.3279071),
          LatLng(-6.3435453, 107.3280901),
        ]),
      },
    );
  }
}
