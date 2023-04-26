import 'package:mysql_client/mysql_client.dart';
import 'package:mysql1/mysql1.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/main.dart';

class MySQL {
Future<void> insert(String rireki) async {
  print("Connecting to mysql server...");

  // create connection
  final conn = await MySQLConnection.createConnection(
    host: "192.168.1.200",
    port: 3306,
    userName: "msaito",
    password: "BKbX4Pa2RXqYLq66",
    databaseName: "msaito", // optional
  );

  await conn.connect();

  print("Connected");

  // update some rows
  var res = await conn.execute(
    "INSERT INTO `CALC` (`RIREKI`) VALUES ('$rireki');",


  );

  //print(res.affectedRows);//←データ更新クエリによって変更された行の数

  // make query
  var result = await conn.execute("SELECT * FROM CALC");

  for (final row in result.rows) {

  }


  result.rowsStream.listen((row) {
    print(row.assoc());
  });

  // close all connections
  await conn.close();
}}