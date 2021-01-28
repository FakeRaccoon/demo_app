import 'package:atana/model/item_model.dart';
import 'package:atana/service/Exceptions.dart';
import 'package:atana/service/api.dart';
import 'package:flutter/material.dart';

class FutureBuilderClass extends StatefulWidget {
  @override
  _FutureBuilderClassState createState() => _FutureBuilderClassState();
}

class _FutureBuilderClassState extends State<FutureBuilderClass> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<ItemResult>>(
        future: API.getItems('asdasd'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isEmpty) {
              return showError('No data');
            }
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(snapshot.data[index].atanaName),
                );
              },
            );
          }
          if (snapshot.hasError) {
            if (snapshot.error is NoInternetException) {
              NoInternetException noInternetException = snapshot.error as NoInternetException;
              return showError(noInternetException.message);
            }
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Widget showError(message) {
    return Center(
      child: Text(message),
    );
  }
}
