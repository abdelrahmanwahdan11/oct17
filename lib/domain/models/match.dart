enum MatchState {
  newMatch,
  following,
  rejected,
}

class MatchLink {
  MatchLink({
    required this.id,
    required this.requestId,
    required this.auctionId,
    required this.score,
    required this.createdAt,
    required this.state,
  });

  final String id;
  final String requestId;
  final String auctionId;
  final double score;
  final DateTime createdAt;
  final MatchState state;
}
