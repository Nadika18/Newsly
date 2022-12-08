import 'package:flutter/material.dart';
import "home.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       theme:ThemeData(
      primarySwatch: Colors.blue,
    ),
      home:const DefaultTabController(
        length:3,
        child:Home()
      ),
     
    );
  }
}

