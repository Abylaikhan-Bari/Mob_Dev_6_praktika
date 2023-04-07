import 'package:flutter/material.dart';
import 'weather.dart';
import 'rps.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Altynshy praktika',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Weather App'),
            bottom: TabBar(
              tabs: [
                Tab(text: 'Aua-raiy'),
                Tab(text: 'RPS'),
                Tab(text: 'RPS'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Weather(), // using the Weather widget from weather.dart
              MyKNB(),
              MyKNB(),
            ],
          ),
        ),
      ),
    );
  }
}
