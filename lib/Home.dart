import 'package:atana/component/customMenuCard.dart';
import 'file:///C:/apps/atana/lib/model/AssignmentMonitoring.dart';
import 'file:///C:/apps/atana/lib/screen/DemoRequestMonitoring.dart';
import 'file:///C:/apps/atana/lib/screen/DemoRequest.dart';
import 'package:atana/login.dart';
import 'file:///C:/apps/atana/lib/screen/DemoTripMonitoring.dart';
import 'package:atana/screen/Cashier.dart';
import 'package:atana/screen/Warehouse.dart';
import 'package:atana/screen/Technician.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool pengajuanDemo = false;
  bool permintaanDemo = false;
  bool penugasanDemo = false;
  bool perjalananDemo = false;
  bool peminjamanBarangDemo = false;
  bool peminjamanBarangGudang = false;
  bool cashierPage = false;
  bool technicianPage = false;
  Color colors;
  String userRole;
  String userToken;
  String userName;

  bool isLoading;

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
          MaterialPageRoute(builder: (BuildContext context) => Login()),
          (Route<dynamic> route) => false);
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
      setState(() {
        isLoading = false;
      });
    }
  }

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Hi, ',
                          style: GoogleFonts.openSans(fontSize: 22, color: Colors.grey[500])),
                      Text(sharedPreferences?.getString('username') ?? '',
                          style: GoogleFonts.openSans(fontSize: 22)),
                    ],
                  ),
                  Text(sharedPreferences?.getString('role') ?? '',
                      style: GoogleFonts.openSans(fontSize: 14)),
                ],
              ),
            ),
            SizedBox(height: 50),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              children: [
                CustomMenuCard(
                    color: pengajuanDemo == true ? Colors.blue : Colors.grey,
                    icon: FontAwesomeIcons.solidCopy,
                    title: 'Pengajuan Demo',
                    ontap: () => pengajuanDemo == true ? Get.to(DemoRequest()) : null),
                CustomMenuCard(
                    color: permintaanDemo == true ? Colors.blue : Colors.grey,
                    icon: FontAwesomeIcons.userCheck,
                    title: 'Monitoring Permintaan Demo',
                    ontap: () => permintaanDemo == true ? Get.to(MonitoringDemo()) : null),
                CustomMenuCard(
                    color: penugasanDemo == true ? Colors.blue : Colors.grey,
                    icon: FontAwesomeIcons.chalkboardTeacher,
                    title: 'Monitoring Penugasan Demo',
                    ontap: () => penugasanDemo == true ? Get.to(MonitoringPenugasa()) : null),
                CustomMenuCard(
                    color: perjalananDemo == true ? Colors.blue : Colors.grey,
                    icon: FontAwesomeIcons.truck,
                    title: 'Perjalanan Demo',
                    ontap: () => perjalananDemo == true ? Get.to(PerjalananDemo()) : null),
                CustomMenuCard(
                    color: peminjamanBarangDemo == true ? Colors.blue : Colors.grey,
                    icon: FontAwesomeIcons.peopleCarry,
                    title: 'Peminjaman Barang',
                    ontap: () => peminjamanBarangDemo == true ? Get.to(Warehouse()) : null),
                CustomMenuCard(
                    color: cashierPage == true ? Colors.blue : Colors.grey,
                    icon: FontAwesomeIcons.solidMoneyBillAlt,
                    title: 'Kasir',
                    ontap: () => cashierPage == true ? Get.to(Cashier()) : null),
                CustomMenuCard(
                    color: technicianPage == true ? Colors.blue : Colors.grey,
                    icon: FontAwesomeIcons.wrench,
                    title: 'Teknisi',
                    ontap: () => technicianPage == true ? Get.to(Technician()) : null),
              ],
            )
          ],
        ),
      ),
    );
  }

  roleCheck() async {
    if (userRole == 'Admin' || userRole == "Direktur") {
      setState(() {
        colors = Colors.blue;
        pengajuanDemo = true;
        permintaanDemo = true;
        penugasanDemo = true;
        perjalananDemo = true;
        peminjamanBarangDemo = true;
        peminjamanBarangGudang = true;
        cashierPage = true;
        technicianPage = true;
      });
    }
    if (userRole == 'Kasir') {
      pengajuanDemo = false;
      permintaanDemo = false;
      penugasanDemo = false;
      perjalananDemo = false;
      peminjamanBarangDemo = false;
      peminjamanBarangGudang = false;
      cashierPage = true;
      technicianPage = false;
    }
    if (userRole == 'Teknisi') {
      pengajuanDemo = false;
      permintaanDemo = false;
      penugasanDemo = false;
      perjalananDemo = false;
      peminjamanBarangDemo = false;
      peminjamanBarangGudang = false;
      cashierPage = false;
      technicianPage = true;
    }
    if (userRole == 'Kepala Teknisi') {
      pengajuanDemo = false;
      permintaanDemo = false;
      penugasanDemo = true;
      perjalananDemo = false;
      peminjamanBarangDemo = false;
      peminjamanBarangGudang = false;
      cashierPage = false;
      technicianPage = false;
    }
  }
}