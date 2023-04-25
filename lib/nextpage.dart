import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';


class NextPage extends StatelessWidget {
  NextPage(this.rirekilist);
  List<String> rirekilist;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              onPressed: () {
                  rirekilist = [];
              },
              icon: Icon(Icons.delete),
            ),
          ],
          title: Text('履歴'),
        ),
        body: Container(
            child: Center(
              child: rirekilist.length > 0
                  ? Scrollbar(
                  child: ListView.separated(
                      itemCount: rirekilist.length,
                      separatorBuilder: ((context, index) =>
                          Divider(height: 0, thickness: 0)),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          color: index.isEven
                              ? Colors.orange.shade200
                              : Colors.blueGrey.shade200,
                          child: ListTile(
                            title: Text(
                              '履歴${index + 1}',
                              style: TextStyle(
                                  fontSize: 30, color: Colors.black45),
                            ),
                            subtitle: Text(
                              rirekilist[index],
                              style:
                              TextStyle(fontSize: 50, color: Colors.black),
                            ),
                          ),
                        );
                      }))
                  : Text(
                "計算履歴無し",
                style: TextStyle(fontSize: 60),
              ),
            )));
  }
}