class MarketCoin {
  const MarketCoin({
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
}
