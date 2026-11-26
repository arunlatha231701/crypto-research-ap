class GlobalMarketStats {
  const GlobalMarketStats({
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

  double marketCapFor(String currency) =>
      totalMarketCap[currency.toLowerCase()] ?? 0;

  double volumeFor(String currency) => totalVolume[currency.toLowerCase()] ?? 0;

  double? dominanceFor(String coinSymbol) =>
      marketCapPercentage[coinSymbol.toLowerCase()];
}
