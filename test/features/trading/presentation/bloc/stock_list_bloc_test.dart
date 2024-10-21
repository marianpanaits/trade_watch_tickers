import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:trade_watch_tickers/core/error/failures.dart';
import 'package:trade_watch_tickers/features/trading/domain/entities/stock.dart';
import 'package:trade_watch_tickers/features/trading/domain/entities/stock_price.dart';
import 'package:trade_watch_tickers/features/trading/domain/usecases/get_stock_list.dart';
import 'package:trade_watch_tickers/features/trading/domain/usecases/get_stock_price.dart';
import 'package:trade_watch_tickers/features/trading/domain/usecases/subscribe_to_stock_updates.dart';
import 'package:trade_watch_tickers/features/trading/domain/usecases/subscribe_to_symbol.dart';
import 'package:trade_watch_tickers/features/trading/domain/usecases/unsubscribe_from_symbol.dart';
import 'package:trade_watch_tickers/features/trading/presentation/bloc/stock_list_bloc.dart';

import 'stock_list_bloc_test.mocks.dart';

@GenerateMocks(<Type>[
  GetStockList,
  GetStockPrice,
  SubscribeToStockUpdates,
  SubscribeToSymbol,
  UnsubscribeFromSymbol
])
void main() {
  late StockListBloc bloc;
  late MockGetStockList mockGetStockList;
  late MockGetStockPrice mockGetStockPrice;
  late MockSubscribeToStockUpdates mockSubscribeToStockUpdates;
  late MockSubscribeToSymbol mockSubscribeToSymbol;
  late MockUnsubscribeFromSymbol mockUnsubscribeFromSymbol;

  setUp(() {
    mockGetStockList = MockGetStockList();
    mockGetStockPrice = MockGetStockPrice();
    mockSubscribeToStockUpdates = MockSubscribeToStockUpdates();
    mockSubscribeToSymbol = MockSubscribeToSymbol();
    mockUnsubscribeFromSymbol = MockUnsubscribeFromSymbol();

    bloc = StockListBloc(
      getStockList: mockGetStockList,
      getStockPrice: mockGetStockPrice,
      subscribeToStockUpdates: mockSubscribeToStockUpdates,
      subscribeToSymbol: mockSubscribeToSymbol,
      unsubscribeFromSymbol: mockUnsubscribeFromSymbol,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be StockListInitial', () {
    expect(bloc.state, equals(StockListInitial()));
  });

  group('FetchStockList', () {
    final List<Stock> tStocks = <Stock>[
      const Stock(
          symbol: 'AAPL', description: 'Apple Inc', currentPrice: 150.0, percentChange: 1.5),
      const Stock(
          symbol: 'GOOGL', description: 'Alphabet Inc', currentPrice: 2800.0, percentChange: -0.5),
    ];

    final StockPrice tStockPrice = const StockPrice(
      currentPrice: 150.0,
      percentChange: 1.5,
    );

    blocTest<StockListBloc, StockListState>(
      'emits [StockListLoading, StockListLoaded, StockListLoaded, StockListDisconnected] when FetchStockList is added and successful',
      build: () {
        when(mockGetStockList(any)).thenAnswer((_) async => Right(tStocks));
        when(mockGetStockPrice(any)).thenAnswer((_) async => Right(tStockPrice));
        when(mockSubscribeToStockUpdates()).thenAnswer((_) => Stream.fromIterable(<Stock>[
              const Stock(
                  symbol: 'AAPL',
                  description: 'Apple Inc',
                  currentPrice: 151.0,
                  percentChange: 2.0),
            ]));
        return bloc;
      },
      act: (StockListBloc bloc) => bloc.add(FetchStockList()),
      expect: () => <Object>[
        StockListLoading(),
        isA<StockListLoaded>()
            .having((StockListLoaded state) => state.hasReachedMax, 'hasReachedMax', true)
            .having((StockListLoaded state) => state.stocks.length, 'stocks length', 2)
            .having((StockListLoaded state) => state.stocks[0].currentPrice, 'AAPL price', 150.0)
            .having((StockListLoaded state) => state.stocks[1].currentPrice, 'GOOGL price', 150.0),
        isA<StockListLoaded>()
            .having((StockListLoaded state) => state.hasReachedMax, 'hasReachedMax', true)
            .having((StockListLoaded state) => state.stocks.length, 'stocks length', 2)
            .having((StockListLoaded state) => state.stocks[0].currentPrice, 'AAPL updated price',
                151.0)
            .having((StockListLoaded state) => state.stocks[1].currentPrice, 'GOOGL price', 150.0),
        isA<StockListDisconnected>(),
      ],
      verify: (_) {
        verify(mockGetStockList(any)).called(1);
        verify(mockGetStockPrice(any)).called(tStocks.length);
        verify(mockSubscribeToStockUpdates()).called(1);
      },
    );

    blocTest<StockListBloc, StockListState>(
      'emits [StockListLoading, StockListError] when FetchStockList is added and unsuccessful',
      build: () {
        when(mockGetStockList(any)).thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (StockListBloc bloc) => bloc.add(FetchStockList()),
      expect: () => [
        StockListLoading(),
        isA<StockListError>(),
      ],
    );
  });
}
