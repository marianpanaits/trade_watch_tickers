import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trade_watch_tickers/features/trading/domain/entities/stock.dart';
import 'package:trade_watch_tickers/features/trading/presentation/bloc/stock_list_bloc.dart';
import 'package:trade_watch_tickers/features/trading/presentation/pages/stock_list_page.dart';

class MockStockListBloc extends MockBloc<StockListEvent, StockListState> implements StockListBloc {}

void main() {
  late MockStockListBloc mockStockListBloc;

  setUp(() {
    mockStockListBloc = MockStockListBloc();
  });

  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: BlocProvider<StockListBloc>.value(
        value: mockStockListBloc,
        child: child,
      ),
    );
  }

  testWidgets('StockListPage shows loading indicator when state is StockListLoading',
      (WidgetTester tester) async {
    whenListen(
      mockStockListBloc,
      Stream.fromIterable(<StockListLoading>[StockListLoading()]),
      initialState: StockListInitial(),
    );

    await tester.pumpWidget(makeTestableWidget(StockListPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('StockListPage shows list of stocks when state is StockListLoaded',
      (WidgetTester tester) async {
    final List<Stock> stocks = [
      const Stock(
          symbol: 'AAPL', description: 'Apple Inc', currentPrice: 150.0, percentChange: 1.5),
      const Stock(
          symbol: 'GOOGL', description: 'Alphabet Inc', currentPrice: 2800.0, percentChange: -0.5),
    ];

    whenListen(
      mockStockListBloc,
      Stream.fromIterable(<StockListLoaded>[StockListLoaded(stocks: stocks, hasReachedMax: false)]),
      initialState: StockListInitial(),
    );

    await tester.pumpWidget(makeTestableWidget(StockListPage()));
    await tester.pump();

    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('AAPL'), findsOneWidget);
    expect(find.text('GOOGL'), findsOneWidget);
  });

  testWidgets('StockListPage shows error message when state is StockListError',
      (WidgetTester tester) async {
    whenListen(
      mockStockListBloc,
      Stream.fromIterable(<StockListError>[const StockListError(message: 'Error loading stocks')]),
      initialState: StockListInitial(),
    );

    await tester.pumpWidget(makeTestableWidget(StockListPage()));
    await tester.pump();

    expect(find.text('Error loading stocks'), findsOneWidget);
  });
}
