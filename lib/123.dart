import 'package:mysql_client/mysql_client.dart';
import 'package:mysql1/mysql1.dart';
import 'package:flutter/material.dart';

Future<void> main(List<String> arguments) async {
  print("Connecting to mysql server...");

  // create connection
  final conn = await MySQLConnection.createConnection();

  await conn.connect();

  print("Connected");

  // update some rows
  var res = await conn.execute(
      // "INSERT INTO `TEST` (`NAME`, `NUMBER`) VALUES ('あああ', '1234');",
      //"DELETE FROM `CALC` ",
      "INSERT INTO `CALC` (`RIREKI`) VALUES ('2つめ');");

  //print(res.affectedRows);//←データ更新クエリによって変更された行の数

  // make query
  var result = await conn.execute("SELECT * FROM CALC");

  // print some result data
  //print(result.numOfColumns);
  //print(result.numOfRows);
  //print(result.lastInsertID);
  //print(result.affectedRows);

  // print query result
  for (final row in result.rows) {
    print("${row.colAt(0)}" + "これだ///"); //1列目
    //print("${row.colAt(1)}"+"これだぜ");//2列目

    //print all rows as Map<String, String>
    //print(row.assoc());
  }

  // or you can use stream interface (which is required for iterable results)

  result.rowsStream.listen((row) {
    print(row.assoc());
  });

  // close all connections
  await conn.close();
}
