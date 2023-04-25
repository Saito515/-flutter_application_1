import 'package:flutter/material.dart';
import 'first_page.dart';
import 'RENSHU.dart';


class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('練習'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('second'),
        ),
      ),
    );
  }
}
