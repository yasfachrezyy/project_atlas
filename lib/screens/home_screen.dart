import 'package:flutter/material.dart';
import 'map_screen.dart';
import 'dart:async';
import 'package:latlong2/latlong.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<LatLng> waypoints = [];
  List<String> activityLog = []; 

  @override
  void initState() {
    super.initState();

    waypoints = [
      LatLng(-6.8162, 107.1424),
      LatLng(-6.8163, 107.1425),
      LatLng(-6.8165, 107.1427),
    ];

    _simulateRealtimeData();
  }

  void _simulateRealtimeData() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        // Menambahkan log aktivitas baru
        final time = TimeOfDay.now().format(context);
        activityLog.add('[$time] GPS updated: ${waypoints.last.latitude}, ${waypoints.last.longitude}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ATLAS',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              _showActivityLog(context);
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        color: Colors.green[50],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMonitoringCard('GPS', 'Multiple Waypoints', Icons.location_on, Colors.red, context),
            _buildMonitoringCard('Planting Status', 'Normal', Icons.grass, Colors.green[500]!, context),
            SizedBox(height: 20),
            Text(
              'Realtime Monitoring',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[800]),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: activityLog.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.update, color: Colors.green[700]),
                    title: Text(activityLog[index], style: TextStyle(color: Colors.green[800])),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildMonitoringCard(String title, String value, IconData icon, Color color, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        shadowColor: Colors.black38,
        color: Colors.green[100],
        child: ListTile(
          leading: Icon(icon, size: 40, color: color),
          title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[800])),
          subtitle: Text(value, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
          onTap: () {
            if (title == 'GPS') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapScreen(waypoints: waypoints),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/camera');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/control');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/map');
          } else if (index == 4) {
            Navigator.pushNamed(context, '/settings');
          }
        });
      },
      backgroundColor: Colors.green[700],
      selectedItemColor: Colors.green[900],
      unselectedItemColor: Colors.green[500],
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.camera_alt_rounded), label: 'Camera'),
        BottomNavigationBarItem(icon: Icon(Icons.settings_remote), label: 'Control'),
        BottomNavigationBarItem(icon: Icon(Icons.map_rounded), label: 'Map'),
        BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Settings'),
      ],
    );
  }

  void _showActivityLog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Activity Log'),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: activityLog.map((log) => Text(log)).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
