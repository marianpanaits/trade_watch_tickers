import 'package:trade_watch_tickers/features/trading/domain/entities/stock.dart';
import 'package:trade_watch_tickers/features/trading/domain/repositories/stock_repository.dart';

class SubscribeToStockUpdates {
  final StockRepository repository;

  SubscribeToStockUpdates(this.repository);

  Stream<Stock> call() {
    return repository.subscribeToStockUpdates();
  }
}
