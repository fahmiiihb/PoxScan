import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() => runApp(PoxScan());

class PoxScan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PoxScan',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(),
    );
  }
}