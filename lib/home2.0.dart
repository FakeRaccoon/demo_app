import 'package:atana/component/customMenuCard.dart';
import 'package:atana/form_monitoring_pengasan_demo.dart';
import 'package:atana/form_monitoring_permintaan_demo.dart';
import 'package:atana/form_permintaan_keliling.dart';
import 'package:atana/login.dart';
import 'package:atana/model/user_model.dart';
import 'package:atana/perjalanan_demo.dart';
import 'package:atana/root.dart';
import 'package:atana/screen/kasir.dart';
import 'package:atana/screen/kepala_gudang.dart';
import 'package:atana/screen/teknisi.dart';
import 'package:atana/service/api.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home2 extends StatefulWidget {
  @override
  _Home2State createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  UserModel user = UserModel('');
  bool pengajuanDemo = false;
  bool permintaanDemo = false;
  bool penugasanDemo = false;
  bool perjalananDemo = false;
  bool peminjamanBarangDemo = false;
  bool peminjamanBarangGudang = false;
  bool cashierPage = false;
  bool technicianPage = false;
  String userRole;
  String userToken;
  String _userName;

  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Login()),
          (Route<dynamic> route) => false);
    } else {
      setState(() {
        _userName = sharedPreferences.getString('username');
        userRole = sharedPreferences.getString('role');
      });
      roleCheck();
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
                      Text('Hi, ', style: GoogleFonts.openSans(fontSize: 22, color: Colors.grey[500])),
                      Text(sharedPreferences?.getString('username') ?? '',
                          style: GoogleFonts.openSans(fontSize: 22)),
                    ],
                  ),
                  Text(sharedPreferences?.getString('role') ?? '', style: GoogleFonts.openSans(fontSize: 14)),
                ],
              ),
            ),
            SizedBox(height: 50),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              children: [
                CustomMenuCard(
                  icon: FontAwesomeIcons.solidCopy,
                  title: 'Pengajuan Demo',
                  visibility: pengajuanDemo,
                  ontap: () => Get.to(PermintaanKeliling()),
                ),
                CustomMenuCard(
                  icon: FontAwesomeIcons.userCheck,
                  title: 'Monitoring Permintaan Demo',
                  visibility: permintaanDemo,
                  ontap: () => Get.to(MonitoringDemo()),
                ),
                CustomMenuCard(
                  icon: FontAwesomeIcons.chalkboardTeacher,
                  title: 'Monitoring Penugasan Demo',
                  visibility: penugasanDemo,
                  ontap: () => Get.to(MonitoringPenugasa()),
                ),
                CustomMenuCard(
                  icon: FontAwesomeIcons.truck,
                  title: 'Perjalanan Demo',
                  visibility: perjalananDemo,
                  ontap: () => Get.to(PerjalananDemo()),
                ),
                CustomMenuCard(
                  icon: FontAwesomeIcons.peopleCarry,
                  title: 'Peminjaman Barang',
                  visibility: peminjamanBarangDemo,
                  ontap: () => Get.to(Warehouse()),
                ),
                CustomMenuCard(
                  icon: FontAwesomeIcons.solidMoneyBillAlt,
                  title: 'Kasir',
                  visibility: cashierPage,
                  ontap: () => Get.to(Cashier()),
                ),
                CustomMenuCard(
                  icon: FontAwesomeIcons.wrench,
                  title: 'Teknisi',
                  visibility: technicianPage,
                  ontap: () => Get.to(Technician()),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  roleCheck() async {
    if (userRole == 'Admin') {
      setState(() {
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
    if (userRole == 'Sales') {
      pengajuanDemo = true;
      permintaanDemo = false;
      penugasanDemo = false;
      perjalananDemo = false;
      peminjamanBarangDemo = false;
      peminjamanBarangGudang = false;
      cashierPage = false;
      technicianPage = false;
    }
  }

  // _getProfileData() async {
  //   final uid = FirebaseAuth.instance.currentUser.uid;
  //   await FirebaseFirestore.instance
  //       .collection('Users')
  //       .doc(uid)
  //       .get()
  //       .then((result) => {
  //             user.status = result.data()['status'],
  //             user.name = result.data()['name'],
  //           });
  // }

  // Widget adminFeature() {
  //   if (_userStatus == 'Manager Marketing') {
  //     return formMonitoring();
  //   } else if (_userStatus == 'Sales') {
  //     return formPermintaan();
  //   } else if (_userStatus == 'Direktur') {
  //     return formMonitoring();
  //   } else if (_userStatus == 'Manager Service') {
  //     return formPenugasan();
  //   } else if (_userStatus == '') {
  //     return formWaiting();
  //   }
  // }
  //
  // Widget formPenugasan() {
  //   return MonitoringPenugasa();
  // }
  //
  // Widget formPermintaan() {
  //   return PermintaanKeliling();
  // }
  //
  // Widget formMonitoring() {
  //   return MonitoringDemo();
  // }
  //
  // Widget formWaiting() {
  //   return WaitingPage();
  // }
}
