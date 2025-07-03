class Auction {
  final int id;
  final String postId;
  final double startPrice;
  final double currentPrice;
  final DateTime startTime;
  final DateTime endTime;
  final String status;

  Auction({
    required this.id,
    required this.postId,
    required this.startPrice,
    required this.currentPrice,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  factory Auction.fromJson(Map<String, dynamic> json) {
    return Auction(
      id: json['id'],
      postId: json['post_id'],
      startPrice: double.tryParse(json['start_price'].toString()) ?? 0.0,
      currentPrice: double.tryParse(json['current_price'].toString()) ?? 0.0,
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      status: json['status'],
    );
  }
}
