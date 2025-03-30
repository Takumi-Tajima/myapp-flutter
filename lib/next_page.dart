import 'package:flutter/material.dart';

class NextPage extends StatelessWidget {
  NextPage({super.key, required this.text});

  String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.red,
        child: Center(
          child: Column(
            children: [
              Text(text, style: TextStyle(fontSize: 100, color: Colors.white)),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('戻る'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
