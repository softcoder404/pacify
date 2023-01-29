import 'package:flutter/material.dart';
import 'package:placify/core/config.dart';
import 'package:placify/presentations/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Placify',
      debugShowCheckedModeBanner: AppKeys.isDebug,
      theme: ThemeData.light(),
      home: const HomeScreen(),
    );
  }
}
