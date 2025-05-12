import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/pages/home_page.dart';
import 'package:task/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final key = await SharedPreferences.getInstance();
  final statusLogin = key.getBool('statusLogin') ?? false;
  runApp(MyApp(statusLogin: statusLogin,));
}

class MyApp extends StatelessWidget {
  MyApp({required this.statusLogin});
  bool statusLogin;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      home: statusLogin
      ? HomePage()
      : LoginPage(),
    );
  }
}
