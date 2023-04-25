import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/nextpage.dart';

import 'package:mysql1/mysql1.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:mysql1/mysql1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_dotenv/src/dotenv.dart';
import 'dart:async';


List<String> rirekilist = [ ];


class MySQL {

  Future select() async {
    final conn = await MySQLConnection.createConnection(
      host: dotenv.get('HOST'),
      port: int.parse(dotenv.get('PORT')),
      userName: dotenv.get('USER'),
      password: dotenv.get('PASSWORD'),
      databaseName: dotenv.get('DB'), // optional
    );
    var results = await conn.execute('SELECT CALC FROM RIREKI');

    /* rirekilist.clear();
    for (var row in results) {
     if (row[1] >= 1){
        rirekilist.add('${row[0]}             10^${row[1]}');
      }else{
        rirekilist.add('${row[0]}');
      }
      rirekilist.toString();// resultListをmain.dartで変数に入れるためstring型に変更
    }
    await conn.close();//処理を終了させる
  }
*/
  }
}