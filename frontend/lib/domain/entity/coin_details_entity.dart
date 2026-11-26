
class CoinDetails {
  const CoinDetails({
    required this.id,
    required this.symbol,
    required this.name,
    this.description,
    this.image,
    this.marketCapRank,
    this.genesisDate,
    this.marketData = const {},
  });

  final String id;
  final String symbol;
  final String name;
  final String? description;
  final String? image;
  final int? marketCapRank;
  final DateTime? genesisDate;
  final Map<String, dynamic> marketData;

  double? price(String currency) {
    return _readCurrencyValue('current_price', currency);
  }

  double? marketCap(String currency) {
    return _readCurrencyValue('market_cap', currency);
  }

  double? totalVolume(String currency) {
    return _readCurrencyValue('total_volume', currency);
  }

  double? high24h(String currency) {
    return _readCurrencyValue('high_24h', currency);
  }

  double? low24h(String currency) {
    return _readCurrencyValue('low_24h', currency);
  }

  double? circulatingSupply() {
    return _readNumber('circulating_supply');
  }

  double? totalSupply() {
    return _readNumber('total_supply');
  }

  double? maxSupply() {
    return _readNumber('max_supply');
  }

  double? priceChange24h() {
    return _readNumber('price_change_percentage_24h');
  }

  double? _readCurrencyValue(String key, String currency) {
    final value = marketData[key];

    if (value is! Map) return null;

    return _toDouble(value[currency.toLowerCase()]);
  }

  double? _readNumber(String key) {
    return _toDouble(marketData[key]);
  }

  static double? _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
