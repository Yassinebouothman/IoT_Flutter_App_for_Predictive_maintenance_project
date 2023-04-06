import 'dart:io';
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
  Timer? _timer;

  // sign user out method
  void signUserOut() async {
    FirebaseAuth.instance.signOut();
  }

  double temperature = 0.0;
  double vibration = 0.0;
  double current = 0.0;

  String apiURL =
      'http://192.168.1.19:8080/api/plugins/telemetry/DEVICE/dd79abf0-ce44-11ed-ae1a-a121083348b4/values/timeseries?keys=Temperature,Vibration,Current';

  Future<String> _getNewToken() async {
    // Make a POST request to authenticate and obtain a new JWT token
    String authURL = 'http://192.168.1.19:8080/api/auth/login';
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

  Future<void> _getSensorData() async {
    // Parse the response JSON to extract the sensor values
    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) async {
      try {
        String JWT = await _getAccessToken();
        var response = await http
            .get(Uri.parse(apiURL), headers: {'Authorization': 'Bearer $JWT'});
        var data = json.decode(response.body);
        var temperatureData = data['Temperature'][0];
        var vibrationData = data['Vibration'][0];
        var currentData = data['Current'][0];

        // Store the latest values
        if (mounted) {
          setState(() {
            try {
              temperature = double.parse(temperatureData['value']);
              // Handle non-NaN value
            } catch (e) {
              // Handle NaN value
              temperature = 0.0;
            }
            try {
              vibration = double.parse(vibrationData['value']);
            } catch (e) {
              vibration = 0.0;
            }
            try {
              current = double.parse(currentData['value']);
            } catch (e) {
              current = 0.0;
            }
          });
        }
      } on TimeoutException {
        _timer?.cancel();
        // If a connection error occurs, display the latest values
      } on SocketException {
        _timer?.cancel();
      }
    });
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
              title: Text('About Us'),
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
              height: 70,
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
                        'Température',
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
              height: 40,
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
              height: 40,
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
