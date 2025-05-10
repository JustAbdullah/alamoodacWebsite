import 'package:intl/intl.dart';
import 'post.dart'; // استيراد النموذج الموحد

class PromotedAd {
  final int adId;
  final int userId;
  final Post post; // استخدام نفس مودل المنشورات
  final String adStatus;
  final DateTime? adStartTime;
  final DateTime? adEndTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  PromotedAd({
    required this.adId,
    required this.userId,
    required this.post,
    required this.adStatus,
    this.adStartTime,
    this.adEndTime,
    required this.createdAt,
    required this.updatedAt,
  });

  // التحويل من JSON إلى كائن PromotedAd
  factory PromotedAd.fromJson(Map<String, dynamic> json) {
    return PromotedAd(
      adId: _parseInt(json['ad_id']),
      userId: _parseInt(json['user_id']),
       post: Post.fromJson(json['post']), // التحويل الصحيح
      adStatus: json['ad_status'] as String? ?? 'pending',
      adStartTime: _parseDateTime(json['ad_start_time']),
      adEndTime: _parseDateTime(json['ad_end_time']),
      createdAt: _parseDateTime(json['created_at']) ?? DateTime.now(),
      updatedAt: _parseDateTime(json['updated_at']) ?? DateTime.now(),
    );
  }

  // التحويل إلى JSON
  Map<String, dynamic> toJson() => {
        'ad_id': adId,
        'user_id': userId,
        'post': post,
        'ad_status': adStatus,
        'ad_start_time': _formatDateTime(adStartTime),
        'ad_end_time': _formatDateTime(adEndTime),
        'created_at': _formatDateTime(createdAt),
        'updated_at': _formatDateTime(updatedAt),
      };

  // تحليل القائمة
  static List<PromotedAd> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PromotedAd.fromJson(json)).toList();
  }

  // === دوال التحويل المساعدة ===
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value as String);
    } catch (e) {
      return null;
    }
  }

  static String? _formatDateTime(DateTime? date) {
    if (date == null) return null;
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }

  // === دوال الوصول للبيانات ===
  String get localizedAdStatus {
    switch (adStatus) {
      case 'pending':
        return 'في انتظار الموافقة';
      case 'active':
        return 'نشط';
      case 'finished':
        return 'منتهي';
      default:
        return 'حالة غير معروفة';
    }
  }

  bool get isActive => adStatus == 'active' && 
      (adEndTime == null || adEndTime!.isAfter(DateTime.now()));

  String get formattedStartDate => 
      DateFormat('yyyy/MM/dd - HH:mm').format(createdAt);

  String get formattedEndDate => adEndTime != null 
      ? DateFormat('yyyy/MM/dd - HH:mm').format(adEndTime!)
      : 'لا يوجد تاريخ انتهاء';
}

