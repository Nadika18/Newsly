import 'package:http/http.dart' as http;

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
    fullBodyTts = json['summary_tts'];
    title = json['title'];
    description = json['body_text'];
    imagePath = json['cover_image'];
    author = json['author_name'];
    categories = json['category_name'];
    summaryTts = json['summary_tts'];
  }

  //toJSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['description'] = description;
    data['author'] = author;
    data['categories'] = categories;
    data['created'] = created;
    data['title'] = title;
    data['language'] = language;
    data['summary'] = summary;
    data['full_body_tts'] = fullBodyTts;
    data['summary_tts'] = summaryTts;
    data['imagePath'] = imagePath;
    return data;
  }
}

// class JsonDatafetch{

//   //fetch json from https://newsly.asaurav.com.np/api/news/
//   Future<String> _fetchJson() async {
//     var url = Uri.parse('https://newsly.asaurav.com.np/api/news/');
//     var response = await http.get(url);
//     var jsonString = response.body;
//     //print
//     print(jsonString);

//  }
// }

 




//save the json file got from http request to assets folder
//   Future<String> _saveJson(String json) async {
//     final directory = await getApplicationDocumentsDirectory();
//     final file = File('${directory.path}/2.json');
//     await file.writeAsString(json);
//     return file.path;
//   }
//


