import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:mysql1/mysql1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_application_1/main.dart';
import 'dart:ui';
import 'package:provider/provider.dart';


List<String> rirekilist = [];

class MySQL {
  //データベースに保存する処理
  Future<void> insert(String rireki) async {
    print("Connecting to mysql server...");
    await dotenv.load(fileName: '.env');
    // create connection
    final conn = await MySQLConnection.createConnection(
      host: dotenv.get('HOST'),
      port: int.parse(dotenv.get('PORT')),
      userName: dotenv.get('USER'),
      password: dotenv.get('PASSWORD'),
      databaseName: dotenv.get('DB'), // optional
    );

    await conn.connect();

    print("Connected");

    //rirekiをデータベースに追加
    var res = await conn.execute(
      "INSERT INTO `CALC` (`RIREKI`) VALUES ('$rireki');",
    );

    var result = await conn.execute("SELECT * FROM `CALC`;");

    result.rowsStream.listen((row) {
      print(row.assoc());
    });
    await conn.close();
  }

  //データベースから削除する処理
  Future<void> delete() async {
    final conn = await MySQLConnection.createConnection(
      host: dotenv.get('HOST'),
      port: int.parse(dotenv.get('PORT')),
      userName: dotenv.get('USER'),
      password: dotenv.get('PASSWORD'),
      databaseName: dotenv.get('DB'),
    );
    await conn.connect();

    var res = await conn.execute('DELETE FROM `CALC`;');

    var result = await conn.execute("SELECT * FROM `CALC`;");

    await conn.close();
  }

  //データベースから取得してくる処理

  Future select() async {
    final conn = await MySQLConnection.createConnection(
      host: dotenv.get('HOST'),
      port: int.parse(dotenv.get('PORT')),
      userName: dotenv.get('USER'),
      password: dotenv.get('PASSWORD'),
      databaseName: dotenv.get('DB'),
    );
    await conn.connect();

    var results = await conn.execute('SELECT `RIREKI` FROM `CALC`;');

    for (final row in results.rows) {
      rirekilist.add("${row.colAt(0)}");
    }
   var result = await conn.execute("SELECT * FROM `CALC`;");


    await conn.close(); //処理を終了させる
  }
}
