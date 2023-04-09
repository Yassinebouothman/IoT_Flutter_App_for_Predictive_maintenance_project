import 'dart:io';
import 'package:flutter/material.dart';
import 'DatabseHelper.dart';
import 'SupportPage.dart';
import 'MonitoringPage.dart';
import 'SettingsPage.dart';
import 'PredictionPage.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'HistoryPage.dart';
import 'package:provider/provider.dart';
import 'Provider.dart';
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
      'http://192.168.1.16:8080/api/plugins/telemetry/DEVICE/dd79abf0-ce44-11ed-ae1a-a121083348b4/values/timeseries?keys=Temperature,Vibration,Current';
  Future<String> _getNewToken() async {
    // Make a POST request to authenticate and obtain a new JWT token
    String authURL = 'http://192.168.1.16:8080/api/auth/login';
    var response = await http.post(Uri.parse(authURL),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
            {"username": "tenant@thingsboard.org", "password": "tenant"}));
    print(response.statusCode);
    var data = json.decode(response.body);
    return data['token'];
  }

  String? _accessToken;
  DateTime? _tokenExpirationTime;

  Future<String> _getAccessToken() async {
    // Check if the cached token has expired
    if (_accessToken != null &&
        _tokenExpirationTime != null &&
        _tokenExpirationTime!.isAfter(DateTime.now())) {
      return _accessToken!;
    }
    // Request a new token if the cached token has expired or doesn't exist
    _accessToken = await _getNewToken();
    _tokenExpirationTime = DateTime.now().add(Duration(minutes: 30));
    return _accessToken!;
  }

  List<double> temperatureData = [];
  List<double> currentData = [];
  List<double> vibrationData = [];
  List<DateTime> timestampData = [];
  List<double> histtemperatureData = [0, 0, 0, 0];
  List<double> histcurrentData = [0, 0, 0, 0];
  List<double> histvibrationData = [0, 0, 0, 0];
  List<DateTime> histtimestampData = [
    DateTime.now(),
    DateTime.now(),
    DateTime.now(),
    DateTime.now()
  ];

  int maxDataLength = 50;
  Future<void> _getSensorlistData() async {
    Timer.periodic(Duration(seconds: 5), (Timer t) async {
      try {
        String JWT = await _getAccessToken();
        var response = await http
            .get(Uri.parse(apiURL), headers: {'Authorization': 'Bearer $JWT'});
        var data = json.decode(response.body);
        var temperatureValue = data['Temperature'][0];
        var vibrationValue = data['Vibration'][0];
        var currentValue = data['Current'][0];
        var timestampValue =
            DateTime.fromMillisecondsSinceEpoch(data['Temperature'][0]['ts'])
                .add(Duration(hours: 1));
        try {
          await DatabaseHelper.instance.insertSensorData(
              double.parse(temperatureValue['value']),
              double.parse(currentValue['value']),
              double.parse(vibrationValue['value']),
              timestampValue);
        } catch (e) {
          print('unable to upload to database');
        }
        if (mounted) {
          setState(() {
            try {
              temperatureData.add(double.parse(temperatureValue['value']));
              timestampData.add(timestampValue);
            } catch (e) {
              temperatureData.add(0);
              timestampData.add(timestampValue);
            }
            // Insert data into the database
            try {
              vibrationData.add(double.parse(vibrationValue['value']));
            } catch (e) {
              vibrationData.add(0);
            }
            try {
              currentData.add(double.parse(currentValue['value']));
            } catch (e) {
              currentData.add(0);
            }
            if (temperatureData.length > maxDataLength) {
              temperatureData.removeAt(0);
              timestampData.removeAt(0);
            }
            if (vibrationData.length > maxDataLength) {
              vibrationData.removeAt(0);
              timestampData.removeAt(0);
            }
            if (currentData.length > maxDataLength) {
              currentData.removeAt(0);
              timestampData.removeAt(0);
            }
          });
        }
        // Call the method that updates the historical data lists
      } on TimeoutException catch (_) {
        if (mounted) {
          setState(() {
            temperatureData = histtemperatureData;
            currentData = histcurrentData;
            vibrationData = histvibrationData;
            timestampData = histtimestampData;
          });
        }

        // Call the method that updates the historical data lists
      } on SocketException {
        if (mounted) {
          setState(() {
            temperatureData = histtemperatureData;
            currentData = histcurrentData;
            vibrationData = histvibrationData;
            timestampData = histtimestampData;
          });
        }
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
    final userProvider = Provider.of<UserProvider>(context, listen: false);

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
        backgroundColor: Colors.orange,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(18),
              child: Wrap(
                runSpacing: 16,
                children: [
                  ExpansionTile(
                    title: Text('Temps réel'),
                    iconColor: Colors.orange,
                    textColor: Colors.orange,
                    leading: Icon(Icons.monitor_heart),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: ListTile(
                          title: Text('Visualisation'),
                          leading: Icon(Icons.sensors),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MonitoringPage()),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: ListTile(
                          title: Text('Courbes'),
                          iconColor: Colors.orange,
                          textColor: Colors.orange,
                          leading: Icon(Icons.show_chart),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChartsPage()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  ListTile(
                    title: Text('Historique'),
                    leading: Icon(Icons.history),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HistoryPage()),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Prédiction'),
                    leading: Icon(Icons.query_stats),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PredictionPage()),
                      );
                    },
                  ),
                  // const Divider(
                  //   color: Colors.black54,
                  // ),
                  ListTile(
                    title: Text('Paramètres'),
                    leading: Icon(Icons.settings),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsPage()),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('About Us'),
                    leading: Icon(Icons.groups),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SupportPage()),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Log out'),
                    leading: Icon(Icons.logout),
                    onTap: () async {
                      print('userProvider: $userProvider');
                      await userProvider.logout(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SfCartesianChart(
              title: ChartTitle(text: 'Température'),
              primaryXAxis: DateTimeAxis(dateFormat: DateFormat('HH:mm:ss')),
              series: <LineSeries<double, DateTime>>[
                LineSeries<double, DateTime>(
                    dataSource: temperatureData,
                    xValueMapper: (double data, int index) =>
                        timestampData[index],
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
                        timestampData[index],
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
                        timestampData[index],
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
