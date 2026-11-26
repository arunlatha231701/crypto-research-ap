
import 'package:frontend/domain/entity/watchlist_item_entity.dart';
import 'package:frontend/domain/repository/watchlist_repository.dart';

class AddToWatchlistUseCase {
  const AddToWatchlistUseCase(this._repository);

  final WatchlistRepository _repository;

  Future<WatchlistItem> call(String coinId) {
    return _repository.addToWatchlist(coinId);
  }
}
