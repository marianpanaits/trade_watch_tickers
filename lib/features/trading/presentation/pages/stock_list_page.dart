import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_watch_tickers/features/trading/domain/entities/stock.dart';
import 'package:trade_watch_tickers/features/trading/presentation/bloc/stock_list_bloc.dart';
import 'package:trade_watch_tickers/features/trading/presentation/widgets/stock_list_item.dart';

class StockListPage extends StatefulWidget {
  @override
  _StockListPageState createState() => _StockListPageState();
}

class _StockListPageState extends State<StockListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      BlocProvider.of<StockListBloc>(context).add(LoadMoreStocks());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock List', style: TextStyle(color: Colors.white)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search stocks...',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (String value) {
                BlocProvider.of<StockListBloc>(context).add(SearchStock(query: value));
              },
            ),
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: BlocBuilder<StockListBloc, StockListState>(
        builder: (BuildContext context, StockListState state) {
          if (state is StockListInitial) {
            BlocProvider.of<StockListBloc>(context).add(FetchStockList());
            return const Center(child: CircularProgressIndicator());
          } else if (state is StockListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StockListLoaded) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.stocks.length + (state.hasReachedMax ? 0 : 1),
              itemBuilder: (BuildContext context, int index) {
                if (index < state.stocks.length) {
                  final Stock stock = state.stocks[index];
                  return StockListItem(stock: stock);
                } else if (!state.hasReachedMax) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  return Container();
                }
              },
            );
          } else if (state is StockListDisconnected) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('WebSocket disconnected. Please check your internet connection.'),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<StockListBloc>(context).add(FetchStockList());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is StockListError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }
}
