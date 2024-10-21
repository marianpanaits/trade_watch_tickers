import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_watch_tickers/core/error/failures.dart';
import 'package:trade_watch_tickers/core/usecases/usecase.dart';
import 'package:trade_watch_tickers/features/trading/domain/entities/stock.dart';
import 'package:trade_watch_tickers/features/trading/domain/entities/stock_price.dart';
import 'package:trade_watch_tickers/features/trading/domain/usecases/get_stock_list.dart';
import 'package:trade_watch_tickers/features/trading/domain/usecases/get_stock_price.dart';
import 'package:trade_watch_tickers/features/trading/domain/usecases/subscribe_to_stock_updates.dart';
import 'package:trade_watch_tickers/features/trading/domain/usecases/subscribe_to_symbol.dart';
import 'package:trade_watch_tickers/features/trading/domain/usecases/unsubscribe_from_symbol.dart';

part 'stock_list_event.dart';
part 'stock_list_state.dart';

class StockListBloc extends Bloc<StockListEvent, StockListState> {
  final GetStockList getStockList;
  final GetStockPrice getStockPrice;
  final SubscribeToStockUpdates subscribeToStockUpdates;
  final SubscribeToSymbol subscribeToSymbol;
  final UnsubscribeFromSymbol unsubscribeFromSymbol;

  static const int _batchSize = 20;
  List<Stock> _allStocks = <Stock>[];
  List<Stock> _displayedStocks = <Stock>[];
  int _currentIndex = 0;
  Set<String> _subscribedSymbols = <String>{};

  StockListBloc({
    required this.getStockList,
    required this.getStockPrice,
    required this.subscribeToStockUpdates,
    required this.subscribeToSymbol,
    required this.unsubscribeFromSymbol,
  }) : super(StockListInitial()) {
    on<FetchStockList>(_onFetchStockList);
    on<LoadMoreStocks>(_onLoadMoreStocks);
    on<UpdateStockPrice>(_onUpdateStockPrice);
    on<SearchStock>(_onSearchStock);
    on<WebSocketDisconnected>(_onWebSocketDisconnected);
    on<WebSocketReconnected>(_onWebSocketReconnected);
  }

  void _onWebSocketDisconnected(WebSocketDisconnected event, Emitter<StockListState> emit) {
    emit(StockListDisconnected());
  }

  void _onWebSocketReconnected(WebSocketReconnected event, Emitter<StockListState> emit) {
    if (state is StockListLoaded) {
      emit(StockListLoaded(
        stocks: _displayedStocks,
        hasReachedMax: _currentIndex >= _allStocks.length,
      ));
    } else {
      add(FetchStockList());
    }
  }

  void notifyWebSocketReconnected() {
    add(WebSocketReconnected());
  }

  Future<void> _onSearchStock(SearchStock event, Emitter<StockListState> emit) async {
    final String query = event.query.toLowerCase();
    if (query.isEmpty) {
      emit(StockListLoaded(
        stocks: _displayedStocks,
        hasReachedMax: _currentIndex >= _allStocks.length,
      ));
    } else {
      final List<Stock> filteredStocks = _displayedStocks
          .where((Stock stock) =>
              stock.symbol.toLowerCase().contains(query) ||
              stock.description.toLowerCase().contains(query))
          .toList();
      emit(StockListLoaded(stocks: filteredStocks, hasReachedMax: true));
    }
  }

  Future<void> _loadBatch(Emitter<StockListState> emit) async {
    if (_currentIndex >= _allStocks.length) return;

    final int endIndex = min(_currentIndex + _batchSize, _allStocks.length);
    final List<Stock> batch = _allStocks.sublist(_currentIndex, endIndex);

    final List<Stock> stocksWithPrices = await Future.wait(
      batch.map((Stock stock) async {
        final Either<Failure, StockPrice> priceResult = await getStockPrice(stock.symbol);
        return priceResult.fold(
          (Failure failure) => stock,
          (StockPrice price) => stock.copyWith(
            currentPrice: price.currentPrice,
            percentChange: price.percentChange,
          ),
        );
      }),
    );

    for (Stock stock in stocksWithPrices) {
      if (!_subscribedSymbols.contains(stock.symbol)) {
        await subscribeToSymbol(stock.symbol);
        _subscribedSymbols.add(stock.symbol);
      }
    }

    _currentIndex = endIndex;
    _displayedStocks.addAll(stocksWithPrices);

    emit(StockListLoaded(
      stocks: _displayedStocks,
      hasReachedMax: _currentIndex >= _allStocks.length,
    ));
  }

  Future<void> _onLoadMoreStocks(LoadMoreStocks event, Emitter<StockListState> emit) async {
    if (state is StockListLoaded && !(state as StockListLoaded).hasReachedMax) {
      await _loadBatch(emit);
    }
  }

  Future<void> _onFetchStockList(FetchStockList event, Emitter<StockListState> emit) async {
    emit(StockListLoading());
    final Either<Failure, List<Stock>> result = await getStockList(NoParams());

    await result.fold(
      (Failure failure) async {
        emit(StockListError(message: _mapFailureToMessage(failure)));
      },
      (List<Stock> stocks) async {
        _allStocks = stocks;
        _displayedStocks = <Stock>[];
        _currentIndex = 0;
        await _loadBatch(emit);

        subscribeToStockUpdates().listen(
          (Stock update) {
            add(UpdateStockPrice(stock: update));
          },
          onError: (dynamic error) {
            add(WebSocketDisconnected());
          },
          onDone: () {
            add(WebSocketDisconnected());
          },
        );
      },
    );
  }

  void _onUpdateStockPrice(UpdateStockPrice event, Emitter<StockListState> emit) {
    if (state is StockListLoaded) {
      _displayedStocks = _displayedStocks.map((Stock stock) {
        if (stock.symbol == event.stock.symbol) {
          final double newPrice = event.stock.currentPrice ?? stock.currentPrice ?? 0.0;
          double percentChange = 0.0;
          if (stock.currentPrice != null && stock.currentPrice != 0) {
            percentChange = ((newPrice - stock.currentPrice!) / stock.currentPrice!) * 100;
          }
          return stock.copyWith(
            currentPrice: newPrice,
            percentChange: percentChange,
          );
        }
        return stock;
      }).toList();

      final int allStockIndex = _allStocks.indexWhere((Stock s) => s.symbol == event.stock.symbol);
      if (allStockIndex != -1) {
        final Stock oldStock = _allStocks[allStockIndex];
        final double newPrice = event.stock.currentPrice ?? oldStock.currentPrice ?? 0.0;
        double percentChange = 0.0;
        if (oldStock.currentPrice != null && oldStock.currentPrice != 0) {
          percentChange = ((newPrice - oldStock.currentPrice!) / oldStock.currentPrice!) * 100;
        }
        _allStocks[allStockIndex] = oldStock.copyWith(
          currentPrice: newPrice,
          percentChange: percentChange,
        );
      }

      emit(StockListLoaded(
        stocks: _displayedStocks,
        hasReachedMax: _currentIndex >= _allStocks.length,
      ));
    }
  }

  @override
  Future<void> close() async {
    for (String symbol in _subscribedSymbols) {
      await unsubscribeFromSymbol(symbol);
    }
    return super.close();
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Failure';
      default:
        return 'Unexpected Error';
    }
  }
}
