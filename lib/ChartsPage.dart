import 'package:flutter/material.dart';
import 'SupportPage.dart';
import 'MonitoringPage.dart';
import 'SettingsPage.dart';
import 'PredictionPage.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'Provider.dart';
// import 'package:provider/provider.dart';

// class SensorData {
//   SensorData(this.timestamp, this.value);
//   final DateTime timestamp;
//   final double value;
// }

class ChartsPage extends StatefulWidget {
  const ChartsPage({Key? key}) : super(key: key);
  @override
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  String apiURL =
      'http://192.168.1.19:8080/api/plugins/telemetry/DEVICE/dd79abf0-ce44-11ed-ae1a-a121083348b4/values/timeseries?keys=Temperature,Vibration,Current';
  String JWT =
      'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0ZW5hbnRAdGhpbmdzYm9hcmQub3JnIiwidXNlcklkIjoiM2E5MTkyMTAtMTBiZi0xMWVkLWJjNDAtMGQ3NGI5ZjIzM2IzIiwic2NvcGVzIjpbIlRFTkFOVF9BRE1JTiJdLCJpc3MiOiJ0aGluZ3Nib2FyZC5pbyIsImlhdCI6MTY4MDUzNDA0MywiZXhwIjoxNjgwNTQzMDQzLCJlbmFibGVkIjp0cnVlLCJpc1B1YmxpYyI6ZmFsc2UsInRlbmFudElkIjoiM2EyODQ4ZjAtMTBiZi0xMWVkLWJjNDAtMGQ3NGI5ZjIzM2IzIiwiY3VzdG9tZXJJZCI6IjEzODE0MDAwLTFkZDItMTFiMi04MDgwLTgwODA4MDgwODA4MCJ9.PoWGVjfUFPSVJp6KLQYzo4GhA4b5W96sXVO-jgTJKiEnOejId4cpLYCAqx2TNPQdp4qkP0edyLDDxG3G_xZ96g';

  List<double> temperatureData = [];
  List<double> currentData = [];
  List<double> vibrationData = [];
  int maxDataLength = 50;

  Future<void> _getSensorlistData() async {
    Timer.periodic(Duration(seconds: 5), (Timer t) async {
      var response =
          await http.get(Uri.parse(apiURL), headers: {'Authorization': JWT});
      var data = json.decode(response.body);
      var temperatureValue = double.parse(data['Temperature'][0]['value']);
      var vibrationValue = double.parse(data['Vibration'][0]['value']);
      var currentValue = double.parse(data['Current'][0]['value']);
      if (mounted) {
        setState(() {
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
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getSensorlistData(); // Call the API when the widget is first created
  }

  // void initState() {
  //   super.initState();
  //   final now = DateTime.now();
  //   for (int i = 0; i < 100; i++) {
  //     temperatureData
  //         .add(SensorData(now.add(Duration(seconds: i)), 20 + (i % 10)));
  //     currentData.add(SensorData(now.add(Duration(seconds: i)), 30 + (i % 5)));
  //     vibrationData
  //         .add(SensorData(now.add(Duration(seconds: i)), 10 + (i % 15)));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    //provider code

    // final sensorDataProvider =
    //     Provider.of<SensorDataProvider>(context, listen: true);

// Access the sensor data
    // List<double> temperatureData = sensorDataProvider.temperatureData;
    // List<double> vibrationData = sensorDataProvider.vibrationData;
    // List<double> currentData = sensorDataProvider.currentData;

// Start fetching data
    //sensorDataProvider.startFetchingData();

    return Scaffold(
      appBar: AppBar(
        title: Text('Courbes'),
        backgroundColor: Colors.black,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
            ListTile(
              title: Text('Visualisation'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MonitoringPage()),
                );
              },
            ),
            ListTile(
              title: Text('Courbes'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ChartsPage()),
                );
              },
            ),
            ListTile(
              title: Text('Prédiction'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PredictionPage()),
                );
              },
            ),
            ListTile(
              title: Text('Paramètres'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
            ListTile(
              title: Text('Support'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SupportPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SfCartesianChart(
              title: ChartTitle(text: 'Temperature'),
              primaryXAxis: DateTimeAxis(),
              series: <LineSeries<double, DateTime>>[
                LineSeries<double, DateTime>(
                    dataSource: temperatureData,
                    xValueMapper: (double data, _) => DateTime.now(),
                    yValueMapper: (double data, _) => data,
                    color: Colors.red),
              ],
            ),
            SfCartesianChart(
              title: ChartTitle(text: 'Courant'),
              primaryXAxis: DateTimeAxis(),
              series: <LineSeries<double, DateTime>>[
                LineSeries<double, DateTime>(
                    dataSource: currentData,
                    xValueMapper: (double data, _) => DateTime.now(),
                    yValueMapper: (double data, _) => data,
                    color: Colors.orange),
              ],
            ),
            SfCartesianChart(
              title: ChartTitle(text: 'Vibration'),
              primaryXAxis: DateTimeAxis(),
              series: <LineSeries<double, DateTime>>[
                LineSeries<double, DateTime>(
                    dataSource: vibrationData,
                    xValueMapper: (double data, _) => DateTime.now(),
                    yValueMapper: (double data, _) => data,
                    color: Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
