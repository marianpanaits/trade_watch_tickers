part of 'stock_list_bloc.dart';

abstract class StockListState extends Equatable {
  const StockListState();

  @override
  List<Object> get props => <Object>[];
}

class StockListInitial extends StockListState {}

class StockListLoading extends StockListState {}

class StockListLoaded extends StockListState {
  final List<Stock> stocks;
  final bool hasReachedMax;

  const StockListLoaded({required this.stocks, required this.hasReachedMax});

  @override
  List<Object> get props => <Object>[stocks, hasReachedMax];
}

class StockListError extends StockListState {
  final String message;

  const StockListError({required this.message});

  @override
  List<Object> get props => <Object>[message];
}

class StockListDisconnected extends StockListState {}
