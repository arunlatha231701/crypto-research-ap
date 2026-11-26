
import 'package:frontend/data/data sources/watchlist_remote_data_source.dart';
import 'package:frontend/domain/entity/watchlist_item_entity.dart';
import 'package:frontend/domain/repository/watchlist_repository.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  WatchlistRepositoryImpl(this._remoteDataSource);

  final WatchlistRemoteDataSource _remoteDataSource;

  @override
  Future<List<WatchlistItem>> getWatchlist() async {
    final models = await _remoteDataSource.getWatchlist();

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<WatchlistItem> addToWatchlist(String coinId) async {
    final model = await _remoteDataSource.addToWatchlist(coinId);

    return model.toEntity();
  }

  @override
  Future<void> removeFromWatchlist(int itemId) {
    return _remoteDataSource.removeFromWatchlist(itemId);
  }
}
