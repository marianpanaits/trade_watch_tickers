part of 'stock_list_bloc.dart';

abstract class StockListEvent extends Equatable {
  const StockListEvent();

  @override
  List<Object> get props => <Object>[];
}

class FetchStockList extends StockListEvent {}

class LoadMoreStocks extends StockListEvent {}

class SearchStock extends StockListEvent {
  final String query;

  const SearchStock({required this.query});
}

class UpdateStockPrice extends StockListEvent {
  final Stock stock;

  const UpdateStockPrice({required this.stock});

  @override
  List<Object> get props => <Object>[stock];
}

class WebSocketDisconnected extends StockListEvent {}

class WebSocketReconnected extends StockListEvent {}
