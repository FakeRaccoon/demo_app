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
  await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, child) {
        return ScrollConfiguration(behavior: MyBehavior(), child: child);
      },
      theme: ThemeData(splashColor: Colors.transparent, highlightColor: Colors.transparent),
      debugShowCheckedModeBanner: false,
      home: Root(),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
