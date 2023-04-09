import 'package:flutter/material.dart';
import 'PredictionPage.dart';
import 'MonitoringPage.dart';
import 'ChartsPage.dart';
import 'SettingsPage.dart';
import 'SupportPage.dart';
import 'package:provider/provider.dart';
import 'Provider.dart';
import 'DatabseHelper.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text('Historique'),
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
                          MaterialPageRoute(
                              builder: (context) => SettingsPage()),
                        );
                      },
                    ),
                    ListTile(
                      title: Text('About Us'),
                      leading: Icon(Icons.groups),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SupportPage()),
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
        body: Center());
  }
}
