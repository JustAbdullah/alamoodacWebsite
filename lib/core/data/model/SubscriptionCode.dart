class SubscriptionCode {
  final int codeId;
  final String subscriptionId;
  final String code;
  final String primaryUserId;
  final DateTime createdAt;

  SubscriptionCode({
    required this.codeId,
    required this.subscriptionId,
    required this.code,
    required this.primaryUserId,
    required this.createdAt,
  });

  factory SubscriptionCode.fromJson(Map<String, dynamic> json) {
    return SubscriptionCode(
      codeId: json['code_id'],
      subscriptionId: json['subscription_id'],
      code: json['code'],
      primaryUserId: json['primary_user_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}