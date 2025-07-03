class PackageModel {
  final int packageId;
  final String packageName;
  final String packageDescription;
  final String price;
  final String packageType;
  final int duration;
  final String? createdAt;
  final String? updatedAt;
  final List<Translation> translations;
  final List<Feature> features;

  PackageModel({
    required this.packageId,
    required this.packageName,
    required this.packageDescription,
    required this.price,
    required this.packageType,
    required this.duration,
    this.createdAt,
    this.updatedAt,
    required this.translations,
    required this.features,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      packageId: int.parse(json['package_id'].toString()), // تحويل إلى int
      packageName: json['package_name'].toString(),
      packageDescription: json['package_description'].toString(),
      price: json['price'].toString(), // تحويل إلى String لضمان التوافق
      packageType: json['package_type'].toString(),
      duration:
          int.tryParse(json['duration'].toString()) ?? 0, // تجنب حدوث أخطاء
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      translations: (json['translations'] as List)
          .map((item) => Translation.fromJson(item))
          .toList(),
      features: (json['features'] as List)
          .map((item) => Feature.fromJson(item))
          .toList(),
    );
  }
}

class Translation {
  final int translationId;
  final int packageId;
  final String language;
  final String translatedName;
  final String translatedDescription;

  Translation({
    required this.translationId,
    required this.packageId,
    required this.language,
    required this.translatedName,
    required this.translatedDescription,
  });

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      translationId: int.parse(json['translation_id'].toString()),
      packageId: int.parse(json['package_id'].toString()),
      language: json['language'].toString(),
      translatedName: json['translated_name'].toString(),
      translatedDescription: json['translated_description'].toString(),
    );
  }
}

class Feature {
  final int featureId;
  final int packageId;
  final String featureKey;
  final String? createdAt;
  final List<FeatureTranslation> featureTranslations;

  Feature({
    required this.featureId,
    required this.packageId,
    required this.featureKey,
    this.createdAt,
    required this.featureTranslations,
  });

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      featureId: int.parse(json['feature_id'].toString()),
      packageId: int.parse(json['package_id'].toString()),
      featureKey: json['feature_key'].toString(),
      createdAt: json['created_at']?.toString(),
      featureTranslations: (json['package_feature_translation'] as List)
          .map((item) => FeatureTranslation.fromJson(item))
          .toList(),
    );
  }
}

class FeatureTranslation {
  final int translationId;
  final int featureId;
  final String language;
  final String translatedText;

  FeatureTranslation({
    required this.translationId,
    required this.featureId,
    required this.language,
    required this.translatedText,
  });

  factory FeatureTranslation.fromJson(Map<String, dynamic> json) {
    return FeatureTranslation(
      translationId: int.parse(json['translation_id'].toString()),
      featureId: int.parse(json['feature_id'].toString()),
      language: json['language'].toString(),
      translatedText: json['translated_text'].toString(),
    );
  }
}
