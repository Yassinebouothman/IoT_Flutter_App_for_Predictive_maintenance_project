import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class SensorDataProvider with ChangeNotifier {
  double _temperature = 0.0;
  double _vibration = 0.0;
  double _current = 0.0;

  String apiURL =
      'http://192.168.1.19:8080/api/plugins/telemetry/DEVICE/dd79abf0-ce44-11ed-ae1a-a121083348b4/values/timeseries?keys=Temperature,Vibration,Current';
  String JWT =
      'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0ZW5hbnRAdGhpbmdzYm9hcmQub3JnIiwidXNlcklkIjoiM2E5MTkyMTAtMTBiZi0xMWVkLWJjNDAtMGQ3NGI5ZjIzM2IzIiwic2NvcGVzIjpbIlRFTkFOVF9BRE1JTiJdLCJpc3MiOiJ0aGluZ3Nib2FyZC5pbyIsImlhdCI6MTY4MDQ4ODUyMiwiZXhwIjoxNjgwNDk3NTIyLCJlbmFibGVkIjp0cnVlLCJpc1B1YmxpYyI6ZmFsc2UsInRlbmFudElkIjoiM2EyODQ4ZjAtMTBiZi0xMWVkLWJjNDAtMGQ3NGI5ZjIzM2IzIiwiY3VzdG9tZXJJZCI6IjEzODE0MDAwLTFkZDItMTFiMi04MDgwLTgwODA4MDgwODA4MCJ9.bsstmyiituCJvMuUNthdRRS7gpXXRvddFE4ePbzLxYHxQ-bijgZbxv4nd7rQDpa9g7kniN2vAyAphEgBFTRjnw';

  double get temperature => _temperature;
  double get vibration => _vibration;
  double get current => _current;

  List<double> temperatureData = [];
  List<double> currentData = [];
  List<double> vibrationData = [];
  int maxDataLength = 20;

  Future<void> _getSensorlistData() async {
    Timer.periodic(Duration(seconds: 5), (Timer t) async {
      var response =
          await http.get(Uri.parse(apiURL), headers: {'Authorization': JWT});
      var data = json.decode(response.body);
      var temperatureValue = double.parse(data['Temperature'][0]['value']);
      var vibrationValue = double.parse(data['Vibration'][0]['value']);
      var currentValue = double.parse(data['Current'][0]['value']);

      temperatureData.add(temperatureValue);
      vibrationData.add(vibrationValue);
      currentData.add(currentValue);

      if (temperatureData.length > maxDataLength) {
        temperatureData.removeAt(0);
      }
      if (vibrationData.length > maxDataLength) {
        vibrationData.removeAt(0);
      }
      if (currentData.length > maxDataLength) {
        currentData.removeAt(0);
      }
      notifyListeners();
    });
  }

  Future<void> _getSensorData() async {
    Timer.periodic(Duration(seconds: 5), (Timer t) async {
      var response =
          await http.get(Uri.parse(apiURL), headers: {'Authorization': JWT});
      var data = json.decode(response.body);
      var temperatureData = data['Temperature'][0];
      var vibrationData = data['Vibration'][0];
      var currentData = data['Current'][0];

      _temperature = double.parse(temperatureData['value']);
      _vibration = double.parse(vibrationData['value']);
      _current = double.parse(currentData['value']);
      notifyListeners();
    });
  }

  void startFetchingData() {
    _getSensorData();
  }

  void startFetchinglistData() {
    _getSensorlistData();
  }
}
