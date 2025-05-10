class User {
  final int? id;
  final String? name;
  final String? phone;
  final String? logo;
  final double? latitude;
  final double? longitude;
  final int isVerified; // غير قابل للnull كرقم

  User({
    this.id,
    this.name,
    this.phone,
    this.logo,
    this.latitude,
    this.longitude,
    required this.isVerified, // إجباري
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: _parseInt(json['id']),
      name: json['name']?.toString(),
      phone: json['phone']?.toString(),
      logo: json['logo']?.toString(),
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
      isVerified: _parseInt(json['is_verified']) ?? 0, // 0 كقيمة افتراضية
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'logo': logo,
      'latitude': latitude,
      'longitude': longitude,
      'is_verified': isVerified, // القيمة كرقم مباشرة
    };
  }
}
