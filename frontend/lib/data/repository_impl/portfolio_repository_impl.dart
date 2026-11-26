
import 'package:frontend/data/data%20sources/portfolio_local_data_source.dart';
import 'package:frontend/data/models/portfolio_holding_model.dart';
import 'package:frontend/domain/entity/portfolio_holding_entity.dart';
import 'package:frontend/domain/repository/portfolio_repository.dart';

class PortfolioRepositoryImpl implements PortfolioRepository {
  const PortfolioRepositoryImpl(this._localDataSource);

  final PortfolioLocalDataSource _localDataSource;

  @override
  Future<List<PortfolioHolding>> getHoldings() async {
    final models = await _localDataSource.getHoldings();

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> addHolding(PortfolioHolding holding) {
    return _localDataSource.addHolding(
      PortfolioHoldingModel.fromEntity(holding),
    );
  }

  @override
  Future<void> updateHolding(PortfolioHolding holding) {
    return _localDataSource.updateHolding(
      PortfolioHoldingModel.fromEntity(holding),
    );
  }

  @override
  Future<void> deleteHolding(String id) {
    return _localDataSource.deleteHolding(id);
  }
}
