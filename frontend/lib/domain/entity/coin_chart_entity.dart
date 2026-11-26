
class CoinChart {
  const CoinChart({
    required this.coinId,
    required this.currency,
    required this.period,
    required this.prices,
    required this.marketCaps,
    required this.totalVolumes,
    required this.summary,
    required this.metadata,
  });

  final String coinId;
  final String currency;
  final String period;

  final List<CoinChartPoint> prices;
  final List<CoinChartPoint> marketCaps;
  final List<CoinChartPoint> totalVolumes;

  final CoinChartSummary summary;
  final CoinChartMetadata metadata;
}

class CoinChartPoint {
  const CoinChartPoint({
    required this.timestamp,
    required this.value,
  });

  final int timestamp;
  final double? value;

  DateTime get dateTime =>
      DateTime.fromMillisecondsSinceEpoch(timestamp);
}

class CoinChartSummary {
  const CoinChartSummary({
    this.firstPrice,
    this.latestPrice,
    this.absoluteChange,
    this.percentageChange,
  });

  final double? firstPrice;
  final double? latestPrice;
  final double? absoluteChange;
  final double? percentageChange;
}

class CoinChartMetadata {
  const CoinChartMetadata({
    required this.pointCount,
    this.startTimestamp,
    this.endTimestamp,
    required this.trend,
  });

  final int pointCount;
  final int? startTimestamp;
  final int? endTimestamp;
  final String trend;
}
