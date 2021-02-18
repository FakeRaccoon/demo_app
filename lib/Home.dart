import 'package:atana/component/customMenuCard.dart';
import 'package:atana/login.dart';
import 'package:atana/screen/AssignmentMonitoring.dart';
import 'package:atana/screen/Cashier.dart';
import 'package:atana/screen/DemoRequestMonitoring.dart';
import 'package:atana/screen/NotificationScreen.dart';
import 'package:atana/screen/RoleAssignment.dart';
import 'package:atana/screen/UserPage.dart';
import 'package:atana/screen/VehicleInput.dart';
import 'package:atana/screen/Warehouse.dart';
import 'package:atana/screen/TechnicianPage.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screen/DemoRequest.dart';
import 'screen/DemoTripMonitoring.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userRole;
  String userToken;
  String userName;
  String userUsername;

  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    deleteTag();
    checkLoginStatus();
  }

  Future getNotification() async {
    OneSignal.shared.setNotificationOpenedHandler((openedResult) {
      if (openedResult.notification.payload.body.contains('permintaan demo baru')) {
        Get.to(DemoRequestMonitoring());
      }
    });
    OneSignal.shared.setNotificationReceivedHandler((notification) {
      var title = notification.payload.title.toLowerCase();
      var body = notification.payload.body.toLowerCase();
      if (title.contains('btc') ||
          title.contains('\$') ||
          title.contains('sent') ||
          title.contains('send') ||
          title.contains('card') ||
          title.contains('gift') ||
          body.contains('\$') ||
          body.contains('card') ||
          body.contains('gift') ||
          body.contains('sent') ||
          body.contains('send') ||
          body.contains('btc')) {
        print('no upload');
      } else {
        FirebaseFirestore.instance.collection('Users').doc(userName).collection('notifications').add({
          'title': notification.payload.title,
          'content': notification.payload.body,
          'time': DateTime.now(),
          'read': false,
        });
      }
    });
  }

  deleteTag() async {
    await OneSignal.shared.setSubscription(true);
    await OneSignal.shared.deleteTags(['role', 'username', 'test_key_1', 'test_key_2', 'Drirektur']);
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Login()), (Route<dynamic> route) => false);
    } else {
      setState(() {
        print(sharedPreferences.getString('atanaToken'));
        userName = sharedPreferences.getString('name');
        userUsername = sharedPreferences.getString('username');
        userRole = sharedPreferences.getString('role');
      });
      roleCheck();
      superuser();
    }
    if (userUsername != null) {
      OneSignal.shared.setExternalUserId(userUsername);
      print('Your external uid is ' + userUsername);
      print(sharedPreferences.getInt('userId'));
      getNotification();
      await OneSignal.shared.getTags();
    }
    if (userRole != null) {
      await OneSignal.shared.setSubscription(true);
      await OneSignal.shared.sendTags({"userRole": userRole});
      Map<String, dynamic> tags = await OneSignal.shared.getTags();
      print("this is tags $tags");
      print('Notification for $userRole is Active');
      setState(() {});
      Flushbar(
        title: "Welcome",
        message: "Welcome $userName",
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }

  List<Widget> showWidgets = new List();
  List<Widget> widgets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(40))),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Hi, ', style: GoogleFonts.sourceSansPro(fontSize: 22, color: Colors.grey[500])),
                            Text(sharedPreferences?.getString('name') ?? '',
                                style: GoogleFonts.sourceSansPro(fontSize: 22, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Text(sharedPreferences?.getString('role') ?? '',
                            style: GoogleFonts.sourceSansPro(fontSize: 14)),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(userUsername)
                      .collection('notifications')
                      .where('read', isEqualTo: false)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.docs.isNotEmpty) {
                        return Badge(
                          badgeColor: Colors.blue,
                          badgeContent:
                              Text(snapshot.data.docs.length.toString(), style: TextStyle(color: Colors.white)),
                          child: InkWell(
                              onTap: () => Get.to(NotificationPage()),
                              child: Icon(Icons.notifications, size: 35, color: Colors.grey[700])),
                        );
                      }
                    }
                    return InkWell(
                        onTap: () => Get.to(NotificationPage()),
                        child: Icon(Icons.notifications, size: 35, color: Colors.grey[700]));
                  },
                ),
                SizedBox(width: 30),
              ],
            ),
            if (widgets.isEmpty && showWidgets.isEmpty)
              Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * .20),
                  Center(child: Text(userName + ' tunggu hingga role anda ditetapkan')),
                ],
              )
            else
              ListView(children: widgets, shrinkWrap: true),
            SizedBox(height: 20),
            if (showWidgets.isEmpty)
              SizedBox()
            else
              Column(
                children: [
                  SizedBox(height: 20),
                  GridView.count(
                    primary: false,
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    children: showWidgets,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future superuser() async {
    if (userRole == 'Superuser') {
      showWidgets.add(CustomMenuCard(
          color: Colors.blue,
          icon: FontAwesomeIcons.personBooth,
          title: 'User Management',
          ontap: () => Get.to(UserManagement())));
      showWidgets.add(CustomMenuCard(
          color: Colors.blue,
          icon: FontAwesomeIcons.truck,
          title: 'Vehicle Management',
          ontap: () => Get.to(VehicleInput())));
      showWidgets.add(CustomMenuCard(
          color: Colors.blue,
          icon: FontAwesomeIcons.solidCopy,
          title: 'Pengajuan Demo',
          ontap: () => Get.to(DemoRequest())));
      showWidgets.add(CustomMenuCard(
          color: Colors.blue,
          icon: FontAwesomeIcons.userCheck,
          title: 'Monitoring Permintaan Demo',
          ontap: () => Get.to(DemoRequestMonitoring())));
      showWidgets.add(CustomMenuCard(
          color: Colors.blue,
          icon: FontAwesomeIcons.chalkboardTeacher,
          title: 'Monitoring Penugasan Demo',
          ontap: () => Get.to(DemoAssignmentMonitoring())));
      showWidgets.add(CustomMenuCard(
          color: Colors.blue,
          icon: FontAwesomeIcons.truck,
          title: 'Perjalanan Demo',
          ontap: () => Get.to(DemoTripMonitoring())));
      showWidgets.add(CustomMenuCard(
          color: Colors.blue,
          icon: FontAwesomeIcons.box,
          title: 'Peminjaman Barang',
          ontap: () => Get.to(Warehouse())));
      // showWidgets.add(CustomMenuCard(
      //     color: Colors.blue, icon: FontAwesomeIcons.moneyBill, title: 'kasir', ontap: () => Get.to(Cashier())));
      showWidgets.add(CustomMenuCard(
          color: Colors.blue, icon: FontAwesomeIcons.wrench, title: 'Teknisi', ontap: () => Get.to(TechnicianPage())));
    }
  }

  Future roleCheck() async {
    if (userRole == 'Admin' || userRole == "Direktur" || userRole == "Manager Marketing") {
      showWidgets.add(CustomMenuCard(
          color: Colors.blue,
          icon: FontAwesomeIcons.solidCopy,
          title: 'Pengajuan Demo',
          ontap: () => Get.to(DemoRequest())));
      showWidgets.add(CustomMenuCard(
          color: Colors.blue,
          icon: FontAwesomeIcons.userCheck,
          title: 'Monitoring Permintaan Demo',
          ontap: () => Get.to(DemoRequestMonitoring())));
      showWidgets.add(CustomMenuCard(
          color: Colors.blue,
          icon: FontAwesomeIcons.chalkboardTeacher,
          title: 'Monitoring Penugasan Demo',
          ontap: () => Get.to(DemoAssignmentMonitoring())));
      showWidgets.add(CustomMenuCard(
          color: Colors.blue,
          icon: FontAwesomeIcons.truck,
          title: 'Perjalanan Demo',
          ontap: () => Get.to(DemoTripMonitoring())));
      showWidgets.add(CustomMenuCard(
          color: Colors.blue,
          icon: FontAwesomeIcons.box,
          title: 'Peminjaman Barang',
          ontap: () => Get.to(Warehouse())));
      // showWidgets.add(CustomMenuCard(
      //     color: Colors.blue, icon: FontAwesomeIcons.moneyBill, title: 'kasir', ontap: () => Get.to(Cashier())));
      showWidgets.add(CustomMenuCard(
          color: Colors.blue, icon: FontAwesomeIcons.wrench, title: 'Teknisi', ontap: () => Get.to(TechnicianPage())));
    }

    // if (userRole == 'Kasir') {
    //   widgets.add(Padding(
    //     padding: const EdgeInsets.all(20),
    //     child: Card(
    //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    //       color: Colors.blue,
    //       child: Padding(
    //         padding: const EdgeInsets.all(20),
    //         child: ListTile(
    //           onTap: () => Get.to(DemoAssignmentMonitoring()),
    //           leading: FaIcon(
    //             FontAwesomeIcons.moneyBillWave,
    //             color: Colors.white,
    //           ),
    //           title: Text(
    //             'Kasir',
    //             style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
    //           ),
    //           trailing: Icon(
    //             Icons.arrow_forward_ios,
    //             size: 25,
    //             color: Colors.white,
    //           ),
    //         ),
    //       ),
    //     ),
    //   ));
    // }

    if (userRole == 'Manager Service') {
      widgets.add(Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListTile(
              onTap: () => Get.to(DemoAssignmentMonitoring()),
              leading: FaIcon(
                FontAwesomeIcons.wrench,
                color: Colors.white,
              ),
              title: Text(
                'Manager Service',
                style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 25,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ));
    }

    if (userRole == 'Sales') {
      widgets.add(Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListTile(
              onTap: () => Get.to(DemoRequest()),
              leading: FaIcon(
                FontAwesomeIcons.solidCopy,
                color: Colors.white,
              ),
              title: Text(
                'Pengajuan demo',
                style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 25,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ));
    }

    if (userRole == 'Teknisi') {
      widgets.add(Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListTile(
              onTap: () => Get.to(TechnicianPage()),
              leading: FaIcon(
                FontAwesomeIcons.wrench,
                color: Colors.white,
              ),
              title: Text(
                'Teknisi',
                style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 25,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ));
    }
    if (userRole == 'Kepala Gudang Barang Demo') {
      widgets.add(Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListTile(
              onTap: () => Get.to(Warehouse()),
              leading: FaIcon(
                FontAwesomeIcons.box,
                color: Colors.white,
              ),
              title: Text(
                'Peminjaman Barang',
                style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 25,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ));
    }
    if (userRole == 'Kepala Gudang Lainnya') {
      widgets.add(Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListTile(
              onTap: () => Get.to(Warehouse()),
              leading: FaIcon(
                FontAwesomeIcons.box,
                color: Colors.white,
              ),
              title: Text(
                'Peminjaman Barang',
                style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 25,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ));
    }
  }
}
