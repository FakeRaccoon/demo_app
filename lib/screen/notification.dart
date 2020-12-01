import 'dart:convert';

import 'package:atana/Examples/add_data.dart';
import 'package:atana/screen/new_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final scaffoldState = GlobalKey<ScaffoldState>();
  final firebaseMessaging = FirebaseMessaging();
  final List<Message> messages = [];

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);

    sendAndRetrieve();
  }

  showNotification() async {
    var android = AndroidNotificationDetails('id', 'channel', 'description',
        priority: Priority.high, importance: Importance.max);
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin
        .show(0, 'Yeyy', 'Pengajuan demo baru tersedia!!', platform, payload: 'Welcome');
  }

  Future onSelectNotification(String payload) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return NewScreen(payload: payload);
    }));
  }

  Future sendAndRetrieve() async {
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        {
          'notification': {
            'body': 'this is a body',
            'title': 'this is a title',
          },
          'priority': 'high',
          'data': {'click_action': 'FLUTTER_NOTIFICATION_CLICK', 'id': '1', 'status': 'done'},
          'to': '$token',
        },
      ),
    );
    print(token);
  }

  String token;
  final String serverToken =
      "AAAAxRGp6Fw:APA91bE7lH_kkGDqoGXcm54kveRUJOJ6Qy6KBSTx2J8d5vqgtxJff7bna9bA9klcmI6rgUzZ1Dut4lTzbLCka6hTZ6828CUDKMXT7iViJIRsaMBNg24tltNE50nF3pBS3cNdGdJiRREW";

  @override
  Widget build(BuildContext context) {
    return ListView(
    );
  }
}
