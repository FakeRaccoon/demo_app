import 'package:atana/component/customMenuCard.dart';
import 'package:atana/login.dart';
import 'package:atana/screen/AssignmentMonitoring.dart';
import 'package:atana/screen/Cashier.dart';
import 'package:atana/screen/DemoRequestMonitoring.dart';
import 'package:atana/screen/Warehouse.dart';
import 'package:atana/screen/Technician.dart';
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

  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    deleteTag();
    checkLoginStatus();
  }

  deleteTag() async {
    await OneSignal.shared.setSubscription(true);
    await OneSignal.shared.deleteTags(['role', 'username', 'test_key_1', 'test_key_2']);
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Login()), (Route<dynamic> route) => false);
    } else {
      setState(() {
        userName = sharedPreferences.getString('username');
        userRole = sharedPreferences.getString('role');
      });
      roleCheck();
    }
    if (userName != null) {
      OneSignal.shared.setExternalUserId(userName);
      print('Your external uid is ' + userName);
    }
    if (userRole != null) {
      await OneSignal.shared.setSubscription(true);
      await OneSignal.shared.sendTags({userRole: "all"});
      Map<String, dynamic> tags = await OneSignal.shared.getTags();
      print(tags);
      print('Notification for $userRole is Active');
      setState(() {});
    }
  }

  List<Widget> showWidgets = new List();

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
          mainAxisAlignment: MainAxisAlignment.center,
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
                    Text(sharedPreferences?.getString('role') ?? '', style: GoogleFonts.sourceSansPro(fontSize: 14)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            userRole != 'Sales'
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.all(20),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: Colors.blue,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: ListTile(
                          leading: FaIcon(
                            FontAwesomeIcons.solidCopy,
                            color: Colors.white,
                          ),
                          title: Text(
                            'Pengajuan demo',
                            style: GoogleFonts.sourceSansPro(
                                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
            userName != 'kasir'
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.all(20),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: Colors.blue,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: ListTile(
                          leading: FaIcon(
                            FontAwesomeIcons.moneyBill,
                            color: Colors.white,
                          ),
                          title: Text(
                            'Kasir',
                            style: GoogleFonts.sourceSansPro(
                                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
            userName != 'teknisi'
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.all(20),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: Colors.blue,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: ListTile(
                          leading: FaIcon(
                            FontAwesomeIcons.wrench,
                            color: Colors.white,
                          ),
                          title: Text(
                            'Teknisi',
                            style: GoogleFonts.sourceSansPro(
                                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
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

  Future roleCheck() async {
    if (userRole == 'Admin' || userRole == "Direktur") {
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
      showWidgets.add(CustomMenuCard(
          color: Colors.blue, icon: FontAwesomeIcons.moneyBill, title: 'kasir', ontap: () => Get.to(Cashier())));
      showWidgets.add(CustomMenuCard(
          color: Colors.blue, icon: FontAwesomeIcons.wrench, title: 'Teknisi', ontap: () => Get.to(Technician())));
      print(showWidgets);
    }
  }
}
