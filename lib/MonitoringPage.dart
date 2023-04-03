import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'PredictionPage.dart';
import 'SupportPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ChartsPage.dart';
import 'SettingsPage.dart';
// import 'Provider.dart';
// import 'package:provider/provider.dart';

class MonitoringPage extends StatefulWidget {
  MonitoringPage({Key? key}) : super(key: key);

  @override
  _MonitoringPageState createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  // sign user out method
  void signUserOut() async {
    FirebaseAuth.instance.signOut();
  }

  double temperature = 0.0;
  double vibration = 0.0;
  double current = 0.0;

  String apiURL =
      'http://192.168.1.19:8080/api/plugins/telemetry/DEVICE/dd79abf0-ce44-11ed-ae1a-a121083348b4/values/timeseries?keys=Temperature,Vibration,Current';
  String JWT =
      'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0ZW5hbnRAdGhpbmdzYm9hcmQub3JnIiwidXNlcklkIjoiM2E5MTkyMTAtMTBiZi0xMWVkLWJjNDAtMGQ3NGI5ZjIzM2IzIiwic2NvcGVzIjpbIlRFTkFOVF9BRE1JTiJdLCJpc3MiOiJ0aGluZ3Nib2FyZC5pbyIsImlhdCI6MTY4MDUzNDA0MywiZXhwIjoxNjgwNTQzMDQzLCJlbmFibGVkIjp0cnVlLCJpc1B1YmxpYyI6ZmFsc2UsInRlbmFudElkIjoiM2EyODQ4ZjAtMTBiZi0xMWVkLWJjNDAtMGQ3NGI5ZjIzM2IzIiwiY3VzdG9tZXJJZCI6IjEzODE0MDAwLTFkZDItMTFiMi04MDgwLTgwODA4MDgwODA4MCJ9.PoWGVjfUFPSVJp6KLQYzo4GhA4b5W96sXVO-jgTJKiEnOejId4cpLYCAqx2TNPQdp4qkP0edyLDDxG3G_xZ96g';

  Future<void> _getSensorData() async {
    // Parse the response JSON to extract the sensor values
    Timer.periodic(Duration(seconds: 5), (Timer t) async {
      var response =
          await http.get(Uri.parse(apiURL), headers: {'Authorization': JWT});
      var data = json.decode(response.body);
      var temperatureData = data['Temperature'][0];
      var vibrationData = data['Vibration'][0];
      var currentData = data['Current'][0];
      if (mounted) {
        setState(() {
          temperature = double.parse(temperatureData['value']);
          vibration = double.parse(vibrationData['value']);
          current = double.parse(currentData['value']);
        });
      }
    });

    // Update the state with the new sensor values
  }

  @override
  void initState() {
    super.initState();
    _getSensorData(); // Call the API when the widget is first created
  }

  @override
  Widget build(BuildContext context) {
    //provider code
//     final sensorDataProvider =
//         Provider.of<SensorDataProvider>(context, listen: true);

// // Access the sensor data
//     double temperature = sensorDataProvider.temperature;
//     double vibration = sensorDataProvider.vibration;
//     double current = sensorDataProvider.current;

// // Start fetching data
//     sensorDataProvider.startFetchingData();

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Visualisation'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
            ),
            ListTile(
              title: Text('Visualisation'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MonitoringPage()),
                );
              },
            ),
            ListTile(
              title: Text('Courbes'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChartsPage()),
                );
              },
            ),
            ListTile(
              title: Text('Prédiction'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PredictionPage()),
                );
              },
            ),
            ListTile(
              title: Text('Paramètres'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
            ListTile(
              title: Text('Support'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SupportPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            Column(
              children: [
                Icon(
                  Icons.thermostat_outlined,
                  size: 64,
                  color: Colors.red,
                ),
                // const SizedBox(
                //   width: 16.0,
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Temperature',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Center(
                      child: Text(
                        '${temperature.toStringAsFixed(1)}°C',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Column(
              children: [
                Icon(
                  Icons.flash_on_outlined,
                  size: 64,
                  color: Colors.orangeAccent,
                ),
                SizedBox(
                  width: 16.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Courant',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Center(
                      child: Text(
                        '${current.toStringAsFixed(1)}A',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 25.0,
            ),
            Column(
              children: [
                Icon(
                  Icons.vibration_outlined,
                  size: 64,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 16.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Vibration',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Center(
                      child: Text(
                        '${vibration.toStringAsFixed(1)}',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
