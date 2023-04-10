import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'PredictionPage.dart';
import 'SupportPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ChartsPage.dart';
import 'SettingsPage.dart';
import 'HistoryPage.dart';
import 'package:provider/provider.dart';
import 'Provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import 'Provider.dart';
// import 'package:provider/provider.dart';

class MonitoringPage extends StatefulWidget {
  MonitoringPage({Key? key}) : super(key: key);

  @override
  _MonitoringPageState createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  Timer? _timer;

  double temperature = 0.0;
  double vibration = 0.0;
  double current = 0.0;

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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final useracc = FirebaseAuth.instance.currentUser!;

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Visualisation'),
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
                          iconColor: Colors.orange,
                          textColor: Colors.orange,
                          onTap: () {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: ListTile(
                          title: Text('Courbes'),
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
                      await userProvider.logout(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                      height: 10,
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${temperature.toStringAsFixed(2)} °C',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            //color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 30,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      height: 10,
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${current.toStringAsFixed(2)} A',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            //color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 30,
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
                      height: 10,
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${vibration.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            //color: Colors.red),
                          ),
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
