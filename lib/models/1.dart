// // ignore: file_names
// class News {
//   late String title;
//   late String description;
//   late String imagePath;
//   late String author;

//   News(
//       {required this.title,
//       required this.description,
//       required this.imagePath,
//       required this.author});
//   factory News.fromJson(Map<String, dynamic> data) {
//     return News(
//         title: data['title'],
//         description: data['description'],
//         imagePath: data['imagePath'],
//         author: data['author']);
//   }
// }

class News {
  late String title;
  late String description;
  late String imagePath;
  late String author;
  late String categories;
  late List<String> categoriesList;

  News(
      {required this.title,
      required this.description,
      required this.imagePath,
      required this.author,
      required this.categories,
      required this.categoriesList});

  News.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    imagePath = json['imagePath'];
    author = json['author'];
    categories = json['categories'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['imagePath'] = this.imagePath;
    data['author'] = this.author;
    return data;
  }
}
