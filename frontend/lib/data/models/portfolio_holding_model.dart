
import 'dart:convert';
import 'package:frontend/domain/entity/portfolio_holding_entity.dart';
import 'package:frontend/domain/repository/portfolio_repository.dart';

class PortfolioHoldingModel {
  const PortfolioHoldingModel({
    required this.id,
    required this.coinId,
    required this.quantity,
    required this.purchasePrice,
    required this.purchaseDate,
  });

  final String id;
  final String coinId;
  final double quantity;
  final double purchasePrice;
  final DateTime purchaseDate;

  factory PortfolioHoldingModel.fromEntity(
      PortfolioHolding holding,
      ) {
    return PortfolioHoldingModel(
      id: holding.id,
      coinId: holding.coinId,
      quantity: holding.quantity,
      purchasePrice: holding.purchasePrice,
      purchaseDate: holding.purchaseDate,
    );
  }

  factory PortfolioHoldingModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return PortfolioHoldingModel(
      id: json['id'] as String,
      coinId: json['coin_id'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      purchasePrice: (json['purchase_price'] as num).toDouble(),
      purchaseDate: DateTime.parse(
        json['purchase_date'] as String,
      ),
    );
  }

  PortfolioHolding toEntity() {
    return PortfolioHolding(
      id: id,
      coinId: coinId,
      quantity: quantity,
      purchasePrice: purchasePrice,
      purchaseDate: purchaseDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'coin_id': coinId,
      'quantity': quantity,
      'purchase_price': purchasePrice,
      'purchase_date': purchaseDate.toIso8601String(),
    };
  }

  String encode() => jsonEncode(toJson());

  factory PortfolioHoldingModel.decode(String value) {
    return PortfolioHoldingModel.fromJson(
      jsonDecode(value) as Map<String, dynamic>,
    );
  }
}
