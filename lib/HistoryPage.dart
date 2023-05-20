import 'package:flutter/material.dart';
import 'PredictionPage.dart';
import 'MonitoringPage.dart';
import 'ChartsPage.dart';
import 'SettingsPage.dart';
import 'SupportPage.dart';
import 'package:provider/provider.dart';
import 'Provider.dart';
import 'DatabseHelper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<double> temperatureList = [];
  List<double> currentList = [];
  List<double> vibrationList = [];
  List<DateTime> timestampList = [];

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _loadLastFiveSensorData();
  }

  Future<void> _loadLastFiveSensorData() async {
    try {
      final lastFiveSensorData = await _databaseHelper.getLastFiveSensorData();

      setState(() {
        temperatureList =
            lastFiveSensorData.map((data) => data.temperature).toList();
        currentList = lastFiveSensorData.map((data) => data.current).toList();
        vibrationList =
            lastFiveSensorData.map((data) => data.vibration).toList();
        timestampList =
            lastFiveSensorData.map((data) => data.timestamp).toList();
      });
    } catch (e) {
      print('errorrrr');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final useracc = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Historique'),
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
                    iconColor: Colors.orange,
                    textColor: Colors.orange,
                    leading: Icon(Icons.history),
                    onTap: () {},
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
              SizedBox(
                height: 10,
              ),
              ElevatedButton.icon(
                  onPressed: _loadLastFiveSensorData,
                  icon: Icon(Icons.refresh),
                  label: Text('Actualiser'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 255, 166, 0))),
              SfCartesianChart(
                title: ChartTitle(text: 'Température'),
                primaryXAxis:
                    DateTimeAxis(dateFormat: DateFormat('dd-MM-yy  HH:mm:ss')),
                series: <LineSeries<double, DateTime>>[
                  LineSeries<double, DateTime>(
                      dataSource: temperatureList,
                      xValueMapper: (double data, int index) =>
                          timestampList[index],
                      yValueMapper: (double data, _) => data,
                      color: Colors.red),
                ],
              ),
              SfCartesianChart(
                title: ChartTitle(text: 'Courant'),
                primaryXAxis:
                    DateTimeAxis(dateFormat: DateFormat('dd-MM-yy  HH:mm:ss')),
                series: <LineSeries<double, DateTime>>[
                  LineSeries<double, DateTime>(
                      dataSource: currentList,
                      xValueMapper: (double data, int index) =>
                          timestampList[index],
                      yValueMapper: (double data, _) => data,
                      color: Colors.orange),
                ],
              ),
              SfCartesianChart(
                title: ChartTitle(text: 'Vibration'),
                primaryXAxis:
                    DateTimeAxis(dateFormat: DateFormat('dd-MM-yy  HH:mm:ss')),
                series: <LineSeries<double, DateTime>>[
                  LineSeries<double, DateTime>(
                      dataSource: vibrationList,
                      xValueMapper: (double data, int index) =>
                          timestampList[index],
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
