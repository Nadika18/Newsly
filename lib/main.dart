import 'package:flutter/material.dart';
import "nav.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';

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
    FlutterUxcam.optIntoSchematicRecordings();
    FlutterUxcam.startWithKey("UX_CAM_KEY");

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.ubuntuTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.lightBlue,
      ),
      home: const Nav(),
    );
  }
}
