
class WatchlistItem {
  const WatchlistItem({
    required this.id,
    required this.coinId,
    required this.createdAt,
  });

  final int id;
  final String coinId;
  final DateTime createdAt;
}
