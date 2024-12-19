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
          LatLng(-6.3432108, 107.3278887),
          LatLng(-6.343356, 107.3278937),
          LatLng(-6.343558, 107.3279071),
          LatLng(-6.3432094, 107.3278997),
          LatLng(-6.3432081, 107.3279138),
          LatLng(-6.3435566, 107.3279352),
          LatLng(-6.3432074, 107.3279272),
          LatLng(-6.3432061, 107.3279413),
          LatLng(-6.3435566, 107.3279493),
          LatLng(-6.3435566, 107.3279641),
          LatLng(-6.3432048, 107.3279554),
          LatLng(-6.3432048, 107.3279694),
          LatLng(-6.3435566, 107.3279775),
          LatLng(-6.3435566, 107.3279916),
          LatLng(-6.3432028, 107.3279969),
          LatLng(-6.3435566, 107.3280057),
          LatLng(-6.3432053, 107.3280197),
          LatLng(-6.3432021, 107.3280111),
          LatLng(-6.3432044, 107.3280244),
          LatLng(-6.3435554, 107.3280338),
          LatLng(-6.3435527, 107.3280472),
          LatLng(-6.3431968, 107.3280392),
          LatLng(-6.3435097, 107.3280262),
          LatLng(-6.343548, 107.3280761),
          LatLng(-6.3431948, 107.3280645),
          LatLng(-6.3431928, 107.3280803),
          LatLng(-6.3435453, 107.3280901),
        ]),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/ATLASgif.gif', width: 150, height: 150),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
