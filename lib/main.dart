import 'package:flutter/material.dart';
import 'package:sentry/sentry.dart';

const DSN =
    'https://5bba218453514938a67011d92351e074@o396794.ingest.sentry.io/5250654';
final SentryClient sentry = new SentryClient(dsn: DSN);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(title: 'Crash Demo Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;
  HomePage({this.title});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String message = "Push button to trigger an exception.";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(
          message,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _triggerDivisionByZero();
          setState(() {
            message = "Exception triggered and reported to Sentry!";
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  void _triggerDivisionByZero() async {
    try {
      var result = 10 ~/ 0;
      print(result);
    } catch (error, stackTrace) {
      await sentry.captureException(exception: error, stackTrace: stackTrace);
    }
  }
}



