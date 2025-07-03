
class Stores {
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
    final City city;
  final User user;

  Stores({
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
       required this.city,
    required this.user,
  });

   factory Stores.fromJson(Map<String, dynamic> json) {
    var translationsList = json['translations'] != null
        ? (json['translations'] as List)
            .map((translation) => StoreTranslation.fromJson(translation))
            .toList()
        : <StoreTranslation>[];

    var city = json['city'] != null
        ? City.fromJson(json['city'])
        : City(id: 0, slug: '', country: '', translations: []);

    var user = json['user'] != null
        ? User.fromJson(json['user'])
        : User(
            id: 0,
            name: '',
            phone: '',
            logo: '',
            packageId: '',
            packageStatus: '',
            subscriptionStartDate: '',
            subscriptionEndDate: '',
            date: '',
            latitude: null,
            longitude: null,
            isDelete: false,
            isBlock: false,
            isVerified: false,
          );

    
    return Stores(
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
      website: json['website'] ?? '', city: city,
      user: user,
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

class City {
  final int id;
  final String slug;
  final String country;
  final List<StoreTranslation> translations;

  City({
    required this.id,
    required this.slug,
    required this.country,
    required this.translations,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    var translationsList = json['translations'] != null
        ? (json['translations'] as List)
            .map((translation) => StoreTranslation.fromJson(translation))
            .toList()
        : <StoreTranslation>[];

    return City(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) ?? 0 : 0,
      slug: json['slug'] ?? '',
      country: json['country'] ?? '',
      translations: translationsList,
    );
  }
}

class User {
  final int id;
  final String name;
  final String phone;
  final String logo;
  final String packageId;
  final String packageStatus;
  final String subscriptionStartDate;
  final String subscriptionEndDate;
  final String date;
  final double? latitude;
  final double? longitude;
  final bool isDelete;
  final bool isBlock;
  final bool isVerified;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.logo,
    required this.packageId,
    required this.packageStatus,
    required this.subscriptionStartDate,
    required this.subscriptionEndDate,
    required this.date,
    this.latitude,
    this.longitude,
    required this.isDelete,
    required this.isBlock,
    required this.isVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) ?? 0 : 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      logo: json['logo'] ?? '',
      packageId: json['package_id'] ?? '',
      packageStatus: json['package_status'] ?? '',
      subscriptionStartDate: json['subscription_start_date'] ?? '',
      subscriptionEndDate: json['subscription_end_date'] ?? '',
      date: json['date'] ?? '',
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
      isDelete: json['is_delete'] == "1" || json['is_delete'] == 1,
      isBlock: json['is_block'] == "1" || json['is_block'] == 1,
      isVerified: json['is_verified'] == "1" || json['is_verified'] == 1,
    );
  }
}







/////////////////