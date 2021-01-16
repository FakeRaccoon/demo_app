import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:atana/model/form_model.dart';
import 'package:atana/model/item_model.dart';
import 'package:atana/model/main_form_model.dart';
import 'package:atana/model/result.dart';
import 'package:atana/model/technician_task.dart';
import 'package:atana/model/transport_model.dart';
import 'package:atana/model/user_model_json.dart';
import 'package:atana/service/notification.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const baseUrl = "http://103.56.149.39/amt_api/api/atana_get_item";
const baseDemoUrl = "https://demo.indofarm.id/api/";
const apiKey = "IndofarmSurabaya";

const token =
    'AMT.fOtoM77evji26F3rHjhzss7hXAqHljTLMrYim4JxfdxT2PuX8gNT5YDjlqAKj9sscxkRjseb6GwwFJE0Z5znoBFVvjoAwun4xCGEDwiiIzVUnQjJGAV2gsDDgJ1QoZni0l23nRDraZz80dQGGBus1saRqK2L9WiSILdhZYY2GwhQkWgHrm1ifxfVSRP5qiF1Eyr1TA5ZmbbVPcA8qnCAkjagV740YyvkUYxzt1gSifhuEWxhAGv4viBvbxaexiv4OARSWsBw8jNlaknVFwJtyjhuF09Q08SO7z0zLfXiAzAsGYfc9EjAL5we05SHOsvL7tgcYRzq9AFZDjclfxzjFNm76dCJ2rRUz3mhEnFJk5c5dhsdNeOqjY9EsukrWRSxvcNu2GQ0YNy8bJzZua2J3lKacpj43LW22nUoPMfKliP0ke7rpJIwvHmI6thbXBxV7gLH8pA8bkdtd9jncVkyGeLbw0U41mKDYLNW0cEiD8TRBEEYKR5QFy3vISgGM0MyQa6qbXr3bLN5wDyEtnswy04ZbYqMTo9xkUkVmmDJATUkoouD3BHgrpptFY6PZapJmc3Wh1Vmo138AVW';

const Map<String, String> auth = {
  'username': 'amt',
  'password': 'kedungdoro157E',
  'token': 'amt',
};

class API {
  static SharedPreferences sharedPreferences;

  // static Future getItems() async {
  //   final response = await http.get(baseUrl, headers: {HttpHeaders.authorizationHeader: apiKey});
  //   if (response.statusCode == 200) {
  //     print('Items Ok');
  //     List jsonResponse = json.decode(response.body);
  //     return jsonResponse.map((e) => ItemResult.fromJson(e)).toList();
  //   }
  // }

  static Future getItems(search) async {
    // final String url = "http://192.168.0.7:4948/api/Items/ProductDropDown";
    final String localUrl = "http://10.0.2.2:8000/api/item";
    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    final response = await http.get(localUrl, headers: {
      'search': search,
      'Authorization': "Bearer $token",
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    });
    // if (response.statusCode == 400) {
    //   print(response.body);
    //   final itemResult = itemResultFromJson(jsonString);
    //   List json404 = [];
    //   return json404.map((e) => ItemResult.fromJson(e)).toList();
    // }
    // if (response.statusCode == 404) {
    //   List json404 = [];
    //   return json404.map((e) => ItemResult.fromJson(e)).toList();
    // }
    if (response.statusCode == 200) {
      var decode = jsonDecode(response.body);
      print(decode['result']);
      final item = itemResultFromJson(jsonEncode(decode['result']));
      return item;
    }
  }

  static Future createForm(province, city, district, item, type, date) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final salesId = sharedPreferences.getInt('userId');
    final token = sharedPreferences.getString('token');
    final String url = "http://10.0.2.2:8000/api/form/create";
    final response = await http.post(url, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json'
    }, body: {
      "province": province,
      "city": city,
      "district": district,
      "item_id": item,
      "user_id": salesId.toString(),
      "status": "1",
      "type": type,
      "estimated_date": date
    });
    print(response.statusCode);
    print(response.body);
  }

  static Future assignTechnician(technician, assignmentId) async {
    final String url = "http://10.0.2.2:8000/api/technician/create";
    final response = await http.post(url, body: {
      "form_id": '$assignmentId',
      "name": technician,
    });
    print(response.body);
  }

  static Future getTechnician() async {
    final String url = "http://10.0.2.2:8000/api/technician/final";
    sharedPreferences = await SharedPreferences.getInstance();
    final name = sharedPreferences.getString('name');
    final response = await http.get(url, headers: {
      'name': name,
    });
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      final parsed = jsonEncode(decode['result']);
      final technicianTask = technicianTaskResultFromJson(parsed);
      return technicianTask;
    }
  }

  static Future deleteTechnician(id) async {
    final String url = "http://10.0.2.2:8000/api/technician/delete/$id";
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      print(response.body);
    }
  }

  static Future updateTechnician(id, item, depart, retur) async {
    final String url = "http://10.0.2.2:8000/api/technician/update";
    final response = await http.post(url, headers: {
      "formId": "$id"
    }, body: {
      "task": "Ambil barang $item",
      "depart": "$depart",
      "return": "$retur",
    });
    print(response.body);
  }

  // static Future getForm(int status) async {
  //   final String url = "http://10.0.2.2:8000/api/form/status/$status";
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   // final token = sharedPreferences.getString('token');
  //   final response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     final decode = json.decode(response.body);
  //     List parsed = decode['data'];
  //     return parsed.map((e) => FormResult.fromJson(e)).toList();
  //   }
  //   print('error');
  // }

  static Future getFormStatus(int status) async {
    final String url = "http://10.0.2.2:8000/api/form";
    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    final response = await http.get(url, headers: {
      'Authorization': "Bearer $token",
      'status': '$status',
    });
    if (response.statusCode == 200) {
      var decode = jsonDecode(response.body);
      print(decode['result']);
      final List<FormResult> form = formResultFromJson(jsonEncode(decode['result']));
      return form;
    }
  }

  static Future getFormId(int id) async {
    final String url = "http://10.0.2.2:8000/api/form/$id";
    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    final response = await http.get(url, headers: {
      'Authorization': "Bearer $token",
    });
    if (response.statusCode == 200) {
      var decode = jsonDecode(response.body);
      print(decode['result']);
      final List<FormResult> form = formResultFromJson(jsonEncode(decode['result']));
      return form;
    }
  }

  // static Future getForm(int status) async {
  //   final String url = "http://10.0.2.2:8000/api/form/status/$status";
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   final token = sharedPreferences.getString('token');
  //   final response = await http.get(url, headers: {'Authorization': "Bearer $token"});
  //   if (response.statusCode == 200) {
  //     print(response.body);
  //     final List<FormResult> form = formResultFromJson(response.body);
  //     return form;
  //   }
  // }

  static Future updateFormStatus(status, id) async {
    final String url = "http://10.0.2.2:8000/api/form/update/status/$id";
    final response =
        await http.put(url, headers: {"Content-Type": "application/json"}, body: jsonEncode({"status": status}));
    if (response.statusCode == 200) {
      print(response.body);
    }
    print('error');
  }

  static Future updateForm(id, status, driver, vehicle, departDate, returnDate, fee, feeDesc) async {
    final String url = "http://10.0.2.2:8000/api/form/update/$id";
    final response = await http.put(url, body: {
      "status": "$status",
      "driver_id": "$driver" ?? "%00",
      "transport_id": vehicle == 0 ? null : "$vehicle",
      "fee": fee,
      "fee_desc": "$feeDesc",
      "departure_date": "$departDate",
      "return_date": "$returnDate"
    });
    if (response.statusCode == 200) {
      print(response.body);
    }
    print('error');
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
    final response = await Dio().get(url,
        options: Options(headers: {
          'Authorization': "Bearer $token",
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        }));
    if (response.statusCode == 200) {
      List parsed = response.data["warehouse"];
      return parsed.map((e) => WarehouseResult.fromJson(e)).toList();
    }
  }

  static Future getUser() async {
    final String url = "http://10.0.2.2:8000/api/user";
    // sharedPreferences = await SharedPreferences.getInstance();
    // final token = sharedPreferences.getString('token');
    final response = await http.get(url, headers: {
      // 'Authorization': "Bearer $token",
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    });
    if (response.statusCode == 200) {
      print(response.body);
      final userResult = userResultFromJson(response.body);
      return userResult;
    }
  }

  static Future getTransport() async {
    final String url = "http://10.0.2.2:8000/api/transport";
    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    final response = await http.get(url,
        headers: {'Authorization': "Bearer $token", 'Accept': 'application/json', 'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      final transport = transportResultFromJson(jsonEncode(decode['result']));
      return transport;
    }
  }

  static Future getProvinceResult() async {
    final response = await http.get(baseDemoUrl + 'province', headers: auth);
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      // print(responseJson['message']);
      // print('Total province : ' + responseJson['total_data'].toString());
      List parsed = responseJson["result"];
      return parsed.map((e) => ProvinceResult.fromJson(e)).toList();
    }
  }

  static Future getCityResult(String provinceId) async {
    final response = await http.get(baseDemoUrl + 'city?province_id=' + provinceId, headers: auth);
    if (response.statusCode == 200) {
      print('Ok');
      var responseJson = json.decode(response.body);
      // print(responseJson['message']);
      // print('Total city : ' + responseJson['total_data'].toString());
      List parsed = responseJson["result"];
      return parsed.map((e) => CityResult.fromJson(e)).toList();
    }
  }

  static Future getDistrictResult(String cityId) async {
    final response = await http.get(baseDemoUrl + 'district?city_id=' + cityId, headers: auth);
    if (response.statusCode == 200) {
      print('Ok');
      var responseJson = json.decode(response.body);
      // print(responseJson['message']);
      // print('Total district : ' + responseJson['total_data'].toString());
      List parsed = responseJson["result"];
      return parsed.map((e) => DistrictResult.fromJson(e)).toList();
    }
  }
}
