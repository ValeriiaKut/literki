import 'package:flutter/material.dart';
import 'package:untitled/views/start_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Literki',
      theme: ThemeData(
        fontFamily: 'Handwriting',
      ),
      home: const StartScreen(),
    );
  }
}