
import 'package:hive/hive.dart';

import 'package:frontend/data/models/portfolio_holding_model.dart';

class PortfolioLocalDataSource {
  PortfolioLocalDataSource(this._box);

  final Box<String> _box;

  Future<List<PortfolioHoldingModel>> getHoldings() async {
    final holdings = <PortfolioHoldingModel>[];

    for (final value in _box.values) {
      holdings.add(PortfolioHoldingModel.decode(value));
    }

    holdings.sort(
          (a, b) => b.purchaseDate.compareTo(a.purchaseDate),
    );

    return holdings;
  }

  Future<void> addHolding(
      PortfolioHoldingModel holding,
      ) async {
    await _box.put(holding.id, holding.encode());
  }

  Future<void> updateHolding(
      PortfolioHoldingModel holding,
      ) async {
    if (!_box.containsKey(holding.id)) {
      throw Exception('Portfolio holding not found.');
    }

    await _box.put(holding.id, holding.encode());
  }

  Future<void> deleteHolding(String id) async {
    if (!_box.containsKey(id)) {
      throw Exception('Portfolio holding not found.');
    }

    await _box.delete(id);
  }
}
