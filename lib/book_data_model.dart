class BookDataModel {
  String? author;
  String? country;
  String? imageLink;
  String? language;
  String? link;
  int? pages;
  String? title;
  int? year;

  BookDataModel({
    this.author,
    this.country,
    this.imageLink,
    this.language,
    this.link,
    this.pages,
    this.title,
    this.year
  });

  BookDataModel.fromJson(Map<String, dynamic> json) {
    author = json['author'];
    country = json['country'];
    imageLink = json['imageLink'];
    language = json['language'];
    link = json['link'];
    pages = json['pages'];
    title = json['title'];
    year = json['year'];
  }
}