import 'package:dartz/dartz.dart';
import 'package:trade_watch_tickers/core/error/failures.dart';
import 'package:trade_watch_tickers/core/usecases/usecase.dart';
import 'package:trade_watch_tickers/features/trading/domain/entities/stock.dart';
import 'package:trade_watch_tickers/features/trading/domain/repositories/stock_repository.dart';

class GetStockList implements UseCase<List<Stock>, NoParams> {
  final StockRepository repository;

  GetStockList(this.repository);

  @override
  Future<Either<Failure, List<Stock>>> call(NoParams params) async {
    return await repository.getStockList();
  }
}
