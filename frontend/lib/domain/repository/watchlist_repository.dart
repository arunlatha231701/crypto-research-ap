

import 'package:frontend/domain/entity/watchlist_item_entity.dart';

abstract interface class WatchlistRepository {
  Future<List<WatchlistItem>> getWatchlist();

  Future<WatchlistItem> addToWatchlist(String coinId);

  Future<void> removeFromWatchlist(int itemId);
}
