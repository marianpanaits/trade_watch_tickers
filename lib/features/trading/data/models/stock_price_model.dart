import 'package:json_annotation/json_annotation.dart';
import 'package:trade_watch_tickers/features/trading/domain/entities/stock_price.dart';

part 'stock_price_model.g.dart';

@JsonSerializable()
class StockPriceModel extends StockPrice {
  @JsonKey(name: 'c')
  final double currentPrice;

  @JsonKey(name: 'dp')
  final double percentChange;

  StockPriceModel({
    required this.currentPrice,
    required this.percentChange,
  }) : super(currentPrice: currentPrice, percentChange: percentChange);

  factory StockPriceModel.fromJson(Map<String, dynamic> json) => _$StockPriceModelFromJson(json);

  Map<String, dynamic> toJson() => _$StockPriceModelToJson(this);

  factory StockPriceModel.fromEntity(StockPrice stockPrice) => StockPriceModel(
        currentPrice: stockPrice.currentPrice,
        percentChange: stockPrice.percentChange,
      );

  StockPrice toEntity() => StockPrice(
        currentPrice: currentPrice,
        percentChange: percentChange,
      );
}
