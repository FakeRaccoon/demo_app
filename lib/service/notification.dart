import 'dart:convert';

import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

var notificationUrl = "https://onesignal.com/api/v1/notifications";
var notificationKey = "YjY1MmY2NTUtY2YwNC00OGRlLThkNTgtZmVkNGE0ODA0NmUz";
String customExternalUserId = ("technician");

class Notif {

  static SharedPreferences sharedPreferences;

  static Future getOneSignal() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final username = sharedPreferences.getString('username');
    final role = sharedPreferences.getString('role');
    print('Notification' + role);
  }

  static Future usernameNotification(String username, String message) async {
    sharedPreferences = await SharedPreferences.getInstance();
    // final username = sharedPreferences.getString('username');
    final response = await http.post(notificationUrl,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "BASIC " + notificationKey,
        },
        body: jsonEncode({
          "app_id": "956ae786-10ab-4d63-a9dd-82fb34904881",
          "include_external_user_ids": [username],
          "channel_for_external_user_ids": "push",
          "data": {"foo": "bar"},
          "headings": {"en": "Notifikasi baru buat kamu nih"},
          "contents": {"en": message}
        }));
    print(response.statusCode);
    print(response.body);
  }

  static Future roleNotification(String role, String message) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final username = sharedPreferences.getString('username');
    final response = await http.post(notificationUrl,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Basic " + notificationKey,
        },
        body: jsonEncode({
          "app_id": "956ae786-10ab-4d63-a9dd-82fb34904881",
          "channel_for_external_user_ids": "push",
          "tags": [
            {
              "key": role,
              "relation": "=",
              "value": "all",
            }
          ],
          "data": {"foo": "bar"},
          "headings": {"en": "Notifikasi baru"},
          "contents": {"en": message}
        }));
    print(username);
    print(role);
    if (response.statusCode == 200) {
      print(response.statusCode);
    } else {
      print(customExternalUserId);
    }
  }

  static Future multiRoleNotification(String message, String role_1, String role_2) async {
    final response = await http.post(notificationUrl,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "BASIC " + notificationKey,
        },
        body: jsonEncode({
          "app_id": "956ae786-10ab-4d63-a9dd-82fb34904881",
          "channel_for_external_user_ids": "push",
          "filters": [
            {
              "field": "tag",
              "key": role_1,
              "relation": "=",
              "value": "all"
            },
            {
              "operator": "OR"
            },
            {
              "field": "tag",
              "key": role_2,
              "relation": "=",
              "value": "all"
            }
          ],
          "data": {
            "foo": "bar"
          },
          "headings": {
            "en": "Ada notifikasi baru"
          },
          "contents": {
            "en": message
          }
        }));
    if (response.statusCode == 200) {
      print(response.statusCode);
      print(response.body);
    } else {
      print(customExternalUserId);
    }
  }
}
