import 'package:atana/model/result.dart';
import 'package:atana/service/api.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("G.C. - WEATHER"),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
      ),
      body: new Container(
        child: new ListView(
          children: <Widget>[
            new FutureBuilder<List<ProvinceResult>>(
              future: API.getProvinceResult(),
              builder: (context, snapshot) {
                if (snapshot.hasData){
                  List<ProvinceResult> posts = snapshot.data;
                  return new Column(
                      children: posts.map((post) => new Column(
                        children: <Widget>[
                          new Text(post.name),
                        ],
                      )).toList()
                  );
                }
                else if(snapshot.hasError)
                {
                  return snapshot.error;
                }
                return new Center(
                  child: new Column(
                    children: <Widget>[
                      new Padding(padding: new EdgeInsets.all(50.0)),
                      new CircularProgressIndicator(),
                    ],
                  ),
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}
