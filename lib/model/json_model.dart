import 'dart:io';

import 'package:atana/service/api.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class JsonItem {
  final String itemId;
  final String itemName;

  JsonItem({this.itemName, this.itemId});

  factory JsonItem.fromJson(Map<String, dynamic> json) {
    return JsonItem(
      itemId: json['atanaId'] as String,
      itemName: json['atanaName'] as String,
    );
  }
}
