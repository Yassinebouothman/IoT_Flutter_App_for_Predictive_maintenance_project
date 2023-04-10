import 'package:flutter/material.dart';
import 'PredictionPage.dart';
import 'MonitoringPage.dart';
import 'ChartsPage.dart';
import 'SettingsPage.dart';
import 'HistoryPage.dart';
import 'package:provider/provider.dart';
import 'Provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);
  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final useracc = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Text('À Propos'),
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
                    iconColor: Colors.orange,
                    textColor: Colors.orange,
                    leading: Icon(Icons.groups),
                    onTap: () {},
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
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Image(
              image: AssetImage('images/engine.png'),
              width: 70,
              height: 70,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Notre projet de maintenance prédictive est le résultat d\'une collaboration entre une équipe d\'étudiants ingénieurs en mécatronique à l\'ULT passionnés par l\'exploitation de la puissance de la technologie pour stimuler l\'innovation et l\'efficacité dans les pratiques de maintenance industrielle. \n\nGrâce à une compréhension approfondie des défis auxquels sont confrontées les équipes de maintenance, nous avons développé un système intelligent qui combine des algorithmes d\'apprentissage automatique, des capteurs IoT et des analyses en temps réel pour prévoir les pannes d\'équipement et permettre des stratégies de maintenance proactives. \n\nNotre objectif est d\'aider les entreprises à réduire les temps d\'arrêt, à augmenter la productivité et à optimiser les coûts de maintenance, ce qui se traduit par une amélioration des performances opérationnelles et une rentabilité accrue.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, height: 1.5),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Email: yassine.bouothman@ult-tunisie.com\n'
              'Téléphone ou WhatsApp: +216 95 593 167\n'
              'Addresse: Hay khadra, Tunis, Tunisie',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16, height: 1.5, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
