import 'package:atana/Body.dart';
import 'package:atana/form_permintaan_keliling.dart';
import 'package:atana/home2.0.dart';
import 'package:atana/login.dart';
import 'package:atana/perjalanan_demo.dart';
import 'package:atana/root.dart';
import 'package:atana/screen/kasir.dart';
import 'package:atana/screen/teknisi.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.init("956ae786-10ab-4d63-a9dd-82fb34904881");
  OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
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
