import 'package:equatable/equatable.dart';

class StockPrice extends Equatable {
  final double currentPrice;
  final double percentChange;

  const StockPrice({
    required this.currentPrice,
    required this.percentChange,
  });

  @override
  List<Object?> get props => <Object?>[currentPrice, percentChange];
}
