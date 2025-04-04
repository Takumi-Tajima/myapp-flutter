import 'package:flutter/material.dart';
import 'dart:async'; // タイマー用

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Life Counter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      home: const MyHomePage(title: 'Life Counter'),
    );
  }
}

class QuestionnairePage extends StatefulWidget {

  @override
  _QuestionnairePageState createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  double _progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('アンケート'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                  minHeight: 30,
                  value: _progress,
                ),
              ),
              ElevatedButton(
                child: Text('次へ'),
                onPressed: () {
                  setState(() {
                    if (_progress == 1.0) {
                      _progress = 0;
                    } else {
                      _progress += 0.2;
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
