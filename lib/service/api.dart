import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:atana/Examples/add_data.dart';
import 'package:atana/model/result.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const baseUrl = "http://103.56.149.39/amt_api/api/atana_get_item";
const baseDemoUrl = "https://demo.indofarm.id/api/";
const apiKey = "IndofarmSurabaya";

const token =
    'AMTJyr7nBW47pM2AzIL9TP4aQi1u4vrkVRCXjAs9XPgEysqO6UWwMKqJMxe8nd3N3H4qEjrri3ezwVQf0NBoHBTb4tVVyFowQQUq22g3uufhS6a9lC4BkQrJsuf5KQUHyLMTqoHUTyk0W2z1aK5WKB';

const Map<String, String> auth = {
  'username': 'amt',
  'password': 'kedungdoro',
  'token': token,
};

class API {
  SharedPreferences sharedPreferences;

  static Future getItems() async {
    try {
      final response = await http.get(
        baseUrl,
        headers: {HttpHeaders.authorizationHeader: apiKey},
      );
      if (response.statusCode == 200) {
        print('Items Ok');
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((e) => ItemResult.fromJson(e)).toList();
      } else {
        throw Exception('Error');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future getItems2(String keyword) async {
    final String url = "http://192.168.0.7:4948/api/Items/ProductDropDown";
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    final response = await http.get(url, headers: {
      'search': keyword,
      'Authorization': "Bearer $token",
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    });
    if (response.statusCode == 400) {
      List json404 = [
        {"itemId": 1.0, "itemName": "400 bad request"}
      ];
      return json404.map((e) => ItemResult.fromJson(e)).toList();
    }
    if (response.statusCode == 404) {
      List json404 = [];
      return json404.map((e) => ItemResult.fromJson(e)).toList();
    }
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((e) => ItemResult.fromJson(e)).toList();
    }
    print(response.statusCode);
  }

  static Future getAccounts() async {
    final String url = "http://192.168.0.7:4948/api/ChartOfAccounts/GetCOA";
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    final response = await http.get(url, headers: {
      'COACategoryId': "1000",
      'Authorization': "Bearer $token",
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    });
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      List parsed = decode["chartOfAccount"];
      return parsed.map((e) => AccountKasResult.fromJson(e)).toList();
    }
  }

  static Future getFee() async {
    final String url = "http://192.168.0.7:4948/api/ChartOfAccounts/GetCOA";
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    final response = await http.get(url, headers: {
      'COACategoryId': "9200",
      'Authorization': "Bearer $token",
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    });
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      List parsed = decode["chartOfAccount"];
      return parsed.map((e) => AccountFeeResult.fromJson(e)).toList();
    }
  }

  static Future getWarehouse() async {
    final String url = "http://192.168.0.7:4948/api/Warehouses/GetWarehouse";
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    final response = await http.get(url, headers: {
      'Authorization': "Bearer $token",
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    });
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      List parsed = decode["warehouse"];
      return parsed.map((e) => WarehouseResult.fromJson(e)).toList();
    }
  }

  static Future getEmployee() async {
    final String url = "http://192.168.0.7:4948/api/Employees/GetEmployeeSimple";
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    final response = await http.get(url, headers: {
      'Authorization': "Bearer $token",
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    });
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      List parsed = decode["employeeAccounting"];
      return parsed.map((e) => EmployeeResult.fromJson(e)).toList();
    }
  }

  static Future<List<ProvinceResult>> getProvinceResult() async {
    final response = await http.get(baseDemoUrl + 'province', headers: auth);
    if (response.statusCode == 200) {
      // Map<String, dynamic> map = json.decode(response.body);
      // List<dynamic> data = map["result"];
      // final Map parsed = json.decode(response.body);
      var responseJson = json.decode(response.body);
      print(responseJson['message']);
      print('Total province : ' + responseJson['total_data'].toString());
      return (responseJson['result'] as List).map((e) => ProvinceResult.fromJson(e)).toList();
      // return provinceFromJson(response.body);
    }
  }

  static Future<List<CityResult>> getCityResult(String provinceId) async {
    final response = await http.get(baseDemoUrl + 'city?province_id=' + provinceId, headers: auth);
    if (response.statusCode == 200) {
      print('Ok');
      // Map<String, dynamic> map = json.decode(response.body);
      // List<dynamic> data = map["result"];
      // final Map parsed = json.decode(response.body);
      var responseJson = json.decode(response.body);
      print(responseJson['message']);
      print('Total city : ' + responseJson['total_data'].toString());
      return (responseJson['result'] as List).map((e) => CityResult.fromJson(e)).toList();
      // return provinceFromJson(response.body);
    }
  }

  static Future<List<DistrictResult>> getDistrictResult(String cityId) async {
    final response = await http.get(baseDemoUrl + 'district?city_id=' + cityId, headers: auth);
    if (response.statusCode == 200) {
      print('Ok');
      // Map<String, dynamic> map = json.decode(response.body);
      // List<dynamic> data = map["result"];
      // final Map parsed = json.decode(response.body);
      var responseJson = json.decode(response.body);
      print(responseJson['message']);
      print('Total district : ' + responseJson['total_data'].toString());
      return (responseJson['result'] as List).map((e) => DistrictResult.fromJson(e)).toList();
      // return provinceFromJson(response.body);
    }
  }
}
