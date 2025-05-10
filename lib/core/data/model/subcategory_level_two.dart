class SubcategoryLevelTwo {
  final int id;
  final int subCategoryLevelOneId;
  final String slug;
  final String date;
  final List<Translation> translations;

  SubcategoryLevelTwo({
    required this.id,
    required this.subCategoryLevelOneId,
    required this.slug,
    required this.date,
    required this.translations,
  });

  factory SubcategoryLevelTwo.fromJson(Map<String, dynamic> json) {
    var list = json['translations'] as List;
    List<Translation> translationsList =
        list.map((i) => Translation.fromJson(i)).toList();

    return SubcategoryLevelTwo(
      id: int.tryParse(json['id'].toString()) ?? 0, // تحويل 'id' إلى int
      subCategoryLevelOneId:
          int.tryParse(json['sub_category_level_one_id'].toString()) ??
              0, // تحويل 'sub_category_level_one_id' إلى int
      slug: json['slug'],
      date: json['date'],
      translations: translationsList,
    );
  }
}

class Translation {
  final int id;
  final int subCategoryLevelTwoId;
  final String language;
  final String name;

  Translation({
    required this.id,
    required this.subCategoryLevelTwoId,
    required this.language,
    required this.name,
  });

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      id: int.tryParse(json['id'].toString()) ?? 0, // تحويل 'id' إلى int
      subCategoryLevelTwoId:
          int.tryParse(json['sub_category_level_two_id'].toString()) ??
              0, // تحويل 'sub_category_level_two_id' إلى int
      language: json['language'],
      name: json['name'],
    );
  }
}
