import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'MyUtils.dart';
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
  List<double> temperatureData = [];
  List<double> currentData = [];
  List<double> vibrationData = [];
  List<DateTime> timestampData = [];
  int maxDataLength = 50;
  Timer? _timer;

  Future<void> _getSensorlistData() async {
    Timer.periodic(Duration(seconds: 2), (Timer t) async {
      try {
        String JWT = await MyUtils().getAccessToken();
        var response = await http.get(Uri.parse(MyUtils().apiURL),
            headers: {'Authorization': 'Bearer $JWT'});
        var data = json.decode(response.body);
        print(data['Temperature'][0]['ts']);
        var temperatureValue = data['Temperature'][0];
        var vibrationValue = data['Vibration'][0];
        var currentValue = data['Current'][0];
        var timestampValue = data['Temperature'][0]['ts'];

        print(timestampValue);
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
            timestampData.add(
                DateTime.fromMillisecondsSinceEpoch(timestampValue)
                    .add(Duration(hours: 1)));
            try {
              temperatureData.add(double.parse(temperatureValue['value']));
            } catch (e) {
              temperatureData.add(0);
            }
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
            }
            if (vibrationData.length > maxDataLength) {
              vibrationData.removeAt(0);
            }
            if (currentData.length > maxDataLength) {
              currentData.removeAt(0);
            }
            if (timestampData.length > maxDataLength) {
              timestampData.removeAt(0);
            }
          });
        }
        // Call the method that updates the historical data lists
      } on TimeoutException catch (_) {
        _timer?.cancel();
        print('Timout error');

        // Call the method that updates the historical data lists
      } on SocketException {
        _timer?.cancel();
        print('Socket error');
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
    final useracc = FirebaseAuth.instance.currentUser!;
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
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.orange),
              accountName: Text(
                  useracc.email!.substring(0, useracc.email!.indexOf('@'))),
              accountEmail: Text(useracc.email!),
              currentAccountPicture: CircleAvatar(
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.orange,
                ),
                backgroundColor: Color(0xFFFFFFFFF),
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
                    initiallyExpanded: true,
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
                    title: Text('À Propos'),
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
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background7.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
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
      ),
    );
  }
}
