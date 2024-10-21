import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_watch_tickers/core/injection/injection_container.dart' as di;
import 'package:trade_watch_tickers/features/trading/presentation/bloc/stock_list_bloc.dart';
import 'package:trade_watch_tickers/features/trading/presentation/pages/stock_list_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  di.setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trade Watch Tickers',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black38,
          primary: Colors.black54,
          secondary: Colors.black,
          onPrimary: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: BlocProvider<StockListBloc>(
        create: (_) => di.di<StockListBloc>(),
        child: StockListPage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
