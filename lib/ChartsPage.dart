import 'package:flutter/material.dart';
import 'SupportPage.dart';
import 'MonitoringPage.dart';
import 'SettingsPage.dart';
import 'PredictionPage.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'Provider.dart';
import 'package:provider/provider.dart';

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
  // final MonitoringPage mopa = new MonitoringPage();
  // mopa._sensorsdata();
  // List<SensorData> temperatureData = [];
  // List<SensorData> currentData = [];
  // List<SensorData> vibrationData = [];
  @override
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

  Widget build(BuildContext context) {
    final sensorDataProvider =
        Provider.of<SensorDataProvider>(context, listen: true);

// Access the sensor data
    List<double> temperatureData = sensorDataProvider.temperatureData;
    List<double> vibrationData = sensorDataProvider.vibrationData;
    List<double> currentData = sensorDataProvider.currentData;

// Start fetching data
    sensorDataProvider.startFetchingData();
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
                  color: Colors.red,
                  dataSource: temperatureData,
                  xValueMapper: (double data, _) => DateTime.now(),
                  yValueMapper: (double data, _) => data,
                ),
              ],
            ),
            SfCartesianChart(
              title: ChartTitle(text: 'Courant'),
              primaryXAxis: DateTimeAxis(),
              series: <LineSeries<double, DateTime>>[
                LineSeries<double, DateTime>(
                  color: Colors.orange,
                  dataSource: currentData,
                  xValueMapper: (double data, _) => DateTime.now(),
                  yValueMapper: (double data, _) => data,
                ),
              ],
            ),
            SfCartesianChart(
              title: ChartTitle(text: 'Vibration'),
              primaryXAxis: DateTimeAxis(),
              series: <LineSeries<double, DateTime>>[
                LineSeries<double, DateTime>(
                  color: Colors.green,
                  dataSource: vibrationData,
                  xValueMapper: (double data, _) => DateTime.now(),
                  yValueMapper: (double data, _) => data,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
