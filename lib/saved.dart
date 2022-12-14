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
        body: FutureBuilder(
            future: NewsLoading().loadNews(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //initialize newslist
                List<News>? newsList = snapshot.data;
                List<News>? newsListFiltered = snapshot.data
                    ?.where((itm) => savedNewsID.contains(itm.id))
                    .toList();
                return Text('${newsListFiltered?.length}');
                // TODO build a list of saved news stored in newsListFiltered
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}
