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
    title = json['title'];
    description = json['body_text'];
    imagePath = json['imagePath'];
    author = json['author'];
    categories = json['categories'];
  }
}
