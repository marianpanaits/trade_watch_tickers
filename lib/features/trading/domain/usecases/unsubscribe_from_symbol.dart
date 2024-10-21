import 'package:trade_watch_tickers/features/trading/domain/repositories/stock_repository.dart';

class UnsubscribeFromSymbol {
  final StockRepository repository;

  UnsubscribeFromSymbol(this.repository);

  Future<void> call(String symbol) async {
    await repository.unsubscribeFromSymbol(symbol);
  }
}
