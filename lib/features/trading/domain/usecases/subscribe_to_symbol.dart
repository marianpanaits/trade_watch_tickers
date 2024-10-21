import 'package:trade_watch_tickers/features/trading/domain/repositories/stock_repository.dart';

class SubscribeToSymbol {
  final StockRepository repository;

  SubscribeToSymbol(this.repository);

  Future<void> call(String symbol) async {
    await repository.subscribeToSymbol(symbol);
  }
}
