import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/sql.dart';
import 'package:flutter_application_1/nextpage.dart';
import 'dart:ui';


class MedicalPage extends StatefulWidget {
  MedicalPage(this.medical);

  int medical;

  @override
  _MedicalPageState createState() => _MedicalPageState();
}

class _MedicalPageState extends State<NextPage>{

  int _showmedical = 0;
  int p = 0;
  int medicals=10000;

  void over75() {
    _showmedical = (medicals * 0.9) as int;
    p = 1;
  }

  void over70() {
    _showmedical = (medicals * 0.8) as int;
    p = 2;
  }

  void under70() {
    _showmedical = (medicals * 0.7) as int;
    p = 3;
  }

  @override
  void initState() {
    int _medicals;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("医療費概算"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                child: Text("医療費総額が" + '$medicals' + "の場合"),
              ),
            ),
            Text(
              '年齢を選んでください',
            ),
            OutlinedButton(
              child: const Text('70歳以上の方'),
              onPressed: () {
                over70();
              },
            ),
            OutlinedButton(
              child: const Text('75歳以上の方'),
              onPressed: () {
                over75();
              },
            ),
            OutlinedButton(
              child: const Text('上記以外の方'),
              onPressed: () {
                under70();
              },
            ),
            Expanded(
              child: Container(
                child: Text('$p' + "割負担で" + '$_showmedical' + "円です"),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.elderly),
      ),
    );
  }
}
