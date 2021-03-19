import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

var notificationUrl = "https://onesignal.com/api/v1/notifications";
var notificationKey = "YjY1MmY2NTUtY2YwNC00OGRlLThkNTgtZmVkNGE0ODA0NmUz";

class NotificationAPI {
  static SharedPreferences sharedPreferences;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future firebaseNotification(String username, String role, String message) async {
    await firestore.collection('Users').doc(role).collection('users').doc(username).collection('notifications').add({
      'title': "Notifikasi baru",
      'content': message,
      'time': DateTime.now(),
      'read': false,
    });
  }

  static Future usernameNotification(String username, String message) async {
    try {
      final response = await http.post(Uri.https("onesignal.com", "api/v1/notifications"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "BASIC " + notificationKey,
          },
          body: jsonEncode({
            "app_id": "956ae786-10ab-4d63-a9dd-82fb34904881",
            "include_external_user_ids": [username],
            "channel_for_external_user_ids": "push",
            "data": {"foo": "bar"},
            "headings": {"en": "Notifikasi baru"},
            "contents": {"en": message}
          }));
      if (response.statusCode == 200) {
        print('notification sent');
      }
    } on DioError catch (e) {
      print(e.response.data);
    }
  }

  static Future roleNotification(String role, String message) async {
    try {
      final response = await http.post(Uri.https("onesignal.com", "api/v1/notifications"),
          headers: {
            "Authorization": "BASIC " + notificationKey,
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "app_id": "956ae786-10ab-4d63-a9dd-82fb34904881",
            "channel_for_external_user_ids": "push",
            "filters": [
              {
                "field": "tag",
                "key": "userRole",
                "relation": "=",
                "value": role,
              }
            ],
            "data": {"foo": "bar"},
            "headings": {"en": "Notifikasi baru"},
            "contents": {"en": message}
          }));
      if (response.statusCode == 200) {
        print('role notification sent');
      }
    } on DioError catch (e) {
      print(e.response.data);
    }
  }
}
