import 'package:flutter/material.dart';
import 'package:taskmanager/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      home: HomePage(),
    );
  }
}
