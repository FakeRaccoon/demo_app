import 'package:atana/component/notif_screen_component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  SharedPreferences sharedPreferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getShared();
  }

  Future getNotification() async {
    OneSignal.shared.setNotificationReceivedHandler((notification) {
      var title = notification.payload.title;
      var body = notification.payload.title;
      if (title.contains('btc') || body.contains('btc')) {
        print('no upload');
      } else {
        firestore.collection('Users').doc(name).collection('notifications').add({
          'title': notification.payload.title,
          'content': notification.payload.body,
          'time': DateTime.now(),
          'read': false,
        });
      }
    });
  }

  Future getShared() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final getName = sharedPreferences.getString('name');
    if (getName != null) {
      name = getName;
      getNotification();
    }
  }

  String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Page'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('Users').doc(name).collection('notifications').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                var notif = snapshot.data.docs[index].data();
                return NotificationScreenComponent(
                  title: notif['title'],
                  content: notif['content'],
                  date: notif['time'],
                  colors: notif['read'] == false ? Colors.blue.withOpacity(0.3) : Colors.transparent,
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
