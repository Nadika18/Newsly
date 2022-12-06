import 'package:flutter/material.dart';

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
      home:Scaffold(
        appBar:AppBar(title:const Text("Newsly")) ,
        body:Column(children: const <Widget>[
          Spacer(),
          ElevatedCard(),
          Spacer(),

        ],)
        )
    );
  }
}

class ElevatedCard extends StatefulWidget {
  const ElevatedCard({super.key});

  @override
  State<ElevatedCard> createState() => _ElevatedCardState();
}

class _ElevatedCardState extends State<ElevatedCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(child: Card(
        child: SizedBox(
          width:300,
          height:100,
          child:Center(child:Text("hello"))
        )
      )
      )
    );
  }
}