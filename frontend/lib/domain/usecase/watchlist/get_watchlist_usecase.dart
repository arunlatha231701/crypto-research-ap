
import 'package:frontend/domain/entity/watchlist_item_entity.dart';
import 'package:frontend/domain/repository/watchlist_repository.dart';

class GetWatchlistUseCase {
  const GetWatchlistUseCase(this._repository);

  final WatchlistRepository _repository;

  Future<List<WatchlistItem>> call() {
    return _repository.getWatchlist();
  }
}
