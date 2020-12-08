import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

var notificationUrl = "https://onesignal.com/api/v1/notifications";
var notificationKey = "YjY1MmY2NTUtY2YwNC00OGRlLThkNTgtZmVkNGE0ODA0NmUz";
String customExternalUserId = ("technician");

class Notif {
  static Future getOneSignal() async {
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    final username = sharedPreferences.getString('username');
    final role = sharedPreferences.getString('role');
    await OneSignal.shared.setExternalUserId(username);
    await OneSignal.shared.sendTag('role', role);
    print(username);
  }

  static Future getNotification(String username, String message) async {
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

  static Future roleNotification(String message) async {
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    final username = sharedPreferences.getString('username');
    final role = sharedPreferences.getString('role');
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
          "tags": [
            {
              "key": "role",
              "relation": "=",
              "value": role,
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

  static Future multiRoleNotification(String message, String role) async {
    final response = await http.post(notificationUrl,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "BASIC " + notificationKey,
        },
        body: jsonEncode({
          "app_id": "956ae786-10ab-4d63-a9dd-82fb34904881",
          // "include_external_user_ids": role,
          "channel_for_external_user_ids": "push",
          "tags": [
            {
              "key": "role",
              "relation": "=",
              "value": role,
            }
          ],
          "data": {"foo": "bar"},
          "headings": {"en": "Notifikasi baru"},
          "contents": {"en": message}
        }));
    print(role);
    if (response.statusCode == 200) {
      print(response.statusCode);
      print(response.body);
    } else {
      print(customExternalUserId);
    }
  }
}
