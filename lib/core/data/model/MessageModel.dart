class MessageModel {
  final int id;
  final int userId;
  final String messageAr;
  final String messageEn;
  final DateTime messageDate;

  MessageModel({
    required this.id,
    required this.userId,
    required this.messageAr,
    required this.messageEn,
    required this.messageDate,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: _parseInt(json['id']),
      userId: _parseInt(json['user_id']),
      messageAr: json['message_ar']?.toString() ?? '',
      messageEn: json['message_en']?.toString() ?? '',
      messageDate: _parseDate(json['message_date']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static DateTime _parseDate(dynamic value) {
    try {
      return DateTime.parse(value.toString());
    } catch (e) {
      return DateTime.now();
    }
  }
}
