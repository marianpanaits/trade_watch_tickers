// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockModel _$StockModelFromJson(Map<String, dynamic> json) => StockModel(
      symbol: json['symbol'] as String,
      description: json['description'] as String,
      currentPrice: (json['currentPrice'] as num?)?.toDouble(),
      percentChange: (json['percentChange'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$StockModelToJson(StockModel instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'description': instance.description,
      'currentPrice': instance.currentPrice,
      'percentChange': instance.percentChange,
    };
