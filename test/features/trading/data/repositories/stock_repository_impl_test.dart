import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:trade_watch_tickers/core/error/failures.dart';
import 'package:trade_watch_tickers/features/trading/data/datasources/stock_remote_data_source.dart';
import 'package:trade_watch_tickers/features/trading/data/datasources/stock_websocket_data_source.dart';
import 'package:trade_watch_tickers/features/trading/data/models/stock_model.dart';
import 'package:trade_watch_tickers/features/trading/data/models/stock_price_model.dart';
import 'package:trade_watch_tickers/features/trading/data/repositories/stock_repository_impl.dart';
import 'package:trade_watch_tickers/features/trading/domain/entities/stock.dart';
import 'package:trade_watch_tickers/features/trading/domain/entities/stock_price.dart';

import 'stock_repository_impl_test.mocks.dart';

@GenerateMocks(<Type>[StockRemoteDataSource, StockWebsocketDataSource])
void main() {
  late StockRepositoryImpl repository;
  late MockStockRemoteDataSource mockRemoteDataSource;
  late MockStockWebsocketDataSource mockWebsocketDataSource;

  setUp(() {
    mockRemoteDataSource = MockStockRemoteDataSource();
    mockWebsocketDataSource = MockStockWebsocketDataSource();
    repository = StockRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      websocketDataSource: mockWebsocketDataSource,
    );
  });

  group('getStockList', () {
    final List<StockModel> tStockModelList = [
      StockModel(symbol: 'AAPL', description: 'Apple Inc', currentPrice: 150.0, percentChange: 1.5),
      StockModel(
          symbol: 'GOOGL', description: 'Alphabet Inc', currentPrice: 2800.0, percentChange: -0.5),
    ];
    final List<Stock> tStockList =
        tStockModelList.map((StockModel model) => model.toEntity()).toList();

    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(mockRemoteDataSource.getStockList()).thenAnswer((_) async => tStockModelList);
        // act
        final Either<Failure, List<Stock>> result = await repository.getStockList();
        // assert
        verify(mockRemoteDataSource.getStockList());
        expect(result, isA<Right<Failure, List<Stock>>>());
        final Right<Failure, List<Stock>> rightResult = result as Right<Failure, List<Stock>>;
        expect(rightResult.value, equals(tStockList));
        for (int i = 0; i < rightResult.value.length; i++) {
          expect(rightResult.value[i].symbol, equals(tStockList[i].symbol));
          expect(rightResult.value[i].description, equals(tStockList[i].description));
          expect(rightResult.value[i].currentPrice, equals(tStockList[i].currentPrice));
          expect(rightResult.value[i].percentChange, equals(tStockList[i].percentChange));
        }
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.getStockList()).thenThrow(Exception());
        // act
        final Either<Failure, List<Stock>> result = await repository.getStockList();
        // assert
        verify(mockRemoteDataSource.getStockList());
        expect(result, equals(Left<Failure, List<Stock>>(ServerFailure())));
      },
    );
  });

  group('getStockPrice', () {
    const String tSymbol = 'AAPL';
    final StockPriceModel tStockPriceModel =
        StockPriceModel(currentPrice: 150.0, percentChange: 1.5);
    final StockPrice tStockPrice = tStockPriceModel.toEntity();

    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(mockRemoteDataSource.getStockPrice(any)).thenAnswer((_) async => tStockPriceModel);
        // act
        final Either<Failure, StockPrice> result = await repository.getStockPrice(tSymbol);
        // assert
        verify(mockRemoteDataSource.getStockPrice(tSymbol));
        expect(result, equals(Right(tStockPrice)));
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.getStockPrice(any)).thenThrow(Exception());
        // act
        final Either<Failure, StockPrice> result = await repository.getStockPrice(tSymbol);
        // assert
        verify(mockRemoteDataSource.getStockPrice(tSymbol));
        expect(result, equals(Left(ServerFailure())));
      },
    );
  });

  group('subscribeToStockUpdates', () {
    final StockModel tStockModel = StockModel(
        symbol: 'AAPL', description: 'Apple Inc', currentPrice: 150.0, percentChange: 1.5);
    final Stock tStock = tStockModel.toEntity();

    test(
      'should return stream of stock updates from websocket data source',
      () async {
        // arrange
        when(mockWebsocketDataSource.updates)
            .thenAnswer((_) => Stream.fromIterable(<StockModel>[tStockModel]));
        // act
        final Stream<Stock> result = repository.subscribeToStockUpdates();
        // assert
        expect(result, emits(tStock));
      },
    );
  });

  group('subscribeToSymbol', () {
    const String tSymbol = 'AAPL';

    test(
      'should call subscribeToSymbol on websocket data source',
      () async {
        // act
        await repository.subscribeToSymbol(tSymbol);
        // assert
        verify(mockWebsocketDataSource.subscribeToSymbol(tSymbol));
      },
    );
  });

  group('unsubscribeFromSymbol', () {
    const String tSymbol = 'AAPL';

    test(
      'should call unsubscribeFromSymbol on websocket data source',
      () async {
        // act
        await repository.unsubscribeFromSymbol(tSymbol);
        // assert
        verify(mockWebsocketDataSource.unsubscribeFromSymbol(tSymbol));
      },
    );
  });
}
