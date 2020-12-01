import 'dart:convert';

import 'package:atana/model/province_model.dart';
import 'package:atana/service/api.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ProvinceSearch extends StatefulWidget {
  @override
  _ProvinceSearchState createState() => _ProvinceSearchState();
}

class _ProvinceSearchState extends State<ProvinceSearch> {

  Province province = Province();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  var loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: loading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(province.result[index].name),
                  );
                }),
      ),
    );
  }
}
