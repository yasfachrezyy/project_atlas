class SensorData {
  final double temperature;
  final String gpsLocation;
  final String plantingStatus;

  SensorData({required this.temperature, required this.gpsLocation, required this.plantingStatus});

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      temperature: json['temperature'],
      gpsLocation: json['gps'],
      plantingStatus: json['plantingStatus'],
    );
  }
}
