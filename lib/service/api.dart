import 'dart:async';
import 'dart:convert';
import 'package:atana/model/COA.dart';
import 'package:atana/model/WAREHOUSE.dart';
import 'package:atana/model/atana_item_model.dart';
import 'package:atana/model/city_model.dart';
import 'package:atana/model/district_model.dart';
import 'package:atana/model/form_model.dart';
import 'package:atana/model/log_model.dart';
import 'package:atana/model/notification_model.dart';
import 'package:atana/model/province_model.dart';
import 'package:atana/model/technician_task.dart';
import 'package:atana/model/transport_model.dart';
import 'package:atana/model/user_model.dart';
import 'package:atana/model/warehouse_check_model.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const baseDemoUrl = "https://demo.app.indofarm.id/api/";
const atanaUrl = "http://192.168.0.250:5050/api/login/signin";

class API {
  static SharedPreferences sharedPreferences;

  static Future createLog(String activity) async {
    try {
      final response = await Dio().post(baseDemoUrl + 'log/create', queryParameters: {'activity': activity});
      if (response.statusCode == 200) {
        print('Log created:  ${response.data['result']}');
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  static Future getLog() async {
    try {
      final response = await Dio().get(baseDemoUrl + 'log');
      if (response.statusCode == 200) {
        print('Log created:  ${response.data['result']}');
        final log = logResultFromJson(jsonEncode(response.data['result']));
        return log;
      }
    } on Exception catch (e) {
      print(e);
    }
  }

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
          final item = atanaItemResultFromJson(jsonEncode(response.data));
          return item;
        }
      }
    } catch (e) {
      print(e);
    }
  }

  static Future createForm(provinceId, cityId, districtId, itemId, item, type, date) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final salesId = sharedPreferences.getInt('userId');
    final token = sharedPreferences.getString('token');
    final String url = baseDemoUrl + "form/create";
    try {
      final response = await Dio().post(url,
          options: Options(
              followRedirects: false,
              validateStatus: (status) {
                return status < 500;
              },
              headers: {
                "Authorization": "Bearer $token",
              }),
          queryParameters: {
            "province_id": provinceId,
            "city_id": cityId,
            "district_id": districtId,
            "item_id": itemId,
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

  static Future assignTechnician(technician, formId, item, warehouse, departDate, returnDate) async {
    final String url = baseDemoUrl + "technician/create";
    try {
      final response = await Dio().post(url, queryParameters: {
        "form_id": formId,
        "name": technician,
        "warehouse": warehouse,
        "task": "Ambil barang $item",
        "depart": departDate,
        "return": returnDate,
      });
      if (response.statusCode == 200) {
        print(response.data);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  static Future getTechnician() async {
    final String url = baseDemoUrl + "technician/final";
    sharedPreferences = await SharedPreferences.getInstance();
    final name = sharedPreferences.getString('name');
    try {
      final response = await Dio().get(url,
          options: Options(headers: {
            'name': name,
          }));
      if (response.statusCode == 200) {
        print(response.data['result']);
        final technician = technicianResultFromJson(jsonEncode(response.data['result']));
        return technician;
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  static Future deleteTechnician(id) async {
    final String url = baseDemoUrl + "technician/delete/$id";
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      print(response.body);
    }
  }

  static Future getFormStatus(int status) async {
    final String url = baseDemoUrl + "form";
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
    final String url = baseDemoUrl + "form/update/status";
    try {
      final response = await Dio().post(url, queryParameters: {
        "id": id,
        "status": status,
      });
      if (response.statusCode == 200) {
        print(response.data);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future updateFormStatusAndRejectReason(int id, int status, String rejectReason) async {
    try {
      final response = await Dio().put(baseDemoUrl + "form/update/status/reject", queryParameters: {
        "id": id,
        "status": status,
        "reject_reason": rejectReason,
      });
      if (response.statusCode == 200) {
        print(response.data);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future updateForm(id, status, driver, vehicle, warehouse, departDate, returnDate) async {
    final String url = baseDemoUrl + "form/update";
    try {
      final response = await Dio().put(url, queryParameters: {
        "id": id,
        "warehouse": warehouse,
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
    final String url = baseDemoUrl + "fee";
    try {
      final response = await Dio().post(url, queryParameters: {
        "form_id": id,
        "fee": fee,
        "description": feeDesc,
      });
      if (response.statusCode == 200) {
        print(response.data);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  static Future getCOA(int coaId) async {
    final String url = "http://192.168.0.250:5050/api/ChartOfAccounts/GetCOA";
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
    }
  }

  static Future getWarehouse() async {
    final url = "http://192.168.0.250:5050/api/Warehouses/GetWarehouse";
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
    }
  }

  static Future warehouseCheck(itemId) async {
    final url = "http://192.168.0.250:5050/api/Items/GetItemStockWarehouseSimple";
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
              'itemId': itemId,
            }));
        if (response.statusCode == 200) {
          final warehouseCheck = warehouseCheckResultFromJson(jsonEncode(response.data['stockBalance']));
          return warehouseCheck;
        }
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  static Future getUser(String search) async {
    final String url = baseDemoUrl + "user";
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
    }
  }

  static Future getTransport() async {
    final String url = baseDemoUrl + "transport";
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

  static Future getProvince() async {
    try {
      final response = await Dio().get(baseDemoUrl + 'province');
      if (response.statusCode == 200) {
        final province = provinceResultFromJson(jsonEncode(response.data['result']));
        return province;
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  static Future getCity(int provinceId) async {
    try {
      final response = await Dio().get(baseDemoUrl + 'city?province_id=' + '$provinceId');
      if (response.statusCode == 200) {
        final city = cityResultFromJson(jsonEncode(response.data['result']));
        return city;
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  static Future getDistrict(int cityId) async {
    try {
      final response = await Dio().get(baseDemoUrl + 'district?city_id=' + '$cityId');
      if (response.statusCode == 200) {
        final district = districtResultFromJson(jsonEncode(response.data['result']));
        return district;
      }
    } on Exception catch (e) {
      print(e);
    }
  }
}
