import 'dart:convert';

enum AuctionStatus {
  draft,
  live,
  paused,
  ended,
  endedSold,
  endedUnsold,
}

class Auction {
  Auction({
    required this.id,
    required this.title,
    required this.category,
    required this.desc,
    required this.media,
    required this.startPrice,
    required this.minIncrement,
    required this.reservePrice,
    required this.currentBid,
    required this.endAt,
    required this.location,
    required this.condition,
    required this.status,
    required this.ownerId,
  });

  factory Auction.fromJson(Map<String, dynamic> json) {
    return Auction(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      desc: json['desc'] as String,
      media: List<String>.from(json['media'] as List<dynamic>),
      startPrice: (json['startPrice'] as num).toDouble(),
      minIncrement: (json['minIncrement'] as num).toDouble(),
      reservePrice: (json['reservePrice'] as num).toDouble(),
      currentBid: (json['currentBid'] as num).toDouble(),
      endAt: DateTime.parse(json['endAt'] as String),
      location: json['location'] as String,
      condition: json['condition'] as String,
      status: AuctionStatus.values.firstWhere(
        (it) => it.name == (json['status'] as String? ?? 'draft'),
        orElse: () => AuctionStatus.draft,
      ),
      ownerId: json['ownerId'] as String,
    );
  }

  final String id;
  final String title;
  final String category;
  final String desc;
  final List<String> media;
  final double startPrice;
  final double minIncrement;
  final double reservePrice;
  final double currentBid;
  final DateTime endAt;
  final String location;
  final String condition;
  final AuctionStatus status;
  final String ownerId;

  Auction copyWith({
    double? currentBid,
    DateTime? endAt,
    AuctionStatus? status,
  }) {
    return Auction(
      id: id,
      title: title,
      category: category,
      desc: desc,
      media: media,
      startPrice: startPrice,
      minIncrement: minIncrement,
      reservePrice: reservePrice,
      currentBid: currentBid ?? this.currentBid,
      endAt: endAt ?? this.endAt,
      location: location,
      condition: condition,
      status: status ?? this.status,
      ownerId: ownerId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'desc': desc,
      'media': media,
      'startPrice': startPrice,
      'minIncrement': minIncrement,
      'reservePrice': reservePrice,
      'currentBid': currentBid,
      'endAt': endAt.toIso8601String(),
      'location': location,
      'condition': condition,
      'status': status.name,
      'ownerId': ownerId,
    };
  }

  String toRawJson() => jsonEncode(toJson());
}
