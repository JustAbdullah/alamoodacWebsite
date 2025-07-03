class SubcategoryLevelOne {
  final int id;
  final String categoryId; // String لأن القيمة "4" في الاستجابة
  final String slug;
  final DateTime date;
  final List<Translation> translations;

  SubcategoryLevelOne({
    required this.id,
    required this.categoryId,
    required this.slug,
    required this.date,
    required this.translations,
  });

  // تحويل الـ JSON إلى موديل SubcategoryLevelOne
  factory SubcategoryLevelOne.fromJson(Map<String, dynamic> json) {
    var translationsFromJson = json['translations'] as List;
    List<Translation> translationsList = translationsFromJson
        .map((translationJson) => Translation.fromJson(translationJson))
        .toList();

    return SubcategoryLevelOne(
      id: json['id'],
      categoryId: json['category_id'], // تحويل مباشرة بدون تعديل
      slug: json['slug'],
      date: DateTime.parse(json['date']),
      translations: translationsList,
    );
  }

  // تحويل الموديل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'slug': slug,
      'date': date.toIso8601String(),
      'translations':
          translations.map((translation) => translation.toJson()).toList(),
    };
  }
}

class Translation {
  final int id;
  final String subCategoryLevelOneId; // String لأن القيمة "1" في الاستجابة
  final String language;
  final String name;

  Translation({
    required this.id,
    required this.subCategoryLevelOneId,
    required this.language,
    required this.name,
  });

  // تحويل الـ JSON إلى موديل Translation
  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      id: json['id'],
      subCategoryLevelOneId:
          json['sub_category_level_one_id'], // تحويل مباشرة بدون تعديل
      language: json['language'],
      name: json['name'],
    );
  }

  // تحويل الموديل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sub_category_level_one_id': subCategoryLevelOneId,
      'language': language,
      'name': name,
    };
  }
}
