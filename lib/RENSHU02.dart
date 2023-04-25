import 'package:flutter/material.dart';
import 'first_page.dart';
import 'RENSHU.dart';

class SecondPage extends StatelessWidget {
  SecondPage(this.name);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('練習2'),
      ),
      body: Center(
        child: Column(children: [
          Text(name),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("前のページ"),
          ),
        ]),
      ),
    );
  }
}
