import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'FirstPage.dart';
import 'MonitoringPage.dart';

class CheckLogin extends StatefulWidget {
  const CheckLogin({super.key});

  @override
  State<CheckLogin> createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return MonitoringPage();
          }

          // user is NOT logged in
          else {
            return FirstPage();
          }
        },
      ),
    );
  }
}
