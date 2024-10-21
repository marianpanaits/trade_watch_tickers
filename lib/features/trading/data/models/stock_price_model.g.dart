// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_price_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockPriceModel _$StockPriceModelFromJson(Map<String, dynamic> json) =>
    StockPriceModel(
      currentPrice: (json['c'] as num).toDouble(),
      percentChange: (json['dp'] as num).toDouble(),
    );

Map<String, dynamic> _$StockPriceModelToJson(StockPriceModel instance) =>
    <String, dynamic>{
      'c': instance.currentPrice,
      'dp': instance.percentChange,
    };
