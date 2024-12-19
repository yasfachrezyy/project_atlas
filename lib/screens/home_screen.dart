import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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
  List<FlSpot> successData = []; // Data untuk grafik keberhasilan

  @override
  void initState() {
    super.initState();

    waypoints = [
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
    ];

    _simulateRealtimeData();
    _generateSuccessData();
  }

  void _simulateRealtimeData() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        final time = TimeOfDay.now().format(context);
        activityLog.add(
            '[$time] GPS updated: ${waypoints.last.latitude}, ${waypoints.last.longitude}');
      });
    });
  }

  // Fungsi untuk menghasilkan data keberhasilan jarak tanam (0 = gagal, 1 = berhasil)
  void _generateSuccessData() {
    List<FlSpot> tempData = [];
    for (int i = 0; i < waypoints.length; i++) {
      // Simulasi Keberhasilan: 0 untuk gagal, 1 untuk berhasil
      double successRate = (i % 2 == 0) ? 0.0 : 1.0; // Gagal jika genap, Berhasil jika ganjil
      tempData.add(FlSpot(i.toDouble(), successRate));
    }
    setState(() {
      successData = tempData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[700]!, Colors.green[500]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Image.asset(
                'assets/ATLAS.png',
                height: 40,
                width: 40,
              ),
            ),
            Text(
              'ATLAS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ],
        ),
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
            _buildMonitoringCard('GPS', 'Multiple Waypoints', Icons.location_on,
                Colors.red, context),
            _buildMonitoringCard('Planting Status', 'Normal', Icons.grass,
                Colors.green[500]!, context),
            SizedBox(height: 20),
            Text('Realtime Monitoring',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800])),
            SizedBox(height: 10),
            _buildProgressBar(),
            SizedBox(height: 10),
            _buildConnectionStatus(),
            SizedBox(height: 20),
            // Grafik Keberhasilan Jarak Tanam
            Text('Keberhasilan Jarak Tanam',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800])),
            SizedBox(height: 10),
            _buildSuccessChart(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildMonitoringCard(String title, String value, IconData icon,
      Color color, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        shadowColor: Colors.black38,
        color: Colors.green[100],
        child: ListTile(
          leading: Icon(icon, size: 40, color: color),
          title: Text(title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800])),
          subtitle: Text(value,
              style: TextStyle(fontSize: 16, color: Colors.grey[700])),
          onTap: () {
            if (title == 'GPS') {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MapScreen(waypoints: waypoints)),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Progress',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700])),
          SizedBox(height: 5),
          LinearProgressIndicator(
            value: 0.1,
            backgroundColor: Colors.grey[300],
            color: Colors.green[700],
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(Icons.signal_cellular_alt, color: Colors.green[700]),
          SizedBox(width: 10),
          Text('Sensor Connected',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700])),
          Spacer(),
          Icon(Icons.check_circle,
              color: Colors.green[700]), // Indicating connected status
        ],
      ),
    );
  }

  // Grafik Keberhasilan Jarak Tanam
  Widget _buildSuccessChart() {
    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: successData,
              isCurved: true,
              colors: [Colors.green[700]!],
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: true, colors: [Colors.green[200]!]),
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: SideTitles(showTitles: true, reservedSize: 40),
            bottomTitles: SideTitles(showTitles: true, reservedSize: 30),
          ),
          gridData: FlGridData(show: true),
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
        BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_rounded), label: 'Camera'),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings_remote), label: 'Control'),
        BottomNavigationBarItem(icon: Icon(Icons.map_rounded), label: 'Map'),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded), label: 'Settings'),
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
