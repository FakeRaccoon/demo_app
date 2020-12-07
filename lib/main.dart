import 'package:atana/form_monitoring_pengasan_demo.dart';
import 'package:atana/form_monitoring_permintaan_demo.dart';
import 'package:atana/root.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.init("956ae786-10ab-4d63-a9dd-82fb34904881");
  OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
  OneSignal.shared.setNotificationReceivedHandler((notification) {
    print(notification.payload.body);
  });
  OneSignal.shared.setNotificationOpenedHandler((openedResult) {
    if (openedResult.notification.payload.body == "Permintaan demo") {
      Get.to(MonitoringDemo());
    }
    if (openedResult.notification.payload.body == "Permintaan penugasan") {
      Get.to(MonitoringPenugasa());
    }
  });
  await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Root(),
    );
  }
}
