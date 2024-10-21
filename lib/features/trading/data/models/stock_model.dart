import 'package:json_annotation/json_annotation.dart';
import 'package:trade_watch_tickers/features/trading/domain/entities/stock.dart';

part 'stock_model.g.dart';

@JsonSerializable()
class StockModel extends Stock {
  StockModel({
    required String symbol,
    required String description,
    double? currentPrice,
    double? percentChange,
  }) : super(
          symbol: symbol,
          description: description,
          currentPrice: currentPrice,
          percentChange: percentChange,
        );

  factory StockModel.fromJson(Map<String, dynamic> json) => _$StockModelFromJson(json);

  Map<String, dynamic> toJson() => _$StockModelToJson(this);

  factory StockModel.fromEntity(Stock stock) => StockModel(
        symbol: stock.symbol,
        description: stock.description,
        currentPrice: stock.currentPrice,
        percentChange: stock.percentChange,
      );

  Stock toEntity() => Stock(
        symbol: symbol,
        description: description,
        currentPrice: currentPrice,
        percentChange: percentChange,
      );
}
