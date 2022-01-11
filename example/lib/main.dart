import 'dart:io';

import 'package:flutter/material.dart';
import 'package:progress_alert/progress_alert.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: (context, child) => Stack(
        children: [child!, ProgressAlert()],
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final controller = ProgressPanel();
  void _incrementCounter() {
    ProgressItem progress = ProgressItem(
        process: func,
        processText: "Counter Incrementing",
        errorText: "Counter Incrementing Failed!",
        onCancel: () {
          print("Progress Cancelled");
        },
        onDone: () {
          print("Progress Done");
        },
        onError: (e) {
          print("Progress Failed:$e");
        });
    controller.addProcess(progress);
  }

  @override
  void initState(){
    controller.setFailDuration=const Duration(seconds: 10);
    //If you want the error not to be cleared from the screen turn false
    controller.changeRemoveFailAfterDuration=true;
    super.initState();
  }
  Future<void> func() async {
    //open comment lines if you want to see how fail looks like
    //List<int> list = [1, 2];
    await Future.delayed(const Duration(seconds: 3));
    //list.singleWhere((element) => element == 3);
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
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