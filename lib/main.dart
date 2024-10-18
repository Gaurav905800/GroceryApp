import 'package:flutter/material.dart';
import 'package:grocery_app/pages/splash_screen.dart';
import 'package:grocery_app/pages/tabs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 248, 3, 89)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
