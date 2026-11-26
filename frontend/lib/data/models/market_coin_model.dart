class MarketCoinModel {
  const MarketCoinModel({
    required this.id,
    required this.symbol,
    required this.name,
    this.image,
    this.currentPrice,
    this.marketCap,
    this.marketCapRank,
    this.totalVolume,
    this.high24h,
    this.low24h,
    this.priceChangePercentage24h,
    this.circulatingSupply,
  });

  final String id;
  final String symbol;
  final String name;
  final String? image;
  final double? currentPrice;
  final double? marketCap;
  final int? marketCapRank;
  final double? totalVolume;
  final double? high24h;
  final double? low24h;
  final double? priceChangePercentage24h;
  final double? circulatingSupply;

  factory MarketCoinModel.fromJson(Map<String, dynamic> json) {
    return MarketCoinModel(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      image: json['image'] as String?,
      currentPrice: _toDouble(json['current_price']),
      marketCap: _toDouble(json['market_cap']),
      marketCapRank: _toInt(json['market_cap_rank']),
      totalVolume: _toDouble(json['total_volume']),
      high24h: _toDouble(json['high_24h']),
      low24h: _toDouble(json['low_24h']),
      priceChangePercentage24h: _toDouble(json['price_change_percentage_24h']),
      circulatingSupply: _toDouble(json['circulating_supply']),
    );
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
