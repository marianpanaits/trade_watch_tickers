import 'package:flutter/material.dart';

void main() {
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
      home: const MyHomePage(title: 'Tickers'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(widget.title, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      ),
      body: ListView.builder(
        physics: const ClampingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              ListTile(
                tileColor: Theme.of(context).colorScheme.primary,
                title: Text('Item $index',
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                trailing: Icon(
                  Icons.auto_graph,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              Divider(
                color: Theme.of(context).colorScheme.onPrimary,
                thickness: .1,
                height: .1,
              )
            ],
          );
        },
      ),
    );
  }
}
