import 'dart:convert';
import 'dart:io';

import 'package:atana/Body.dart';
import 'package:atana/model/cities_model.dart';
import 'package:atana/model/item_model.dart';
import 'package:atana/model/json_model.dart';
import 'package:atana/model/post_result.dart';
import 'package:atana/model/result.dart';
import 'package:atana/service/api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import '../form_permintaan_keliling.dart';

class CariBarang extends StatefulWidget {
  @override
  _CariBarangState createState() => _CariBarangState();
}

class _CariBarangState extends State<CariBarang>
    with AutomaticKeepAliveClientMixin {
  TextEditingController searchController = TextEditingController();

  String searchResult;
  bool isLoading;

  // List<Item> item = List();
  List<PostResult> filteredItem = List();
  List<PostResult> item = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading = true;
    });
    PostResult.getPostResult().whenComplete((){
      setState(() {
        isLoading = false;
      });
    }).then((value) {
      setState(() {
        item = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back)),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200]),
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        onChanged: (string) {
                          setState(() {
                            filteredItem = item
                                .where((u) => (u.itemId.toString()
                                    .toLowerCase()
                                    .contains(string.toLowerCase())))
                                .toList();
                          });
                        },
                        controller: searchController,
                        autofocus: false,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search)),
                      ),
                    ),
                  ),
                  // ignore: null_aware_before_operator
                  searchController.text.isEmpty
                      ? Icon(Icons.mic)
                      : Text('Cancel')
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: filteredItem.length == 0
                    ? Center(child: Text('Item tidak ditemukan'))
                    : ListView.builder(
                        itemCount:
                            filteredItem.length < 5 ? filteredItem.length : 10,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                searchResult = filteredItem[index].itemId.toString();
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PermintaanKeliling(
                                    parsedItem: searchResult,
                                  ),
                                ),
                              );
                              print(searchResult);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Row(
                                children: [
                                  Flexible(
                                      child: Text(filteredItem[index].itemId.toString())),
                                ],
                              ),
                            ),
                          );
                        }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
