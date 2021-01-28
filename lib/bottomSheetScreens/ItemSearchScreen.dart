import 'package:atana/component/customTFsmall.dart';
import 'package:atana/service/api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemSearch extends StatefulWidget {
  @override
  _ItemSearchState createState() => _ItemSearchState();
}

class _ItemSearchState extends State<ItemSearch> {
  SharedPreferences sharedPreferences;

  Future setItemInfo(String itemName, int itemId) async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('itemName', itemName);
    sharedPreferences.setInt('itemId', itemId);
  }

  String itemSearch = 'yanmar';

  @override
  Widget build(BuildContext context) {

  }
}
