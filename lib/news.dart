import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class News {
  int? id;
  String? bodyText;
  Author? author;
  List<Tags>? tags;
  Tags? category;
  String? created;
  String? title;
  String? language;
  String? summary;
  String? fullBodyTts;
  String? summaryTts;
  Null? metadata;

  News(
      {this.id,
      this.bodyText,
      this.author,
      this.tags,
      this.category,
      this.created,
      this.title,
      this.language,
      this.summary,
      this.fullBodyTts,
      this.summaryTts,
      this.metadata});

  News.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bodyText = json['body_text'];
    author =
        json['author'] != null ? new Author.fromJson(json['author']) : null;
    if (json['tags'] != null) {
      tags = <Tags>[];
      json['tags'].forEach((v) {
        tags!.add(new Tags.fromJson(v));
      });
    }
    category =
        json['category'] != null ? new Tags.fromJson(json['category']) : null;
    created = json['created'];
    title = json['title'];
    language = json['language'];
    summary = json['summary'];
    fullBodyTts = json['full_body_tts'];
    summaryTts = json['summary_tts'];
    metadata = json['metadata'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['body_text'] = this.bodyText;
    if (this.author != null) {
      data['author'] = this.author!.toJson();
    }
    if (this.tags != null) {
      data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    data['created'] = this.created;
    data['title'] = this.title;
    data['language'] = this.language;
    data['summary'] = this.summary;
    data['full_body_tts'] = this.fullBodyTts;
    data['summary_tts'] = this.summaryTts;
    data['metadata'] = this.metadata;
    return data;
  }
}

class Author {
  String? firstName;
  String? lastName;
  String? email;

  Author({this.firstName, this.lastName, this.email});

  Author.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    return data;
  }
}

class Tags {
  int? id;
  String? descriptionText;
  String? name;

  Tags({this.id, this.descriptionText, this.name});

  Tags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descriptionText = json['description_text'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description_text'] = this.descriptionText;
    data['name'] = this.name;
    return data;
  }
}

class NewsApi {
  static Future<List<News>> getNews() async {
    var url = Uri.parse('https://newsly.asaurav.com.np/api/news/');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      List<News> newsList = [];
      for (var news in jsonMap) {
        newsList.add(News.fromJson(news));
      }
      return newsList;
    } else {
      throw Exception('Failed to load news');
    }
  }
}

class NewsList extends StatefulWidget {
  const NewsList({super.key});

  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
      ),
      body: FutureBuilder(
        future: NewsApi.getNews(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<News>? newsList = snapshot.data as List<News>?;
            return ListView.builder(
              itemCount: newsList!.length,
              itemBuilder: (context, index) {
                News news = newsList[index];
                return ListTile(
                  title: Text(news.title!),
                  subtitle: Text(news.summary!),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
