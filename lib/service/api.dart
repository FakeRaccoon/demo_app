import 'dart:async';
import 'dart:convert';
import 'package:atana/model/COA.dart';
import 'package:atana/model/WAREHOUSE.dart';
import 'package:atana/model/atana_item_model.dart';
import 'package:atana/model/city_model.dart';
import 'package:atana/model/district_model.dart';
import 'package:atana/model/form_model.dart';
import 'package:atana/model/item_model.dart';
import 'package:atana/model/notification_model.dart';
import 'package:atana/model/province_model.dart';
import 'package:atana/model/technician_task.dart';
import 'package:atana/model/transport_model.dart';
import 'package:atana/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const baseUrl = "http://103.56.149.39/amt_api/api/atana_get_item";
const baseDemoUrl = "https://demo.indofarm.id/api/";
const apiKey = "IndofarmSurabaya";
const atanaUrl = "http://192.168.0.250:5050/api/login/signin";

const token =
    'AMT.fOtoM77evji26F3rHjhzss7hXAqHljTLMrYim4JxfdxT2PuX8gNT5YDjlqAKj9sscxkRjseb6GwwFJE0Z5znoBFVvjoAwun4xCGEDwiiIzVUnQjJGAV2gsDDgJ1QoZni0l23nRDraZz80dQGGBus1saRqK2L9WiSILdhZYY2GwhQkWgHrm1ifxfVSRP5qiF1Eyr1TA5ZmbbVPcA8qnCAkjagV740YyvkUYxzt1gSifhuEWxhAGv4viBvbxaexiv4OARSWsBw8jNlaknVFwJtyjhuF09Q08SO7z0zLfXiAzAsGYfc9EjAL5we05SHOsvL7tgcYRzq9AFZDjclfxzjFNm76dCJ2rRUz3mhEnFJk5c5dhsdNeOqjY9EsukrWRSxvcNu2GQ0YNy8bJzZua2J3lKacpj43LW22nUoPMfKliP0ke7rpJIwvHmI6thbXBxV7gLH8pA8bkdtd9jncVkyGeLbw0U41mKDYLNW0cEiD8TRBEEYKR5QFy3vISgGM0MyQa6qbXr3bLN5wDyEtnswy04ZbYqMTo9xkUkVmmDJATUkoouD3BHgrpptFY6PZapJmc3Wh1Vmo138AVW';

const Map<String, String> auth = {
  'username': 'amt',
  'password': 'kedungdoro157E',
  'token': 'amt',
};

class API {
  static SharedPreferences sharedPreferences;

  static Future getNotification() async {
    final String url = 'http://10.0.2.2:8000/api/notification';
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      print(decode);
      final notification = notificationResultFromJson(jsonEncode(decode['result']));
      return notification;
    }
  }

  static Future getItems(search) async {
    final String url = "http://192.168.0.250:5050/api/Items/ProductDropDown";
    final String localUrl = "http://10.0.2.2:8000/api/item";
    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    // final Response response = await Dio().get(localUrl,
    //     options: Options(headers: {
    //       'search': search,
    //       'Authorization': "Bearer $token",
    //       'Accept': 'application/json',
    //       'Content-Type': 'application/json'
    //     }));
    // if (response.statusCode == 200) {
    //   final item = itemResultFromJson(jsonEncode(response.data['result']));
    //   return item;
    // }
    try {
      final atanaResponse = await Dio().post(atanaUrl,
          options: Options(headers: {
            "username": "FLUTTERAPPS",
            "password": "a0d2f3a1ebdcf8681c5fd16f3d28a9cc",
          }));
      if (atanaResponse.statusCode == 200) {
        var atanaToken = atanaResponse.data['token']['tokenKey'];
        final response = await Dio().get(url,
            options: Options(headers: {
              'search': search,
              'Authorization': "Bearer $atanaToken",
            }));
        if (response.statusCode == 200) {
          print(response.data);
          final item = atanaItemResultFromJson(jsonEncode(response.data));
          return item;
        }
      }
    } catch (e) {
      print(e);
    }
  }

  static Future createForm(provinceId, cityId, districtId, item, type, date) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final salesId = sharedPreferences.getInt('userId');
    final token = sharedPreferences.getString('token');
    final String url = "http://10.0.2.2:8000/api/form/create";
    try {
      final response = await Dio().post(url,
          options: Options(headers: {
            "Authorization": "Bearer $token",
          }),
          queryParameters: {
            "province_id": provinceId,
            "city_id": cityId,
            "district_id": districtId,
            "item": item,
            "user_id": salesId,
            "status": 1,
            "type": type,
            "estimated_date": date
          });
      if (response.statusCode == 200) {
        print(response.data);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future assignTechnician(technician, assignmentId, item, departDate, returnDate) async {
    final String url = "http://10.0.2.2:8000/api/technician/create";
    try {
      final response = await Dio().post(url, queryParameters: {
        "form_id": assignmentId,
        "name": technician,
        "task": "Ambil barang $item",
        "depart": departDate,
        "return": returnDate,
      });
      if (response.statusCode == 200) {
        print(response.data);
      }
    } on Exception catch (e) {
      print(e);
      // TODO
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

  static Future getTechnician() async {
    final String url = "http://10.0.2.2:8000/api/technician/final";
    sharedPreferences = await SharedPreferences.getInstance();
    final name = sharedPreferences.getString('name');
    try {
      final response = await Dio().get(url,
          options: Options(headers: {
            'name': name,
          }));
      if (response.statusCode == 200) {
        final technician = technicianTaskResultFromJson(jsonEncode(response.data['result']));
        return technician;
      }
    } on Exception catch (e) {
      print(e);
      // TODO
    }
  }

  static Future deleteTechnician(id) async {
    final String url = "http://10.0.2.2:8000/api/technician/delete/$id";
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      print(response.body);
    }
  }

  static Future getFormStatus(int status) async {
    final String url = "http://10.0.2.2:8000/api/form";
    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    try {
      final response = await Dio().get(url,
          options: Options(headers: {
            'Authorization': 'Bearer $token',
            'status': status,
          }));
      if (response.statusCode == 200) {
        final form = formResultFromJson(jsonEncode(response.data['result']));
        return form;
      } else {
        print(response.data);
      }
    } catch (e) {
      print(e);
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
      final List<FormResult> form = formResultFromJson(jsonEncode(decode['result']));
      return form;
    }
  }

  static Future updateFormStatus(status, id) async {
    final String url = "http://10.0.2.2:8000/api/form/update/status/$id";
    try {
      final response = await Dio().put(url, queryParameters: {"status": status});
      if (response.statusCode == 200) {
        print(response.data);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future updateFormStatusAndRejectReason(status, id, rejectReason) async {
    final String url = "http://10.0.2.2:8000/api/form/update/status/reject/$id";
    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "status": status,
          "reject_reason": rejectReason,
        }),
      );
      if (response.statusCode == 200) {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future updateForm(id, status, driver, vehicle, departDate, returnDate) async {
    final String url = "http://10.0.2.2:8000/api/form/update/$id";
    try {
      final response = await Dio().put(url, queryParameters: {
        "status": status,
        "driver_id": driver,
        "transport_id": vehicle,
        "departure_date": departDate.toString(),
        "return_date": returnDate.toString()
      });
      if (response.statusCode == 200) {
        print(response.data);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future updateFormFee(id, fee, feeDesc) async {
    final String url = "http://10.0.2.2:8000/api/fee";
    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "form_id": id,
            "fee": fee,
            "description": feeDesc,
          }));
      if (response.statusCode == 200) {
        print(response.body);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  static Future getCOA(int coaId) async {
    final String url = "http://192.168.0.250:5050/api/ChartOfAccounts/GetCOA";
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    try {
      final atanaResponse = await Dio().post(atanaUrl,
          options: Options(headers: {
            "username": "FLUTTERAPPS",
            "password": "a0d2f3a1ebdcf8681c5fd16f3d28a9cc",
          }));
      if (atanaResponse.statusCode == 200) {
        final atanaToken = atanaResponse.data['token']['tokenKey'];
        final response = await Dio().get(url,
            options: Options(headers: {
              'COACategoryId': coaId,
              'Authorization': "Bearer $atanaToken",
              'Accept': 'application/json',
              'Content-Type': 'application/json'
            }));
        if (response.statusCode == 200) {
          final account = coaFromJson(jsonEncode(response.data['chartOfAccount']));
          return account;
        }
      }
    } on Exception catch (e) {
      print(e);
      // TODO
    }
  }

  static Future getWarehouse() async {
    final url = "http://192.168.0.250:5050/api/Warehouses/GetWarehouse";
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    try {
      final atanaResponse = await Dio().post(atanaUrl,
          options: Options(headers: {
            "username": "FLUTTERAPPS",
            "password": "a0d2f3a1ebdcf8681c5fd16f3d28a9cc",
          }));
      if (atanaResponse.statusCode == 200) {
        final atanaToken = atanaResponse.data['token']['tokenKey'];
        final response = await Dio().get(url,
            options: Options(headers: {
              'Authorization': "Bearer $atanaToken",
              'Accept': 'application/json',
              'Content-Type': 'application/json'
            }));
        if (response.statusCode == 200) {
          print(response.data);
          final warehouse = warehouseFromJson(jsonEncode(response.data['warehouse']));
          return warehouse;
        }
      }
    } on Exception catch (e) {
      print(e);
      // TODO
    }
  }

  static Future getUser(String search) async {
    final String url = "http://10.0.2.2:8000/api/user";
    // sharedPreferences = await SharedPreferences.getInstance();
    // final token = sharedPreferences.getString('token');
    try {
      final response = await Dio().get(url,
          options: Options(headers: {
            // 'Authorization': "Bearer $token",
            'search': search,
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }));
      if (response.statusCode == 200) {
        print(response.data);
        final user = userResultFromJson(jsonEncode(response.data['result']));
        return user;
      }
    } on Exception catch (e) {
      print(e);
      // TODO
    }
  }

  static Future updateUser(int id, String name, String username, String role) async {
    final String url = "http://10.0.2.2:8000/api/user/update";
    // sharedPreferences = await SharedPreferences.getInstance();
    // final token = sharedPreferences.getString('token');
    try {
      final response = await Dio().put(url,
          options: Options(headers: {
            // 'Authorization': "Bearer $token",
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }),
          queryParameters: {
            "id": id,
            "name": name,
            "username": username,
            "role": role,
          });
      if (response.statusCode == 200) {
        print(response.data);
      }
    } on Exception catch (e) {
      print(e);
      // TODO
    }
  }

  static Future createTransport(name, platNo) async {
    final String url = "http://10.0.2.2:8000/api/transport/create";
    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    try {
      final response = await Dio().post(url,
          options: Options(headers: {
            'Authorization': "Bearer $token",
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }),
          queryParameters: {
            "name": name,
            "plat_no": platNo,
          });
      if (response.statusCode == 200) {
        print(response.data);
      }
    } on Exception catch (e) {
      print(e);
      // TODO
    }
  }

  static Future getTransport() async {
    final String url = "http://10.0.2.2:8000/api/transport";
    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    try {
      final response = await Dio().get(url,
          options: Options(headers: {
            'Authorization': "Bearer $token",
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }));
      if (response.statusCode == 200) {
        final transport = transportResultFromJson(jsonEncode(response.data['result']));
        return transport;
      }
    } on Exception catch (e) {
      print(e);
      // TODO
    }
  }

  static Future updateTransport(int id, String name, String platNo) async {
    final String url = "http://10.0.2.2:8000/api/transport/update";
    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    try {
      final response = await Dio().put(url,
          options: Options(headers: {
            // 'Authorization': "Bearer $token",
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }),
          queryParameters: {
            "id": id,
            "name": name,
            "plat_no": platNo,
          });
      if (response.statusCode == 200) {
        print(response.data);
      }
    } on Exception catch (e) {
      // TODO
    }
  }

  static Future getProvince() async {
    try {
      final response = await Dio().get('http://10.0.2.2:8000/api/' + 'province');
      if (response.statusCode == 200) {
        final province = provinceResultFromJson(jsonEncode(response.data['result']));
        return province;
      }
    } on Exception catch (e) {
      print(e);
      // TODO
    }
  }

  static Future getCity(int provinceId) async {
    try {
      final response = await Dio().get('http://10.0.2.2:8000/api/' + 'city?province_id=' + '$provinceId');
      if (response.statusCode == 200) {
        final city = cityResultFromJson(jsonEncode(response.data['result']));
        return city;
      }
    } on Exception catch (e) {
      print(e);
      // TODO
    }
  }

  static Future getDistrict(int cityId) async {
    try {
      final response = await Dio().get('http://10.0.2.2:8000/api/' + 'district?city_id=' + '$cityId');
      if (response.statusCode == 200) {
        final district = districtResultFromJson(jsonEncode(response.data['result']));
        return district;
      }
    } on Exception catch (e) {
      print(e);
      // TODO
    }
  }
}
