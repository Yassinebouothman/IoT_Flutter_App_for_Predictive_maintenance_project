import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'FirstPage.dart';
import 'MonitoringPage.dart';
import 'Provider.dart';

class CheckLogin extends StatefulWidget {
  const CheckLogin({Key? key}) : super(key: key);

  @override
  State<CheckLogin> createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
  late StreamSubscription<User?> _authStateChangesSubscription;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  @override
  void dispose() {
    _authStateChangesSubscription.cancel();
    super.dispose();
  }

  void _checkAuthState() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _authStateChangesSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        userProvider.setUser(user);
      } else {
        userProvider.setUser(null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: userProvider.user != null ? MonitoringPage() : FirstPage(),
    );
  }
}
