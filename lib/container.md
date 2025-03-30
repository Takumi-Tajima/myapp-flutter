import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              color: Colors.grey[200],
              child: Column(
                children: <Widget>[Text('first line'), Text('second line')],
              ),
            ),
            Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[Text('***'), Text('中央寄せ')],
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.grey[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[Text('***'), Text('下寄せ')],
              ),
            ),
            Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[Text('***'), Text('疲れたぜまじで')],
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[Text('***'), Text('左寄せ')],
              ),
            ),
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[Text('***'), Text('右寄せ')],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
