import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/sql.dart';
import 'dart:ui';

class NextPage extends StatefulWidget {
  NextPage(this.rirekilist);

  List<String> rirekilist;

  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  MySQL SQL = MySQL();

  @override
  void initState() {
    rirekilist = List<String>.from(widget.rirekilist);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          size: 38,
        ),
        actions: <Widget>[
          IconButton(
            iconSize: 45,
            onPressed: () {
              setState(() {
                SQL.select();
              });
            },
            icon: Icon(Icons.install_mobile),
          ),
        ],
        title: Text('履歴',
            style: TextStyle(
              fontSize:30,
            )),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: rirekilist.length > 0
                  ? ListView.separated(
                      itemCount: rirekilist.length,
                      separatorBuilder: ((context, index) =>
                          Divider(height: 0, thickness: 0)),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          color: index.isEven
                              ? Colors.yellow.shade200
                              : Colors.white,
                          child: ListTile(
                            title: Text(
                              '履歴${index + 1}',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.brown),
                            ),
                            subtitle: Text(
                              '${rirekilist[index]}',
                              style:
                                  TextStyle(fontSize: 40, color: Colors.black),
                            ),
                          ),
                        );
                      },
                    )
                  : Text(
                      "履歴はありません",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30),
                    ),
            ),
            ElevatedButton(
              onPressed: () {
                SQL.delete();
                setState(() {
                  rirekilist = [];
                });
              },
              child: Text(
                '履歴削除',
                style: TextStyle(fontSize: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
