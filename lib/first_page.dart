import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'RENSHU.dart';
import 'RENSHU02.dart';

String name="ごい";

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('練習1'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SecondPage(name),
              ),
            );
          },
          child: Text('次の画面へ'),
        ),
      ),
    );
  }
}
