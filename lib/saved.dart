import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'home.dart';
import '/models/1.dart';
import 'news_detailed.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Saved extends StatefulWidget {
  const Saved({super.key});

  @override
  State<Saved> createState() => _SavedState();
}

List<int> savedNewsID = [];
late String link;

void read() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/saved.json');
  savedNewsID = file.readAsBytes() as List<int>;
}

class _SavedState extends State<Saved> {
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  final double profileHeight = 144;
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset('assets/user.jpg'),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Suman Karki',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the webhook';
                          }
                          return null;
                        },
                        controller: myController,
                        decoration: const InputDecoration(
                          label: Text('Discord Webhook'),
                          prefixIcon: Icon(Icons.discord_outlined),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: 120,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setWebHook(myController.text);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue,
                            side: BorderSide.none,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text('Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              )),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

Future<http.Response> setWebHook(String url) {
  return http.post(
    Uri.parse('https://newsly.asaurav.com.np/api/user/webhook'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'user': 'aabhusan',
      'url': url,
    }),
  );
}
