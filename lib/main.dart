import 'package:flutter_application_1/nextpage.dart';
import 'package:flutter_application_1/sql.dart';

import 'package:mysql_client/mysql_client.dart';
import 'package:mysql1/mysql1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_dotenv/src/dotenv.dart';
import 'dart:async';
import 'package:flutter_application_1/nextpage.dart';
import 'dart:math' as Math;
import 'package:provider/provider.dart';
import 'package:buffer/io_buffer.dart';
import 'dart:io';

Future main() async {
  await dotenv.load(fileName: '.env'); //envファイル読み込み！！
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum CALC_TYPE { add, sub, multi, div } //CALC_TYPE型 type

class _MyHomePageState extends State<MyHomePage> {
//変数定義
  double _setNumber = 0;
  double _firstNum = 0; //数字を保持
  double _showNumber = 0;
  CALC_TYPE? _calcType;
  int _displayPow = 0;
  bool _decimalFlag = false;
  bool _zeroFlag = false;
  String _op = " ";
  bool _minusFlag = false;
  MySQL SQL = MySQL();

//履歴用
  String _rireki = " ";
  String _shiki = " ";
  String _ans = " ";
  List<String> rirekilist = []; //履歴表示用の配列

//数字をセットする
  void _setNum(double num) {
    _displayPow = 0;
    if (_showNumber == _setNumber) {
      //①表示の数と保持の数が一緒
      if (10000000 > _showNumber) {
        //②表示が千万未満
        setState(() {
          if (!_decimalFlag) {
            //③小数じゃない時=フラグがfalse
            _showNumber = _showNumber * 10 + num;
          } else {
            //③小数のとき
            int count = 1;
            for (int i = 0;
                _showNumber * Math.pow(10, i) !=
                    (_showNumber * Math.pow(10, i)).ceil();
                i++) {
              count++;
            }
            _showNumber = double.parse(
                (_showNumber + (num / Math.pow(10, count)))
                    .toStringAsFixed(count));
            _checkDecimal();
          }
          _setNumber = _showNumber;
        });
      }
    } else {
      //①表示≠保持　②表示の数が千億以上　計算した後にそのまま計算
      setState(() {
        _showNumber = num;
        _setNumber = _showNumber;
        _calcType = null;
      });
    }
  }

  void _clearNum() {
    //数字クリア（Cボタンの機能）
    setState(() {
      _showNumber = 0;
      _setNumber = 0;
      _firstNum = 0;
      _calcType = null;
      _displayPow = 0;
      _decimalFlag = false;
      _zeroFlag = false;
      _op = " ";
      _minusFlag = false;
      _rireki = " ";
    });
  } //保持している数字リセット

  void _calcBtnPressed(CALC_TYPE type) {
    _setNumber = _showNumber;
    _firstNum = _setNumber;
    _setNumber = 0;
    _showNumber = 0;
    _calcType = type;
    _decimalFlag = false;
  } //演算子ボタン押した時

  void _calcAdd() async{
    setState(() {
      _showNumber = _firstNum + _setNumber;
      _checkDecimal();
      _ans = _showNumber.toString();
      _rireki = _firstNum.toString() + "+" + _setNumber.toString() + "=" + _ans;
      _firstNum = _showNumber;
      rirekilist.add(_rireki);
    });
    await SQL.insert(_rireki); //データベースにデータ格納

  } //足し算

  void _calcSub() async{
    setState(() {
      _showNumber = _firstNum - _setNumber;
      _checkDecimal();
      _ans = _showNumber.toString();
      _rireki = _firstNum.toString() + "-" + _setNumber.toString() + "=" + _ans;

      _firstNum = _showNumber;
      rirekilist.add(_rireki);
    });
    await SQL.insert(_rireki);
  } //引き算

  void _calcMulti() async{
    setState(() {
      _showNumber = _firstNum * _setNumber;
      _checkDecimal();
      _ans = _showNumber.toString();
      _ans = _showNumber.toString();
      _rireki = _firstNum.toString() + "×" + _setNumber.toString() + "=" + _ans;
      _firstNum = _showNumber;
      rirekilist.add(_rireki);
    });
    await SQL.insert(_rireki);
  } //かけ算

  void _calcDiv()async {
    setState(() {
      if (_setNumber == 0) {
        _zeroFlag = true;
      } else {
        _showNumber = _firstNum / _setNumber;
        _checkDecimal();
        _ans = _showNumber.toString();
        _rireki =
            _firstNum.toString() + "÷" + _setNumber.toString() + "=" + _ans;
        _firstNum = _showNumber;
        rirekilist.add(_rireki);
      }
    });
    await SQL.insert(_rireki);
  } //割り算

  void _minus() {
    setState(() {
      if (_showNumber == _setNumber) {
        _setNumber = 0 - _setNumber;
        _showNumber = _setNumber;
      } else {
        _calcDiv();
      }
    });
  } //マイナス値の表示

  void _invertedNum() {
    setState(() {
      _showNumber = -_showNumber;
      _setNumber = -_setNumber;
    });
  } //+と-を反転

  void _checkDecimal() {
    double checkNum = _showNumber;
    if (10000000 < _showNumber || _showNumber == _showNumber.toInt() //整数である
        ) {
      int count;
      for (int i = 0; 10000000 < checkNum / Math.pow(10, i); i++) {
        count = i;
        checkNum = checkNum / 10;
      }
      setState(() {
        _showNumber = checkNum;
      });
    } else {
      int count = 0;
      for (int i = 0; i < _showNumber / Math.pow(10, i); i++) {
        count = i;
      }
      int displayCount = 10 - count;
      _showNumber = double.parse(_showNumber.toStringAsFixed(displayCount));
    }
  } //小数点の桁制御

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("電卓"),
        ),
        body: Container(
          child: Column(children: <Widget>[
            //演算子表示
            Row(
              children: <Widget>[
                Container(
                    alignment: Alignment.topLeft,
                    width: 180,
                    height: 30,
                    child: Text(
                      "" + "$_rireki",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    )), //途中式表示
                Container(
                    alignment: Alignment.topRight,
                    //alignment: Alignment.centerRight,
                    height: 30,
                    child: (_zeroFlag == true) //その時エラーが出る
                        ? Text(
                            "0で割ることはできません",
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          )
                        : Container()), //0除算エラー
                Container(
                  height: 10,
                  child: _displayPow > 0
                      ? Text(
                          "10" + "${_displayPow.toString()}",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )
                      : Container(),
                ),
              ],
            ),

            Row(
              children: <Widget>[
                Container(
                  width: 60,
                  height: 70,
                  child: Text(
                    " " + "$_op",
                    style: TextStyle(
                      fontSize: 70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: 350,
                  height: 70,
                  child: Text(
                    _showNumber == _showNumber.toInt() //ダブル型だけどイント型でも同じ？
                        ? _showNumber.toInt().toString() //〇なら整数
                        : _showNumber.toString(), //×なら小数
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 70,
                    ),
                  ),
                ),
              ],
            ),

            Expanded(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: IconButton(
                            icon: Icon(Icons.medical_information),
                            onPressed: () {

                            },
                                iconSize: 60,
                                color: Colors.blueGrey,
                          )),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                _clearNum();
                              },
                              child: Text(
                                "CE",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 60,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              child: TextButton(
                            onPressed: () {
                              _clearNum();
                            },
                            child: Text(
                              "C",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 60,
                              ),
                            ),
                          )),
                          Expanded(
                              child: TextButton(
                            onPressed: () {
                              setState(() {
                                _op = "÷";
                              });
                              _calcBtnPressed(CALC_TYPE.div);
                            },
                            child: Text(
                              "÷",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 80,
                              ),
                            ),
                          )),
                        ],
                      ),
                    ), //空の行
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: TextButton(
                            onPressed: () {
                              _setNum(7);
                            },
                            child: Text(
                              "7",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 80,
                              ),
                            ),
                          )),
                          Expanded(
                              child: TextButton(
                            onPressed: () {
                              _setNum(8);
                            },
                            child: Text(
                              "8",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 80,
                              ),
                            ),
                          )),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                _setNum(9);
                              },
                              child: Text(
                                "9",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 80,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              child: TextButton(
                            onPressed: () {
                              setState(() {
                                _op = "×";
                              });
                              _calcBtnPressed(CALC_TYPE.multi);
                            },
                            child: Text(
                              "×",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 80,
                              ),
                            ),
                          )),
                        ],
                      ),
                    ), //7の行
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: TextButton(
                            onPressed: () {
                              _setNum(4);
                            },
                            child: Text(
                              "4",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 80,
                              ),
                            ),
                          )),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                _setNum(5);
                              },
                              child: Text(
                                "5",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 80,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                _setNum(6);
                              },
                              child: Text(
                                "6",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 80,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              child: TextButton(
                            onPressed: () {
                              setState(() {
                                _op = "-";
                                _calcBtnPressed(CALC_TYPE.sub);
                              });
                            },
                            child: Text(
                              "-",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 80,
                              ),
                            ),
                          )),
                        ],
                      ),
                    ), //4の行
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextButton(
                                onPressed: () {
                                  _setNum(1);
                                },
                                child: Text(
                                  "1",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 80,
                                  ),
                                )),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                _setNum(2);
                              },
                              child: Text(
                                "2",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 80,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              child: TextButton(
                            onPressed: () {
                              _setNum(3);
                            },
                            child: Text(
                              "3",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 80,
                              ),
                            ),
                          )),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _op = "+";
                                });
                                _calcBtnPressed(CALC_TYPE.add);
                              },
                              child: Text(
                                "+",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 80,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ), //1の行
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextButton(
                              onPressed: () {

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          NextPage(rirekilist),
                                    ));
                              },
                              child: Text(
                                "履歴表示",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                _setNum(0);
                              },
                              child: Text(
                                "0",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 80,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                _decimalFlag = true;
                              },
                              child: Text(
                                ".",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 80,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                switch (_calcType) {
                                  case CALC_TYPE.add:
                                    _calcAdd();
                                    break;
                                  case CALC_TYPE.sub:
                                    _calcSub();
                                    break;
                                  case CALC_TYPE.multi:
                                    _calcMulti();
                                    break;
                                  case CALC_TYPE.div:
                                    _calcDiv();
                                    break;
                                  default:
                                    break;
                                }
                              },
                              child: Text(
                                "＝",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 80,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ), //.の行
                  ],
                ),
              ),
            )
          ]),
        ));
  }
}
