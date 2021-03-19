import 'package:atana/component/notif_screen_component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getShared();
  }
  //
  // Future getNotification() async {
  //   OneSignal.shared.setNotificationOpenedHandler((openedResult) {
  //     if (openedResult.notification.payload.body.contains('permintaan demo baru')) {
  //       Get.to(DemoRequestMonitoring());
  //     }
  //   });
  //   OneSignal.shared.setNotificationReceivedHandler((notification) {
  //     var title = notification.payload.title;
  //     var body = notification.payload.title;
  //     if (title.contains('btc') ||
  //         title.contains('\$') ||
  //         title.contains('sent') ||
  //         title.contains('send') ||
  //         body.contains('\$') ||
  //         body.contains('sent') ||
  //         body.contains('send') ||
  //         body.contains('btc')) {
  //       print('no upload');
  //     } else {
  //       firestore.collection('Users').doc(name).collection('notifications').add({
  //         'title': notification.payload.title,
  //         'content': notification.payload.body,
  //         'time': DateTime.now(),
  //         'read': false,
  //       });
  //     }
  //   });
  // }

  SharedPreferences sharedPreferences;

  Future getShared() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final getName = sharedPreferences.getString('username');
    if (getName != null) {
      setState(() {
        username = getName;
        print(username);
      });
    }
  }

  String username;

  getState() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Page'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(username)
            .collection('notifications')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error');
          }
          if (snapshot.hasData) {
            if (snapshot.data.docs.isEmpty) {
              return Center(child: Text('Tidak ada notifikasi'));
            }
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                var notif = snapshot.data.docs[index].data();
                var id = snapshot.data.docs[index].id;
                return InkWell(
                  onTap: () async {
                    FirebaseFirestore.instance
                        .collection('Users')
                        .doc(username)
                        .collection('notifications')
                        .doc(id)
                        .update({'read': true});
                  },
                  child: NotificationScreenComponent(
                    title: notif['title'],
                    content: notif['content'],
                    date: notif['time'],
                    colors: notif['read'] == false ? Colors.blue.withOpacity(0.2) : Colors.transparent,
                  ),
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
