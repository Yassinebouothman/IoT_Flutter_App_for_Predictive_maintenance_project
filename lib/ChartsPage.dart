import 'package:flutter/material.dart';
import 'SupportPage.dart';
import 'MonitoringPage.dart';
import 'SettingsPage.dart';
import 'PredictionPage.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
//import 'package:flutter_native_timezone/flutter_native_timezone.dart';

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
      'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0ZW5hbnRAdGhpbmdzYm9hcmQub3JnIiwidXNlcklkIjoiM2E5MTkyMTAtMTBiZi0xMWVkLWJjNDAtMGQ3NGI5ZjIzM2IzIiwic2NvcGVzIjpbIlRFTkFOVF9BRE1JTiJdLCJpc3MiOiJ0aGluZ3Nib2FyZC5pbyIsImlhdCI6MTY4MDU2MjM3OCwiZXhwIjoxNjgwNTcxMzc4LCJlbmFibGVkIjp0cnVlLCJpc1B1YmxpYyI6ZmFsc2UsInRlbmFudElkIjoiM2EyODQ4ZjAtMTBiZi0xMWVkLWJjNDAtMGQ3NGI5ZjIzM2IzIiwiY3VzdG9tZXJJZCI6IjEzODE0MDAwLTFkZDItMTFiMi04MDgwLTgwODA4MDgwODA4MCJ9.eTqBgBW5HAy5tH_LR3-TyrXQRtPCVfLuHggSz9jDNcHlugnw4ekmWvMx75pB5psaPuEJZroK4K0AnRreRtnuXw';
  List<double> temperatureData = [];
  List<double> currentData = [];
  List<double> vibrationData = [];
  List<DateTime> temperaturetimestampData = [];
  List<DateTime> vibrationtimestampData = [];
  List<DateTime> currenttimestampData = [];
  int maxDataLength = 50;

  Future<void> _getSensorlistData() async {
    Timer.periodic(Duration(seconds: 5), (Timer t) async {
      var response =
          await http.get(Uri.parse(apiURL), headers: {'Authorization': JWT});
      var data = json.decode(response.body);
      var temperatureValue = data['Temperature'][0];
      var vibrationValue = data['Vibration'][0];
      var currentValue = data['Current'][0];
      var temperaturetimestampValue =
          DateTime.fromMillisecondsSinceEpoch(data['Temperature'][0]['ts'])
              .add(Duration(hours: 1));
      var currenttimestampValue =
          DateTime.fromMillisecondsSinceEpoch(data['Current'][0]['ts'])
              .add(Duration(hours: 1));
      var vibrationtimestampValue =
          DateTime.fromMillisecondsSinceEpoch(data['Vibration'][0]['ts'])
              .add(Duration(hours: 1));
      if (mounted) {
        setState(() {
          try {
            temperatureData.add(double.parse(temperatureValue['value']));
            temperaturetimestampData.add(temperaturetimestampValue);
          } catch (e) {
            temperatureData.add(0);
            temperaturetimestampData.add(temperaturetimestampValue);
          }
          try {
            vibrationData.add(double.parse(vibrationValue['value']));
            vibrationtimestampData.add(vibrationtimestampValue);
          } catch (e) {
            vibrationData.add(0);
            vibrationtimestampData.add(vibrationtimestampValue);
          }
          try {
            currentData.add(double.parse(currentValue['value']));
            currenttimestampData.add(currenttimestampValue);
          } catch (e) {
            currentData.add(0);
            currenttimestampData.add(currenttimestampValue);
          }

          if (temperatureData.length > maxDataLength) {
            temperatureData.removeAt(0);
            temperaturetimestampData.removeAt(0);
          }
          if (vibrationData.length > maxDataLength) {
            vibrationData.removeAt(0);
            vibrationtimestampData.removeAt(0);
          }
          if (currentData.length > maxDataLength) {
            currentData.removeAt(0);
            currenttimestampData.removeAt(0);
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
              primaryXAxis: DateTimeAxis(dateFormat: DateFormat('HH:mm:ss')),
              series: <LineSeries<double, DateTime>>[
                LineSeries<double, DateTime>(
                    dataSource: temperatureData,
                    xValueMapper: (double data, int index) =>
                        temperaturetimestampData[index],
                    yValueMapper: (double data, _) => data,
                    color: Colors.red),
              ],
            ),
            SfCartesianChart(
              title: ChartTitle(text: 'Courant'),
              primaryXAxis: DateTimeAxis(dateFormat: DateFormat('HH:mm:ss')),
              series: <LineSeries<double, DateTime>>[
                LineSeries<double, DateTime>(
                    dataSource: currentData,
                    xValueMapper: (double data, int index) =>
                        currenttimestampData[index],
                    yValueMapper: (double data, _) => data,
                    color: Colors.orange),
              ],
            ),
            SfCartesianChart(
              title: ChartTitle(text: 'Vibration'),
              primaryXAxis: DateTimeAxis(dateFormat: DateFormat('HH:mm:ss')),
              series: <LineSeries<double, DateTime>>[
                LineSeries<double, DateTime>(
                    dataSource: vibrationData,
                    xValueMapper: (double data, int index) =>
                        vibrationtimestampData[index],
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
