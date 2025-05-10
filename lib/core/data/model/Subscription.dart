import 'package:intl/intl.dart';

class Subscription {
  final int subscriptionId;
  final String userId;
  final String packageId;
  final String subscriptionCode;
  final DateTime startDate;
  final DateTime endDate; 
   final int selectedTheId;
  final String selectedSections;
  final int adsLimit;
  final int usedAds;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User user;
  final Package package;
  final int allowed_accounts;  


  Subscription({
    required this.subscriptionId,
    required this.userId,
    required this.packageId,
    required this.subscriptionCode,
    required this.startDate,
    required this.endDate,
    required this.selectedSections,  
   required this.selectedTheId,
    required this.adsLimit,
    required this.usedAds,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.package,
    required this.allowed_accounts,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      subscriptionId: _parseInt(json['subscription_id']),
      userId: _parseString(json['user_id'], defaultValue: '0'),
      packageId: _parseString(json['package_id'], defaultValue: '0'),
      subscriptionCode: _parseString(json['subscription_code'],   defaultValue: 'sub_${DateTime.now().millisecondsSinceEpoch}'),
      startDate: _parseDateTime(json['start_date']),
      endDate: _parseDateTime(json['end_date']),
      selectedSections: _parseString(json['selected_sections']),
      adsLimit: _parseInt(json['ads_limit']),
      usedAds: _parseInt(json['used_ads']),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      user: User.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
      package: Package.fromJson(json['package'] as Map<String, dynamic>? ?? {}),
         allowed_accounts: _parseInt(json['allowed_accounts'],defaultValue: 0),
      selectedTheId: _parseInt(json['section_id']),

    );
  }

  Map<String, dynamic> toJson() {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    return {
      'subscription_id': subscriptionId,
      'user_id': userId,
      'package_id': packageId,
      'subscription_code': subscriptionCode,
      'start_date': dateFormat.format(startDate),
      'end_date': dateFormat.format(endDate),
      'selected_sections': selectedSections,
      'ads_limit': adsLimit,
      'used_ads': usedAds,
      'created_at': dateFormat.format(createdAt),
      'updated_at': dateFormat.format(updatedAt),
      'user': user.toJson(),
      'package': package.toJson(),
    'allowed_accounts':allowed_accounts,
    'section_id':selectedTheId
    };
  }

  static int _parseInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  static double _parseDouble(dynamic value, {double defaultValue = 0.0}) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  static bool _parseBool(dynamic value, {bool defaultValue = false}) {
    if (value == null) return defaultValue;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return defaultValue;
  }

  static String _parseString(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    if (value is String) return value;
    return value.toString();
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

}

class User {
  final int id;
  final String name;
  final String password;
  final String phone;
  final DateTime date;
  final double? latitude;
  final double? longitude;
  final bool isDelete;
  final bool isBlock;
  final String? securityQuestion1;
  final String? securityQuestion2;
  final String? securityAnswer1;
  final String? securityAnswer2;
  final bool isVerified;

  User({
    required this.id,
    required this.name,
    required this.password,
    required this.phone,
    required this.date,
    this.latitude,
    this.longitude,
    required this.isDelete,
    required this.isBlock,
    this.securityQuestion1,
    this.securityQuestion2,
    this.securityAnswer1,
    this.securityAnswer2,
    required this.isVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: Subscription._parseInt(json['id']),
      name: Subscription._parseString(json['name'], defaultValue: 'غير معروف'),
      password: Subscription._parseString(json['password']),
      phone: Subscription._parseString(json['phone']),
      date: Subscription._parseDateTime(json['date']),
      latitude: Subscription._parseDouble(json['latitude']),
      longitude: Subscription._parseDouble(json['longitude']),
      isDelete: Subscription._parseBool(json['is_delete']),
      isBlock: Subscription._parseBool(json['is_block']),
      securityQuestion1: Subscription._parseString(json['security_question_1']),
      securityQuestion2: Subscription._parseString(json['security_question_2']),
      securityAnswer1: Subscription._parseString(json['security_answer_1']),
      securityAnswer2: Subscription._parseString(json['security_answer_2']),
      isVerified: Subscription._parseBool(json['is_verified']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'password': password,
      'phone': phone,
      'date': date.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'is_delete': isDelete ? '1' : '0',
      'is_block': isBlock ? '1' : '0',
      'security_question_1': securityQuestion1,
      'security_question_2': securityQuestion2,
      'security_answer_1': securityAnswer1,
      'security_answer_2': securityAnswer2,
      'is_verified': isVerified ? '1' : '0',
    };
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return false;
  }
}

class Package {
  final int packageId;
  final String packageName;
  final String packageDescription;
  final double price;
  final String packageType;
  final int duration;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Translation> translations;
  final List<Feature> features;

  Package({
    required this.packageId,
    required this.packageName,
    required this.packageDescription,
    required this.price,
    required this.packageType,
    required this.duration,
    required this.createdAt,
    required this.updatedAt,
    required this.translations,
    required this.features,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      packageId: Subscription._parseInt(json['package_id']),
      packageName: Subscription._parseString(json['package_name']),
      packageDescription: Subscription._parseString(json['package_description']),
      price: Subscription._parseDouble(json['price']) ?? 0.0,
      packageType: Subscription._parseString(json['package_type']),
      duration: Subscription._parseInt(json['duration']),
      createdAt: Subscription._parseDateTime(json['created_at']),
      updatedAt: Subscription._parseDateTime(json['updated_at']),
      translations: (json['translations'] as List<dynamic>?)
              ?.map((t) => Translation.fromJson(t as Map<String, dynamic>))
              .toList() ??
          [],
      features: (json['features'] as List<dynamic>?)
              ?.map((f) => Feature.fromJson(f as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'package_id': packageId,
      'package_name': packageName,
      'package_description': packageDescription,
      'price': price,
      'package_type': packageType,
      'duration': duration,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'translations': translations.map((t) => t.toJson()).toList(),
      'features': features.map((f) => f.toJson()).toList(),
    };
  }
}

class Translation {
  final int translationId;
  final String packageId;
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
      translationId: Subscription._parseInt(json['translation_id']),
      packageId: Subscription._parseString(json['package_id'], defaultValue: '0'),
      language: Subscription._parseString(json['language'], defaultValue: 'ar'),
      translatedName: Subscription._parseString(json['translated_name']),
      translatedDescription: Subscription._parseString(json['translated_description']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'translation_id': translationId,
      'package_id': packageId,
      'language': language,
      'translated_name': translatedName,
      'translated_description': translatedDescription,
    };
  }
}

class Feature {
  final int featureId;
  final String packageId;
  final String featureKey;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<PackageFeatureTranslation> translations;

  Feature({
    required this.featureId,
    required this.packageId,
    required this.featureKey,
    required this.createdAt,
    required this.updatedAt,
    required this.translations,
  });

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      featureId: Subscription._parseInt(json['feature_id']),
      packageId: Subscription._parseString(json['package_id'], defaultValue: '0'),
      featureKey: Subscription._parseString(json['feature_key']),
      createdAt: Subscription._parseDateTime(json['created_at']),
      updatedAt: Subscription._parseDateTime(json['updated_at']),
      translations: (json['package_feature_translation'] as List<dynamic>?)
              ?.map((t) => PackageFeatureTranslation.fromJson(t as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feature_id': featureId,
      'package_id': packageId,
      'feature_key': featureKey,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'package_feature_translation': translations.map((t) => t.toJson()).toList(),
    };
  }
}

class PackageFeatureTranslation {
  final int translationId;
  final String featureId;
  final String language;
  final String translatedText;

  PackageFeatureTranslation({
    required this.translationId,
    required this.featureId,
    required this.language,
    required this.translatedText,
  });

  factory PackageFeatureTranslation.fromJson(Map<String, dynamic> json) {
    return PackageFeatureTranslation(
      translationId: Subscription._parseInt(json['translation_id']),
      featureId: Subscription._parseString(json['feature_id'], defaultValue: '0'),
      language: Subscription._parseString(json['language'], defaultValue: 'ar'),
      translatedText: Subscription._parseString(json['translated_text']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'translation_id': translationId,
      'feature_id': featureId,
      'language': language,
      'translated_text': translatedText,
    };
  }  }

  // ========== Helper Methods ==========
  