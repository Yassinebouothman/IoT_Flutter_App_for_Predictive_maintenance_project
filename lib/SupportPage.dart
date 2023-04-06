import 'package:flutter/material.dart';
import 'PredictionPage.dart';
import 'MonitoringPage.dart';
import 'ChartsPage.dart';
import 'SettingsPage.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);
  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
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
              title: Text('About Us'),
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
            Text(
              'Notre projet de maintenance prédictive est le résultat d\'une collaboration entre une équipe d\'étudiants ingénieurs en mécatronique à l\'ULT passionnés par l\'exploitation de la puissance de la technologie pour stimuler l\'innovation et l\'efficacité dans les pratiques de maintenance industrielle. \nGrâce à une compréhension approfondie des défis auxquels sont confrontées les équipes de maintenance, nous avons développé un système intelligent qui combine des algorithmes d\'apprentissage automatique, des capteurs IoT et des analyses en temps réel pour prévoir les pannes d\'équipement et permettre des stratégies de maintenance proactives. \nNotre objectif est d\'aider les entreprises à réduire les temps d\'arrêt, à augmenter la productivité et à optimiser les coûts de maintenance, ce qui se traduit par une amélioration des performances opérationnelles et une rentabilité accrue.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, height: 1.5),
            ),
            SizedBox(height: 70),
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
