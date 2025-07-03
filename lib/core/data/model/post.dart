class Post {
  final int id;
  final String userId;
  final String storeID;

  final String categoryId;
  final String subcategoryId;
  final String? subcategoryLevel2Id;
  final String number;
  final String status;
  final String images;
  final String views;
  final String createdAt;
  var lon;
  var lat;
  var expires_at;
  final String rating;
  String is_show;

  final List<Translation> translations;
  final List<Detail> details;
  final TheCategory category;
  final TheSubcategory subcategory;
  final TheSubcategoryLevelTwo subcategoryLevelTwo;
  final User user;
  final TheCitys city;
  final Store store; // إضافة متجر

  Post({
    required this.is_show,
    required this.id,
    required this.userId,
    required this.storeID,
    required this.categoryId,
    required this.subcategoryId,
    this.subcategoryLevel2Id,
    required this.number,
    required this.status,
    required this.images,
    required this.views,
    required this.createdAt,
    required this.lon,
    required this.lat,
    required this.rating,
    required this.translations,
    required this.details,
    required this.category,
    required this.subcategory,
    required this.subcategoryLevelTwo,
    required this.user,
    required this.city,
    required this.store, // إضافة متجر
 required this.expires_at,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      is_show: json['is_show'] ?? '0',

      id: json['id'] ?? 0,
      userId: json['user_id'] ?? '', storeID: json['store_id'] ?? '',

      categoryId: json['category_id'] ?? '',
      subcategoryId: json['subcategory_id'] ?? '',
      subcategoryLevel2Id: json['subcategory_level2_id'] as String?,
      number: json['number'] ?? '',
      status: json['status'] ?? '',
      views: json['views'] ?? '0',
      images: json['images'] ?? '',
      createdAt: json['created_at'] ?? '',
      lon: json['longitude'] ?? '',
      lat: json['latitude'] ?? '',
      rating: json['rating'] ?? '0.0',
      translations: (json['translations'] as List?)
              ?.map((e) => Translation.fromJson(e))
              .toList() ??
          [],
      details:
          (json['details'] as List?)?.map((e) => Detail.fromJson(e)).toList() ??
              [],
      category: TheCategory.fromJson(json['category'] ?? {}),
      subcategory: TheSubcategory.fromJson(json['subcategory'] ?? {}),
      subcategoryLevelTwo:
          TheSubcategoryLevelTwo.fromJson(json['subcategory_level_two'] ?? {}),
      user: User.fromJson(json['user'] ?? {}),
      city: TheCitys.fromJson(json['city'] ?? {}),
      store: Store.fromJson(json['store'] ?? {}), // إضافة متجر
   expires_at: json['expires_at'] ,
    );
  }
}

class Translation {
  final int id;
  final String postId;
  final String language;
  final String title;

  Translation({
    required this.id,
    required this.postId,
    required this.language,
    required this.title,
  });

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      id: json['id'] ?? 0,
      postId: json['post_id'] ?? '',
      language: json['language'] ?? '',
      title: json['title'] ?? '',
    );
  }
}

class Detail {
  final int id;
  final String postId;
  final String detailName;
  final String detailValue;
  final List<DetailTranslation> translations;

  Detail({
    required this.id,
    required this.postId,
    required this.detailName,
    required this.detailValue,
    required this.translations,
  });

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      id: json['id'] ?? 0,
      postId: json['post_id'] ?? '',
      detailName: json['detail_name'] ?? '',
      detailValue: json['detail_value'] ?? '',
      translations: (json['translations'] as List?)
              ?.map((e) => DetailTranslation.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class DetailTranslation {
  final int id;
  final String postDetailId;
  final String language;
  final String translatedDetailName;
  final String translatedDetailValue;

  DetailTranslation({
    required this.id,
    required this.postDetailId,
    required this.language,
    required this.translatedDetailName,
    required this.translatedDetailValue,
  });

  factory DetailTranslation.fromJson(Map<String, dynamic> json) {
    return DetailTranslation(
      id: json['id'] ?? 0,
      postDetailId: json['post_detail_id'] ?? '',
      language: json['language'] ?? '',
      translatedDetailName: json['translated_detail_name'] ?? '',
      translatedDetailValue: json['translated_detail_value'] ?? '',
    );
  }
}

class CategoryTranslation {
  final int id;
  final String categoryId;
  final String language;
  final String name;

  CategoryTranslation({
    required this.id,
    required this.categoryId,
    required this.language,
    required this.name,
  });

  factory CategoryTranslation.fromJson(Map<String, dynamic> json) {
    return CategoryTranslation(
      id: json['id'] ?? 0,
      categoryId: json['category_id'] ?? '',
      language: json['language'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class SubcategoryTranslation {
  final int id;
  final String subcategoryId;
  final String language;
  final String name;

  SubcategoryTranslation({
    required this.id,
    required this.subcategoryId,
    required this.language,
    required this.name,
  });

  factory SubcategoryTranslation.fromJson(Map<String, dynamic> json) {
    return SubcategoryTranslation(
      id: json['id'] ?? 0,
      subcategoryId: json['subcategory_id'] ?? '',
      language: json['language'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class SubcategoryLevelTwoTranslation {
  final int id;
  final String subcategoryLevelTwoId;
  final String language;
  final String name;

  SubcategoryLevelTwoTranslation({
    required this.id,
    required this.subcategoryLevelTwoId,
    required this.language,
    required this.name,
  });

  factory SubcategoryLevelTwoTranslation.fromJson(Map<String, dynamic> json) {
    return SubcategoryLevelTwoTranslation(
      id: json['id'] ?? 0,
      subcategoryLevelTwoId: json['subcategory_level_two_id'] ?? '',
      language: json['language'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class TheCategory {
  final int id;
  final String slug;
  final String date;
  final List<CategoryTranslation> translations;

  TheCategory({
    required this.id,
    required this.slug,
    required this.date,
    required this.translations,
  });

  factory TheCategory.fromJson(Map<String, dynamic> json) {
    return TheCategory(
      id: json['id'] ?? 0,
      slug: json['slug'] ?? '',
      date: json['date'] ?? '',
      translations: (json['translations'] as List?)
              ?.map((e) => CategoryTranslation.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class TheSubcategory {
  final int id;
  final String categoryId;
  final String slug;
  final String date;
  final List<SubcategoryTranslation> translations;

  TheSubcategory({
    required this.id,
    required this.categoryId,
    required this.slug,
    required this.date,
    required this.translations,
  });

  factory TheSubcategory.fromJson(Map<String, dynamic> json) {
    return TheSubcategory(
      id: json['id'] ?? 0,
      categoryId: json['category_id'] ?? '',
      slug: json['slug'] ?? '',
      date: json['date'] ?? '',
      translations: (json['translations'] as List?)
              ?.map((e) => SubcategoryTranslation.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class TheSubcategoryLevelTwo {
  final int id;
  final String subcategoryId;
  final String slug;
  final String date;
  final List<SubcategoryLevelTwoTranslation> translations;

  TheSubcategoryLevelTwo({
    required this.id,
    required this.subcategoryId,
    required this.slug,
    required this.date,
    required this.translations,
  });

  factory TheSubcategoryLevelTwo.fromJson(Map<String, dynamic> json) {
    return TheSubcategoryLevelTwo(
      id: json['id'] ?? 0,
      subcategoryId: json['subcategory_id'] ?? '',
      slug: json['slug'] ?? '',
      date: json['date'] ?? '',
      translations: (json['translations'] as List?)
              ?.map((e) => SubcategoryLevelTwoTranslation.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class User {
  final int id;
  final String name;
  final String password;
  final String phone;
  final String logo;
  final String packageId;
  final String packageStatus;
  final String subscriptionStartDate;
  final String subscriptionEndDate;
  final String date;
  final double? latitude;
  final double? longitude;

  User({
    required this.id,
    required this.name,
    required this.password,
    required this.phone,
    required this.logo,
    required this.packageId,
    required this.packageStatus,
    required this.subscriptionStartDate,
    required this.subscriptionEndDate,
    required this.date,
    this.latitude,
    this.longitude,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      password: json['password'] ?? '',
      phone: json['phone'] ?? '',
      logo: json['logo'] ?? '',
      packageId: json['package_id'] ?? '',
      packageStatus: json['package_status'] ?? '',
      subscriptionStartDate: json['subscription_start_date'] ?? '',
      subscriptionEndDate: json['subscription_end_date'] ?? '',
      date: json['date'] ?? '',
      latitude:
          json['latitude'] != null ? double.tryParse(json['latitude']) : null,
      longitude:
          json['longitude'] != null ? double.tryParse(json['longitude']) : null,
    );
  }
}

class TheCitys {
  final int id;
  final String slug;
  final String country;
  final String createdAt;
  final String updatedAt;
  final List<CityTranslation> translations;

  TheCitys({
    required this.id,
    required this.slug,
    required this.country,
    required this.createdAt,
    required this.updatedAt,
    required this.translations,
  });

  factory TheCitys.fromJson(Map<String, dynamic> json) {
    return TheCitys(
      id: json['id'] ?? 0,
      slug: json['slug'] ?? '',
      country: json['country'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      translations: (json['translations'] as List?)
              ?.map((e) => CityTranslation.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class CityTranslation {
  final int id;
  final String cityId;
  final String language;
  final String name;

  CityTranslation({
    required this.id,
    required this.cityId,
    required this.language,
    required this.name,
  });

  factory CityTranslation.fromJson(Map<String, dynamic> json) {
    return CityTranslation(
      id: json['id'] ?? 0,
      cityId: json['city_id'] ?? '',
      language: json['language'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class Store {
  final int id;
  final String userId;
  final String image;
  final String slug;
  final String mainCategoryId;
  final String? subId;
  final String? idCity;
  final String longitude;
  final String latitude;
  final String isShow;
  final String views;
  final String phoneNumber;
  final String whatsappNumber;
  final String createdAt;
  final String updatedAt;
  final String accountType;
  final String instagramLink;
  final String facebookLink;
  final String? linkedinLink;
  final String? youtubeLink;
  final String website;
  final String? companySummary;
  final String? companySpecialization;
  final String? companyImages;
  final String? workingHours;
  final List<StoreTranslation> translations;

  Store({
    required this.id,
    required this.userId,
    required this.image,
    required this.slug,
    required this.mainCategoryId,
    this.subId,
    this.idCity,
    required this.longitude,
    required this.latitude,
    required this.isShow,
    required this.views,
    required this.phoneNumber,
    required this.whatsappNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.accountType,
    required this.instagramLink,
    required this.facebookLink,
    this.linkedinLink,
    this.youtubeLink,
    required this.website,
    this.companySummary,
    this.companySpecialization,
    this.companyImages,
    this.workingHours,
    required this.translations,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? '',
      image: json['image'] ?? '',
      slug: json['slug'] ?? '',
      mainCategoryId: json['main_category_id'] ?? '',
      subId: json['sub_id'] as String?,
      idCity: json['id_city'] as String?,
      longitude: json['longitude'] ?? '',
      latitude: json['latitude'] ?? '',
      isShow: json['is_show'] ?? '',
      views: json['views'] ?? '0',
      phoneNumber: json['phone_number'] ?? '',
      whatsappNumber: json['whatsapp_number'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      accountType: json['account_type'] ?? '',
      instagramLink: json['instagram_link'] ?? '',
      facebookLink: json['facebook_link'] ?? '',
      linkedinLink: json['linkedin_link'] as String?,
      youtubeLink: json['youtube_link'] as String?,
      website: json['website'] ?? '',
      companySummary: json['company_summary'] as String?,
      companySpecialization: json['company_specialization'] as String?,
      companyImages: json['company_images'] as String?,
      workingHours: json['working_hours'] as String?,
      translations: (json['translations'] as List?)
              ?.map((e) => StoreTranslation.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class StoreTranslation {
  final int id;
  final String storeId;
  final String language;
  final String name;
  final String description;
  final String? companySummary;
  final String? companySpecialization;
  final String? workingHours;

  StoreTranslation({
    required this.id,
    required this.storeId,
    required this.language,
    required this.name,
    required this.description,
    this.companySummary,
    this.companySpecialization,
    this.workingHours,
  });

  factory StoreTranslation.fromJson(Map<String, dynamic> json) {
    return StoreTranslation(
      id: json['id'] ?? 0,
      storeId: json['store_id'] ?? '',
      language: json['lang'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      companySummary: json['company_summary'] as String?,
      companySpecialization: json['company_specialization'] as String?,
      workingHours: json['working_hours'] as String?,
    );
  }
}
