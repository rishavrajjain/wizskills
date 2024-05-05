import 'package:flutter/material.dart';
import 'package:wizskills/ui/home/home_screen.dart';
import 'package:provider/provider.dart'; // Import Provider package
import 'package:wizskills/provider/speak_provider.dart';

void main() {
  runApp(
    // Wrap your MaterialApp with Provider
    ChangeNotifierProvider(
      create: (context) => SpeakProvider(), // Initialize SpaekProvider
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WizSkills',
      theme: ThemeData(
        fontFamily: "Poppins",
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
