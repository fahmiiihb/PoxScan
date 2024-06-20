import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() => runApp(const PoxScan());

class PoxScan extends StatelessWidget {
  const PoxScan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PoxScan',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(),
    );
  }
}