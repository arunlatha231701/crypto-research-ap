
import 'package:frontend/domain/entity/coin_chart_entity.dart';

class CoinChartModel {
  const CoinChartModel({
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

  final List<CoinChartPointModel> prices;
  final List<CoinChartPointModel> marketCaps;
  final List<CoinChartPointModel> totalVolumes;

  final CoinChartSummaryModel summary;
  final CoinChartMetadataModel metadata;

  factory CoinChartModel.fromJson(Map<String, dynamic> json) {
    return CoinChartModel(
      coinId: json['coin_id']?.toString() ?? '',
      currency: json['currency']?.toString() ?? 'usd',
      period: json['period']?.toString() ?? '1w',
      prices: _parsePoints(json['prices']),
      marketCaps: _parsePoints(json['market_caps']),
      totalVolumes: _parsePoints(json['total_volumes']),
      summary: CoinChartSummaryModel.fromJson(
        _asMap(json['summary']),
      ),
      metadata: CoinChartMetadataModel.fromJson(
        _asMap(json['metadata']),
      ),
    );
  }

  CoinChart toEntity() {
    return CoinChart(
      coinId: coinId,
      currency: currency,
      period: period,
      prices: prices.map((point) => point.toEntity()).toList(
        growable: false,
      ),
      marketCaps: marketCaps.map((point) => point.toEntity()).toList(
        growable: false,
      ),
      totalVolumes: totalVolumes.map((point) => point.toEntity()).toList(
        growable: false,
      ),
      summary: summary.toEntity(),
      metadata: metadata.toEntity(),
    );
  }

  static List<CoinChartPointModel> _parsePoints(dynamic value) {
    if (value is! List) return const [];

    return value
        .whereType<Map>()
        .map(
          (item) => CoinChartPointModel.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList(growable: false);
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return {};
  }
}

class CoinChartPointModel {
  const CoinChartPointModel({
    required this.timestamp,
    required this.value,
  });

  final int timestamp;
  final double? value;

  factory CoinChartPointModel.fromJson(Map<String, dynamic> json) {
    return CoinChartPointModel(
      timestamp: _toInt(json['timestamp']) ?? 0,
      value: _toDouble(json['value']),
    );
  }

  CoinChartPoint toEntity() {
    return CoinChartPoint(
      timestamp: timestamp,
      value: value,
    );
  }

  static int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();

    return int.tryParse(value?.toString() ?? '');
  }

  static double? _toDouble(dynamic value) {
    if (value is num) return value.toDouble();

    return double.tryParse(value?.toString() ?? '');
  }
}

class CoinChartSummaryModel {
  const CoinChartSummaryModel({
    this.firstPrice,
    this.latestPrice,
    this.absoluteChange,
    this.percentageChange,
  });

  final double? firstPrice;
  final double? latestPrice;
  final double? absoluteChange;
  final double? percentageChange;

  factory CoinChartSummaryModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CoinChartSummaryModel(
      firstPrice: _toDouble(json['first_price']),
      latestPrice: _toDouble(json['latest_price']),
      absoluteChange: _toDouble(json['absolute_change']),
      percentageChange: _toDouble(json['percentage_change']),
    );
  }

  CoinChartSummary toEntity() {
    return CoinChartSummary(
      firstPrice: firstPrice,
      latestPrice: latestPrice,
      absoluteChange: absoluteChange,
      percentageChange: percentageChange,
    );
  }

  static double? _toDouble(dynamic value) {
    if (value is num) return value.toDouble();

    return double.tryParse(value?.toString() ?? '');
  }
}

class CoinChartMetadataModel {
  const CoinChartMetadataModel({
    required this.pointCount,
    this.startTimestamp,
    this.endTimestamp,
    required this.trend,
  });

  final int pointCount;
  final int? startTimestamp;
  final int? endTimestamp;
  final String trend;

  factory CoinChartMetadataModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CoinChartMetadataModel(
      pointCount: _toInt(json['point_count']) ?? 0,
      startTimestamp: _toInt(json['start_timestamp']),
      endTimestamp: _toInt(json['end_timestamp']),
      trend: json['trend']?.toString() ?? 'unavailable',
    );
  }

  CoinChartMetadata toEntity() {
    return CoinChartMetadata(
      pointCount: pointCount,
      startTimestamp: startTimestamp,
      endTimestamp: endTimestamp,
      trend: trend,
    );
  }

  static int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();

    return int.tryParse(value?.toString() ?? '');
  }
}
