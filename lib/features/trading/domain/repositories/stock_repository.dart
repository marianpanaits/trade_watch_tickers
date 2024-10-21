import 'package:dartz/dartz.dart';
import 'package:trade_watch_tickers/core/error/failures.dart';
import 'package:trade_watch_tickers/features/trading/domain/entities/stock.dart';
import 'package:trade_watch_tickers/features/trading/domain/entities/stock_price.dart';

abstract class StockRepository {
  Future<Either<Failure, List<Stock>>> getStockList();
  Future<Either<Failure, StockPrice>> getStockPrice(String symbol);
  Stream<Stock> subscribeToStockUpdates();
  Future<void> subscribeToSymbol(String symbol);
  Future<void> unsubscribeFromSymbol(String symbol);
}
