class Category {
  final int id;
  final String slug;
  final String date;
  final String image;
  final List<Translation> translations;

  Category(
      {required this.id,
      required this.slug,
      required this.image,
      required this.date,
      required this.translations});

  factory Category.fromJson(Map<String, dynamic> json) {
    var list = json['translations'] as List;
    List<Translation> translationsList =
        list.map((i) => Translation.fromJson(i)).toList();

    return Category(
      id: json['id'],
      slug: json['slug'],
      image: json['image'],
      date: json['date'],
      translations: translationsList,
    );
  }
}

class Translation {
  final int id;
  final String categoryId;
  final String language;
  final String name;
  final String description;

  Translation(
      {required this.id,
      required this.categoryId,
      required this.language,
      required this.name,
      required this.description});

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      id: json['id'],
      categoryId: json['category_id'],
      language: json['language'],
      name: json['name'],
      description: json['description'],
    );
  }
}
