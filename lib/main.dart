import 'package:flutter/material.dart';
import 'package:newsportal/home.dart';
import "nav.dart";
// import "news.dart";
// import "models/1.dart";

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
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const Nav(),
      // home: const SaveJsonfile()
      // home: const Js
      // home: ElevatedCard();
      // home: const NewsList(),
    );
  }
}
