import 'package:atana/model/log_model.dart';
import 'package:atana/service/api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Log extends StatefulWidget {
  @override
  _LogState createState() => _LogState();
}

class _LogState extends State<Log> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    logFuture = API.getLog();
  }

  Future logFuture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log'),
      ),
      body: FutureBuilder(
        future: logFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isEmpty) {
              return Center(
                child: Text('Tidak ada log'),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                LogResult log = snapshot.data[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(log.activity),
                      subtitle: Text(
                          '${DateFormat('d/M/y').format(log.createdAt)} | ${DateFormat('hh:mm:ss').format(log.createdAt)} WIB'),
                    ),
                    Divider(thickness: 1),
                  ],
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
