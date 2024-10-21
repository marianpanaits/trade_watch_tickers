import 'package:dartz/dartz.dart';
import 'package:trade_watch_tickers/core/error/failures.dart';
import 'package:trade_watch_tickers/features/trading/data/datasources/stock_remote_data_source.dart';
import 'package:trade_watch_tickers/features/trading/data/datasources/stock_websocket_data_source.dart';
import 'package:trade_watch_tickers/features/trading/data/models/stock_model.dart';
import 'package:trade_watch_tickers/features/trading/data/models/stock_price_model.dart';
import 'package:trade_watch_tickers/features/trading/domain/entities/stock.dart';
import 'package:trade_watch_tickers/features/trading/domain/entities/stock_price.dart';
import 'package:trade_watch_tickers/features/trading/domain/repositories/stock_repository.dart';

class StockRepositoryImpl implements StockRepository {
  final StockRemoteDataSource remoteDataSource;
  final StockWebsocketDataSource websocketDataSource;

  StockRepositoryImpl({
    required this.remoteDataSource,
    required this.websocketDataSource,
  });

  @override
  Future<Either<Failure, List<Stock>>> getStockList() async {
    try {
      final List<StockModel> remoteStocks = await remoteDataSource.getStockList();
      return Right(remoteStocks.map((StockModel model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, StockPrice>> getStockPrice(String symbol) async {
    try {
      final StockPriceModel remoteStockPrice = await remoteDataSource.getStockPrice(symbol);
      return Right(remoteStockPrice.toEntity());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Stream<Stock> subscribeToStockUpdates() {
    return websocketDataSource.updates.map((StockModel model) => model.toEntity());
  }

  @override
  Future<void> subscribeToSymbol(String symbol) async {
    websocketDataSource.subscribeToSymbol(symbol);
  }

  @override
  Future<void> unsubscribeFromSymbol(String symbol) async {
    websocketDataSource.unsubscribeFromSymbol(symbol);
  }
}
