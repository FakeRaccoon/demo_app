import 'dart:convert';

import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;


var notificationUrl = "https://onesignal.com/api/v1/notifications";
var notificationKey = "YjY1MmY2NTUtY2YwNC00OGRlLThkNTgtZmVkNGE0ODA0NmUz";
var customExternalUserId = "direktur";

class Notif {

  static Future getOneSignal() async {
    var userId = await OneSignal.shared.setExternalUserId(customExternalUserId);
    print(userId);
  }

  static Future sendAndGetNotification() async {
    final response = await http.post(notificationUrl,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "BASIC " + notificationKey,
        },
        body: jsonEncode({
          "app_id": "956ae786-10ab-4d63-a9dd-82fb34904881",
          "include_external_user_ids": [customExternalUserId],
          "channel_for_external_user_ids": "push",
          "data": {"foo": "bar"},
          "headings": {"en": "Halo!"},
          "contents": {"en": "Ada notifikasi baru nih"}
        }));
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print(response.body);
      print(customExternalUserId);
    }
  }
}