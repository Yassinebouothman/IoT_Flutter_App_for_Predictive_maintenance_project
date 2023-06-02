import 'package:flutter/material.dart';
import 'package:predictive_maintenance_app/check_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
//import 'package:awesome_notifications/awesome_notifications.dart';
//import 'firebase_options.dart';
import 'Provider.dart';

// import 'package:provider/provider.dart';
// import 'Provider.dart';

void main() async {
  /*
  AwesomeNotifications().initialize(
    'resource://drawable/res_motor',
    //null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'basic notifications',
        channelDescription: 'notification channel for basic tests',
        defaultColor: Colors.teal,
        importance: NotificationImportance.High,
        channelShowBadge: true,
      ),
    ],
    debug: true,
  );*/
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyBrnsP8q7fsvWG1BsVgeB-kkDYzg0Trqzs",
        appId: "1:858173552428:android:9a16e550f8ff2a29f1de89",
        messagingSenderId: "858173552428",
        projectId: "authpart-3f1d3"),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Consumer<UserProvider>(
          builder: (context, userProvider, _) {
            return CheckLogin();
          },
        ),
      ),
    );
  }
}
