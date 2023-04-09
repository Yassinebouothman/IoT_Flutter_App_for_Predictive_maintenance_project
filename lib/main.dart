import 'package:flutter/material.dart';
import 'package:predictive_maintenance_app/check_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'Provider.dart';

// import 'package:provider/provider.dart';
// import 'Provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
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
