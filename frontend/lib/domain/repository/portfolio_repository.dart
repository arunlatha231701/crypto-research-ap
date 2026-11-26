
import 'package:frontend/domain/entity/portfolio_holding_entity.dart';

abstract interface class PortfolioRepository {
  Future<List<PortfolioHolding>> getHoldings();

  Future<void> addHolding(PortfolioHolding holding);

  Future<void> updateHolding(PortfolioHolding holding);

  Future<void> deleteHolding(String id);
}
