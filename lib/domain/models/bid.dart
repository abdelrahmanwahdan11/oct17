class Bid {
  Bid({
    required this.id,
    required this.auctionId,
    required this.userId,
    required this.amount,
    required this.createdAt,
    this.autoMax,
  });

  final String id;
  final String auctionId;
  final String userId;
  final double amount;
  final DateTime createdAt;
  final double? autoMax;
}
