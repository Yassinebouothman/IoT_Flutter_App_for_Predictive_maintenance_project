import 'package:flutter/material.dart';
import 'SupportPage.dart';
import 'MonitoringPage.dart';
import 'ChartsPage.dart';
import 'SettingsPage.dart';
import 'HistoryPage.dart';
import 'package:provider/provider.dart';
import 'Provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';
//import 'package:awesome_notifications/awesome_notifications.dart';

class PredictionPage extends StatefulWidget {
  const PredictionPage({Key? key}) : super(key: key);
  @override
  State<PredictionPage> createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  Timer? _timer;
  int ttf = 0;
  String anomaly = 'N/A';
  String apiURL =
      'http://192.168.103.195:8080/api/plugins/telemetry/DEVICE/dd79abf0-ce44-11ed-ae1a-a121083348b4/values/timeseries?keys=Time to failure,Anomaly';
  Future<String> _getNewToken() async {
    // Make a POST request to authenticate and obtain a new JWT token
    String authURL = 'http://192.168.103.195:8080/api/auth/login';
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
        var ttfData = data['Time to failure'][0];
        var anomalyData = data['Anomaly'][0];
        // Store the latest values
        if (mounted) {
          setState(() {
            // Handle NaN values
            try {
              ttf = int.parse(ttfData['value']);
            } catch (e) {
              ttf = 0;
            }
            try {
              anomaly = anomalyData['value'];
            } catch (e) {
              anomaly = "N/A";
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

/*
  int createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }

  triggerNotifications() async {
    if (anomaly == "1") {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: createUniqueId(),
          channelKey: 'basic_channel',
          title:
              'Alert ${Emojis.symbols_red_exclamation_mark}${Emojis.symbols_red_exclamation_mark}${Emojis.symbols_red_exclamation_mark}',
          body:
              'panne detectée ${Emojis.symbols_red_exclamation_mark}${Emojis.symbols_red_exclamation_mark}${Emojis.symbols_red_exclamation_mark}',
        ),
      );
    }
  }
*/
  @override
  void initState() {
    super.initState();
    _getSensorData(); // Call the API when the widget is first created
  }

  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final useracc = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: Text('Prediction'),
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
                    iconColor: Colors.orange,
                    textColor: Colors.orange,
                    leading: Icon(Icons.query_stats),
                    onTap: () {},
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  // const SizedBox(
                  //   width: 16.0,
                  // ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Temps d\'échec',
                          style: TextStyle(
                            fontSize: 30,
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
                            '${ttf.toString()} Hours',
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
                height: 45,
              ),
              Column(
                children: [
                  Text(
                    'État d\'équipement',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  if (anomaly == '0')
                    Column(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 64,
                          color: Colors.green,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Aucune panne',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  if (anomaly == '1')
                    Column(
                      children: [
                        Icon(
                          Icons.error,
                          size: 64,
                          color: Colors.red,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Panne detectée',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  SizedBox(
                    width: 16.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
