import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class News {
  late int id;
  late String description;
  late String author;
  late String categories;
  late List<String> categoriesList;
  late String created;
  late String title;
  late String language;
  late String summary;
  late String fullBodyTts;
  late String summaryTts;
  late String imagePath;

  News({
    required this.id,
    required this.description,
    required this.author,
    required this.categories,
    required this.categoriesList,
    required this.created,
    required this.title,
    required this.language,
    required this.summary,
    required this.fullBodyTts,
    required this.summaryTts,
    required this.imagePath,
  });

  News.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullBodyTts = json['full_body_tts'];
    title = json['title'];
    description = json['body_text'];
    imagePath = json['cover_image'];
    author = json['author_name'];
    categories = json['category_name'];
    imagePath = json['cover_image'];
    author = json['author_name'];
    categories = json['category_name'];
    summaryTts = json['summary_tts'];
    fullBodyTts = json['full_body_tts'];
    created = json['created_str'];
    summary = json['summary'];
    language = json['language'];
  }

  //toJSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['description'] = description;
    data['author'] = author;
    data['categories'] = categories;
    data['created_str'] = created;
    data['title'] = title;
    data['language'] = language;
    data['summary'] = summary;
    data['full_body_tts'] = fullBodyTts;
    data['summary_tts'] = summaryTts;
    data['imagePath'] = imagePath;
    return data;
  }
}

//save the json file got from http request to assets folder
class SaveJson {
  //fetch json from https://newsly.asaurav.com.np/api/news/
  String username = "aabhusan";
  Future fetchJsonSummary() async {
    var url = Uri.parse(
        'https://newsly.asaurav.com.np/api/relevant-news/?username=${username}');
    var response = await http.get(url);
    var jsonString = utf8.decode(response.bodyBytes);
    print(jsonString);
    //save this json to assets file 2.json in assets folder
    final directory = await getApplicationDocumentsDirectory();
    print("Hello");
    print(directory.path);
    final file = File('${directory.path}/summary.json');
    file.writeAsString(jsonString);
    final contents = await file.readAsString();
    return contents;
  }

  Future fetchJson() async {
    var url = Uri.parse('https://newsly.asaurav.com.np/api/news/');
    var response = await http.get(url);
    var jsonString = utf8.decode(response.bodyBytes);
    //save this json to assets file 2.json in assets folder
    final directory = await getApplicationDocumentsDirectory();
    print("Hello");
    print(directory.path);
    final file = File('${directory.path}/2.json');
    file.writeAsString(jsonString);
    final contents = await file.readAsString();
    print(contents);
    return contents;
  }
}

class SaveJsonfile extends StatelessWidget {
  const SaveJsonfile({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SaveJson().fetchJson(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            child: Text('saved'),
          );
        } else {
          return Container(
            child: Text('not saved'),
          );
        }
      },
    );
  }
}
