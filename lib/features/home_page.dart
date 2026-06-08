import 'package:flutter/material.dart';

import '../environments/env_type.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.baseUrl, required this.envType});

  final String baseUrl;
  final EnvType envType;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() => setState(() => _counter++);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.envType.displayAapName)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Flavor: ${widget.envType.name}'),
            Text('API: ${widget.baseUrl}'),
            const SizedBox(height: 24),
            const Text('You have pushed the button this many times:'),
            Text('$_counter', style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
