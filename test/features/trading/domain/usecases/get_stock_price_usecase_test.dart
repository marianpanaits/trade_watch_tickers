import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:trade_watch_tickers/core/error/failures.dart';
import 'package:trade_watch_tickers/features/trading/domain/entities/stock_price.dart';
import 'package:trade_watch_tickers/features/trading/domain/repositories/stock_repository.dart';
import 'package:trade_watch_tickers/features/trading/domain/usecases/get_stock_price.dart';

import 'get_stock_price_usecase_test.mocks.dart';

@GenerateMocks([StockRepository])
void main() {
  late GetStockPrice usecase;
  late MockStockRepository mockStockRepository;

  setUp(() {
    mockStockRepository = MockStockRepository();
    usecase = GetStockPrice(mockStockRepository);
  });

  final String tSymbol = 'AAPL';
  final StockPrice tStockPrice = const StockPrice(currentPrice: 150.0, percentChange: 1.5);

  test('should get stock price from the repository', () async {
    // arrange
    when(mockStockRepository.getStockPrice(any)).thenAnswer((_) async => Right(tStockPrice));
    // act
    final Either<Failure, StockPrice> result = await usecase(tSymbol);
    // assert
    expect(result, Right(tStockPrice));
    verify(mockStockRepository.getStockPrice(tSymbol));
    verifyNoMoreInteractions(mockStockRepository);
  });

  test('should return a ServerFailure when repository fails', () async {
    // arrange
    when(mockStockRepository.getStockPrice(any)).thenAnswer((_) async => Left(ServerFailure()));
    // act
    final Either<Failure, StockPrice> result = await usecase(tSymbol);
    // assert
    expect(result, Left(ServerFailure()));
    verify(mockStockRepository.getStockPrice(tSymbol));
    verifyNoMoreInteractions(mockStockRepository);
  });
}
