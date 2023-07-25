import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/sql.dart';
import 'package:flutter_application_1/nextpage.dart';
import 'dart:ui';

class MedicalPage extends StatelessWidget {
  int medical;

  MedicalPage(this.medical);

  double _showmedical = 0;
  int p = 0;

  void over75() {
    _showmedical = (medical * 0.1);
    p = 1;
  }

  void over70() {
    _showmedical = (medical * 0.2);
    p = 2;
  }

  void under70() {
    _showmedical = (medical * 0.3);
    p = 3;
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text(
              "医療費概算",
              style: TextStyle(fontSize: 30),
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Text(
                      "医療費総額が￥" + '$medical' + "の場合",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                Text('年齢を選んでください', style: TextStyle(fontSize: 30)),
                OutlinedButton(
                  child: const Text('75歳以上の方', style: TextStyle(fontSize: 30)),
                  onPressed: () {
                    over75();
                  },
                ),
                OutlinedButton(
                  child: const Text('70歳以上の方', style: TextStyle(fontSize: 30)),
                  onPressed: () {
                    over70();
                    print(_showmedical);
                  },
                ),
                OutlinedButton(
                  child: const Text('上記以外の方', style: TextStyle(fontSize: 30)),
                  onPressed: () {
                    setState() {
                      under70();
                    }
                  },
                ),
                Expanded(
                  child: Container(
                    child: Text("自己負担額は" + '$p' + "割負担で",
                        style: TextStyle(fontSize: 30)),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      "￥" + '$_showmedical' + "です",
                      style: TextStyle(fontSize: 60),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
