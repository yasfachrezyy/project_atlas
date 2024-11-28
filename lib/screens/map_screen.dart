import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapScreen(
        waypoints: [
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
        ],
      ),
    );
  }
}

class MapScreen extends StatelessWidget {
  final List<LatLng> waypoints;

  MapScreen({Key? key, required this.waypoints}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Hitung bounding box untuk zoom otomatis
    final bounds = LatLngBounds.fromPoints(waypoints);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AI Monitoring Map',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[700],
        centerTitle: true,
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              bounds: bounds, // Fokus pada semua waypoint
              boundsOptions: FitBoundsOptions(
                padding: EdgeInsets.all(5), // Kurangi padding untuk zoom lebih dekat
              ),
              maxZoom: 18.0, // Atur zoom maksimum agar lebih dekat
              interactiveFlags: InteractiveFlag.all,
            ),
            children: [
              // Hybrid map layer
              TileLayer(
                urlTemplate: 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                userAgentPackageName: 'com.example.app',
              ),
              // Polygon Layer
              PolygonLayer(
                polygons: [
                  Polygon(
                    points: waypoints,
                    color: Colors.redAccent.withOpacity(0.3),
                    borderColor: Colors.redAccent,
                    borderStrokeWidth: 3.0,
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              color: Colors.white.withOpacity(0.8),
              padding: EdgeInsets.all(8),
              child: Text(
                '© OpenStreetMap contributors',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
