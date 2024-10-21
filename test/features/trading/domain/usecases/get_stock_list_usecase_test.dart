import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:trade_watch_tickers/core/error/failures.dart';
import 'package:trade_watch_tickers/core/usecases/usecase.dart';
import 'package:trade_watch_tickers/features/trading/domain/entities/stock.dart';
import 'package:trade_watch_tickers/features/trading/domain/repositories/stock_repository.dart';
import 'package:trade_watch_tickers/features/trading/domain/usecases/get_stock_list.dart';

import 'get_stock_list_usecase_test.mocks.dart';

@GenerateMocks([StockRepository])
void main() {
  late GetStockList usecase;
  late MockStockRepository mockStockRepository;

  setUp(() {
    mockStockRepository = MockStockRepository();
    usecase = GetStockList(mockStockRepository);
  });

  final List<Stock> tStockList = [
    const Stock(symbol: 'AAPL', description: 'Apple Inc.', currentPrice: 150.0, percentChange: 1.5),
    const Stock(
        symbol: 'GOOGL', description: 'Alphabet Inc.', currentPrice: 2800.0, percentChange: -0.5),
  ];

  test('should get stock list from the repository', () async {
    // arrange
    when(mockStockRepository.getStockList()).thenAnswer((_) async => Right(tStockList));
    // act
    final Either<Failure, List<Stock>> result = await usecase(NoParams());
    // assert
    expect(result, Right(tStockList));
    verify(mockStockRepository.getStockList());
    verifyNoMoreInteractions(mockStockRepository);
  });

  test('should return a ServerFailure when repository fails', () async {
    // arrange
    when(mockStockRepository.getStockList()).thenAnswer((_) async => Left(ServerFailure()));
    // act
    final Either<Failure, List<Stock>> result = await usecase(NoParams());
    // assert
    expect(result, Left(ServerFailure()));
    verify(mockStockRepository.getStockList());
    verifyNoMoreInteractions(mockStockRepository);
  });
}
