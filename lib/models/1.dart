// ignore: file_names
class News {
  late String title;
  late String description;
  late String imagePath;
  late String author;

  News(
      {required this.title,
      required this.description,
      required this.imagePath,
      required this.author});
  factory News.fromJson(Map<String, dynamic> data) {
    return News(
        title: data['title'],
        description: data['description'],
        imagePath: data['imagePath'],
        author: data['author']);
  }
}
