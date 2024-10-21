import 'package:dartz/dartz.dart';
import 'package:trade_watch_tickers/core/error/failures.dart';
import 'package:trade_watch_tickers/core/usecases/usecase.dart';
import 'package:trade_watch_tickers/features/trading/domain/entities/stock_price.dart';
import 'package:trade_watch_tickers/features/trading/domain/repositories/stock_repository.dart';

class GetStockPrice implements UseCase<StockPrice, String> {
  final StockRepository repository;

  GetStockPrice(this.repository);

  @override
  Future<Either<Failure, StockPrice>> call(String symbol) async {
    return await repository.getStockPrice(symbol);
  }
}
