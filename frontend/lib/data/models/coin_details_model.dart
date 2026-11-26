
import 'package:frontend/domain/entity/coin_details_entity.dart';

class CoinDetailsModel {
  const CoinDetailsModel({
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

  factory CoinDetailsModel.fromJson(Map<String, dynamic> json) {
    final descriptionData = _asMap(json['description']);
    final imageData = _asMap(json['image']);

    return CoinDetailsModel(
      id: json['id']?.toString() ?? '',
      symbol: json['symbol']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: _readString(descriptionData['en']),
      image: _readString(
        imageData['large'] ?? imageData['small'] ?? imageData['thumb'],
      ),
      marketCapRank: _toInt(json['market_cap_rank']),
      genesisDate: _toDate(json['genesis_date']),
      marketData: _asMap(json['market_data']),
    );
  }

  CoinDetails toEntity() {
    return CoinDetails(
      id: id,
      symbol: symbol,
      name: name,
      description: description,
      image: image,
      marketCapRank: marketCapRank,
      genesisDate: genesisDate,
      marketData: marketData,
    );
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return {};
  }

  static String? _readString(dynamic value) {
    if (value == null) return null;

    final result = value.toString().trim();
    return result.isEmpty ? null : result;
  }

  static int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();

    return int.tryParse(value?.toString() ?? '');
  }

  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;

    return DateTime.tryParse(value.toString());
  }
}
