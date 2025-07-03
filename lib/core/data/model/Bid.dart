class Bid {
  final int id;
  final int auctionId;
  final int userId;
  final double bidAmount;
  final String contactInfo;
  final String? additionalNotes;

  Bid({
    required this.id,
    required this.auctionId,
    required this.userId,
    required this.bidAmount,
    required this.contactInfo,
    this.additionalNotes,
  });

  factory Bid.fromJson(Map<String, dynamic> json) {
    return Bid(
      id: json['id'],
      auctionId: json['auction_id'],
      userId: json['user_id'],
      bidAmount: json['bid_amount'].toDouble(),
      contactInfo: json['contact_info'],
      additionalNotes: json['additional_notes'],
    );
  }
}
