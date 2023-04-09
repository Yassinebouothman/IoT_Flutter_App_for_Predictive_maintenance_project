import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'FirstPage.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  User? get user => _user;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  Future<void> clearSessionState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('session state cleared');
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    _user = null;
    clearSessionState();
    notifyListeners();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => FirstPage()),
    );
  }
}
