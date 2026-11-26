
import 'package:frontend/domain/repository/watchlist_repository.dart';

class RemoveFromWatchlistUseCase {
  const RemoveFromWatchlistUseCase(this._repository);

  final WatchlistRepository _repository;

  Future<void> call(int itemId) {
    return _repository.removeFromWatchlist(itemId);
  }
}
