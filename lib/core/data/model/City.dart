class TheCity {
  int id;
  String slug;
  String country;
  String createdAt;
  String updatedAt;
  List<Translation> translations;

  TheCity({
    required this.id,
    required this.slug,
    required this.country,
    required this.createdAt,
    required this.updatedAt,
    required this.translations,
  });

  factory TheCity.fromJson(Map<String, dynamic> json) {
    return TheCity(
      id: json['id'],
      slug: json['slug'] ?? '',
      country: json['country'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      translations: (json['translations'] as List)
          .map((t) => Translation.fromJson(t))
          .toList(),
    );
  }
}

class Translation {
  int id;
  int cityId; // تأكد من أن cityId من النوع int
  String language;
  String name;

  Translation({
    required this.id,
    required this.cityId,
    required this.language,
    required this.name,
  });

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      id: json['id'],
      cityId:
          int.tryParse(json['city_id'].toString()) ?? 0, // تحويل النص إلى رقم
      language: json['language'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
