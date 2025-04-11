import 'package:flutter/material.dart';
import 'Screens/Spalsing_Screen.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // Removes the debug banner
      home: SplashingScreen(),
    );
  }
}


