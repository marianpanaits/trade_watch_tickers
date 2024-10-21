import 'package:equatable/equatable.dart';

class Stock extends Equatable {
  final String symbol;
  final String description;
  final double? currentPrice;
  final double? percentChange;

  const Stock({
    required this.symbol,
    required this.description,
    this.currentPrice,
    this.percentChange,
  });

  @override
  List<Object?> get props => <Object?>[symbol, description, currentPrice, percentChange];

  Stock copyWith({
    String? symbol,
    String? description,
    double? currentPrice,
    double? percentChange,
  }) {
    return Stock(
      symbol: symbol ?? this.symbol,
      description: description ?? this.description,
      currentPrice: currentPrice ?? this.currentPrice,
      percentChange: percentChange ?? this.percentChange,
    );
  }
}
