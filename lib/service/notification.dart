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
      final response = await Dio().post(notificationUrl,
          options: Options(headers: {
            "Accept": "application/json",
            "Authorization": "BASIC " + notificationKey,
          }),
          queryParameters: {
            "app_id": "956ae786-10ab-4d63-a9dd-82fb34904881",
            "include_external_user_ids": [username],
            "channel_for_external_user_ids": "push",
            "data": {"foo": "bar"},
            "headings": {"en": "Notifikasi baru"},
            "contents": {"en": message}
          });
      if (response.statusCode == 200) {
        print('notification sent');
        // await firestore
        //     .collection('Users')
        //     .doc('noRole')
        //     .collection('users')
        //     .doc(username)
        //     .collection('notifications')
        //     .add({
        //   'title': "Notifikasi baru",
        //   'content': message,
        //   'time': DateTime.now(),
        //   'read': false,
        // });
        firebaseNotification(username, 'noRole', message);
      }
    } on DioError catch (e) {
      await firestore.collection('Users').doc(username).collection('notifications').add({
        'title': "Notifikasi baru",
        'content': message,
        'time': DateTime.now(),
        'read': false,
      });
      print(e.response.statusMessage);
    }
  }

  static Future roleNotification(String role, String message) async {
    try {
      final response = await Dio().post(notificationUrl,
          options: Options(headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Basic " + notificationKey,
          }),
          queryParameters: {
            "app_id": "956ae786-10ab-4d63-a9dd-82fb34904881",
            "channel_for_external_user_ids": "push",
            "tags": [
              {
                "key": "userRole",
                "relation": "=",
                "value": role,
              }
            ],
            "data": {"foo": "bar"},
            "headings": {"en": "Notifikasi baru"},
            "contents": {"en": message}
          });
      if (response.statusCode == 200) {
        print('role notification sent');
      }
    } on DioError catch (e) {
      print(e.response.statusMessage);
    }
  }
}
