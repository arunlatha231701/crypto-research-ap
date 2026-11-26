
import 'package:frontend/domain/entity/watchlist_item_entity.dart';

class WatchlistItemModel {
  const WatchlistItemModel({
    required this.id,
    required this.coinId,
    required this.createdAt,
  });

  final int id;
  final String coinId;
  final DateTime createdAt;

  factory WatchlistItemModel.fromJson(Map<String, dynamic> json) {
    return WatchlistItemModel(
      id: (json['id'] as num).toInt(),
      coinId: json['coin_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  WatchlistItem toEntity() {
    return WatchlistItem(
      id: id,
      coinId: coinId,
      createdAt: createdAt,
    );
  }
}
