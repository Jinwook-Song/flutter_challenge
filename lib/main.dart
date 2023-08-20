import 'package:flutter/material.dart';
import 'package:flutter_challenge/views/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MovieType {
  static const String popular = "popular";
  static const String nowPlaying = "now-playing";
  static const String comingSoon = "coming-soon";
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const Home(),
    );
  }
}
