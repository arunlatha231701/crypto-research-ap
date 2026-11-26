class GlobalMarketStatsModel {
  const GlobalMarketStatsModel({
    required this.activeCryptocurrencies,
    required this.markets,
    required this.totalMarketCap,
    required this.totalVolume,
    required this.marketCapPercentage,
    this.marketCapChangePercentage24h,
    this.updatedAt,
  });

  final int activeCryptocurrencies;
  final int markets;
  final Map<String, double> totalMarketCap;
  final Map<String, double> totalVolume;
  final Map<String, double> marketCapPercentage;
  final double? marketCapChangePercentage24h;
  final int? updatedAt;

  factory GlobalMarketStatsModel.fromJson(Map<String, dynamic> json) {
    return GlobalMarketStatsModel(
      activeCryptocurrencies: _toInt(json['active_cryptocurrencies']) ?? 0,
      markets: _toInt(json['markets']) ?? 0,
      totalMarketCap: _toDoubleMap(json['total_market_cap']),
      totalVolume: _toDoubleMap(json['total_volume']),
      marketCapPercentage: _toDoubleMap(json['market_cap_percentage']),
      marketCapChangePercentage24h: _toDouble(
        json['market_cap_change_percentage_24h_usd'],
      ),
      updatedAt: _toInt(json['updated_at']),
    );
  }

  double marketCapFor(String currency) {
    return totalMarketCap[currency.toLowerCase()] ?? 0;
  }

  double volumeFor(String currency) {
    return totalVolume[currency.toLowerCase()] ?? 0;
  }

  double? dominanceFor(String coinSymbol) {
    return marketCapPercentage[coinSymbol.toLowerCase()];
  }

  static Map<String, double> _toDoubleMap(dynamic value) {
    if (value is! Map) return {};

    return value.map<String, double>((key, item) {
      final number = item is num ? item.toDouble() : 0.0;
      return MapEntry(key.toString(), number);
    });
  }

  static double? _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return null;
  }

  static int? _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return null;
  }
}
