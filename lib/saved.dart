import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'home.dart';
import '/models/1.dart';
import 'news_detailed.dart';

class Saved extends StatefulWidget {
  const Saved({super.key});

  @override
  State<Saved> createState() => _SavedState();
}

List<int> savedNewsID = [];

void read() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/saved.json');
  savedNewsID = file.readAsBytes() as List<int>;
}

class _SavedState extends State<Saved> {
  final double profileHeight = 144;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
              child: Padding(
            padding: EdgeInsets.fromLTRB(0, 300, 0, 300),
            child: Text('Newsly',
                style: TextStyle(
                  fontFamily: 'Kalam',
                  fontSize: 35,
                  color: Colors.white,
                )),
          )),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 80,
              child: buildProfileImage(),
            ),
            Positioned(
              top: 240,
              child: buildContent(),
            ),
            Column(
              children: [
                const SizedBox(
                  width: 100.0,
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Discord Link',
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    prefixIcon: const Icon(
                      Icons.link,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget buildProfileImage() => CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: Colors.grey.shade800,
        backgroundImage: const NetworkImage(
          'https://unsplash.com/photos/YUu9UAcOKZ4',
        ),
      );

  Widget buildContent() => Column(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          const SizedBox(height: 8),
          const Text(
            'Suman Pandey',
            style: TextStyle(
              fontSize: 28,
            ),
          )
        ],
      );
}
