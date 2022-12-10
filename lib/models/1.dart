class News {
  late String title;
  late String description;
  late String imagePath;
  late String author;

  News({required this.title, required this.description, required this.imagePath,required  this.author});

  News.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    imagePath = json['imagePath'];
    author = json['author'];
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
