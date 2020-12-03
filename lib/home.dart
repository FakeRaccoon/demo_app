import 'package:atana/form_monitoring_pengasan_demo.dart';
import 'package:atana/form_monitoring_permintaan_demo.dart';
import 'package:atana/form_permintaan_keliling.dart';
import 'package:atana/login.dart';
import 'package:atana/model/user_model.dart';
import 'package:atana/perjalanan_demo.dart';
import 'package:atana/root.dart';
import 'package:atana/screen/kepala_gudang.dart';
import 'package:atana/screen/waiting_page.dart';
import 'package:atana/service/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserModel user = UserModel('');
  bool pengajuanDemo = false;
  bool permintaanDemo = false;
  bool penugasanDemo = false;
  bool perjalananDemo = false;
  bool peminjamanBarangDemo = false;
  bool peminjamanBarangGudang = false;
  String _userStatus;
  String _userName;

  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    API.getEmployee();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Login()),
          (Route<dynamic> route) => false);
    } else {
      print(sharedPreferences.getString('token'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                print(sharedPreferences.getString('token'));
              })
        ],
      ),
      body: FutureBuilder(
        future: _getProfileData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _userStatus = user?.status;
            _userName = user?.name;
            print(user.name);
            roleCheck();
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(sharedPreferences?.getString('token') ?? '',
                      style: GoogleFonts.openSans(fontSize: 18)),
                  Text(user.status, style: GoogleFonts.openSans(fontSize: 14)),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                          physics: BouncingScrollPhysics(),
                          children: [
                            Visibility(
                              visible: pengajuanDemo,
                              child: InkWell(
                                onTap: () => Get.to(PermintaanKeliling()),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            color: Colors.red,
                                            child: Icon(Icons.person),
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        Text(
                                          'Pengajuan demo',
                                          style: GoogleFonts.openSans(
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: permintaanDemo,
                              child: InkWell(
                                onTap: () => Get.to(MonitoringDemo()),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            color: Colors.red,
                                            child: Icon(Icons.person),
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        Text(
                                          'Monitoring permintaan demo',
                                          style: GoogleFonts.openSans(
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: penugasanDemo,
                              child: InkWell(
                                onTap: () => Get.to(MonitoringPenugasa()),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            color: Colors.red,
                                            child: Icon(Icons.person),
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        Text(
                                          'Monitoring penugasan demo',
                                          style: GoogleFonts.openSans(
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: perjalananDemo,
                              child: InkWell(
                                onTap: () => Get.to(PerjalananDemo()),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            color: Colors.red,
                                            child: Icon(Icons.person),
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        Text(
                                          'Perjalanan demo',
                                          style: GoogleFonts.openSans(
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: peminjamanBarangDemo,
                              child: InkWell(
                                onTap: () => Get.to(Warehouse()),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            color: Colors.red,
                                            child: Icon(Icons.person),
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        Text(
                                          'Peminjaman barang demo',
                                          style: GoogleFonts.openSans(
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ) ??
                        Center(child: CircularProgressIndicator()),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  roleCheck() async {
    if (_userStatus == 'Direktur') {
      pengajuanDemo = true;
      permintaanDemo = true;
      penugasanDemo = true;
      perjalananDemo = true;
      peminjamanBarangDemo = true;
      peminjamanBarangGudang = true;
    }
    if (_userStatus == 'Sales') {
      pengajuanDemo = true;
      permintaanDemo = false;
      penugasanDemo = false;
      perjalananDemo = false;
      peminjamanBarangDemo = false;
      peminjamanBarangGudang = false;
    }
  }

  _getProfileData() async {
    final uid = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .get()
        .then((result) => {
              user.status = result.data()['status'],
              user.name = result.data()['name'],
            });
  }

  Widget adminFeature() {
    if (_userStatus == 'Manager Marketing') {
      return formMonitoring();
    } else if (_userStatus == 'Sales') {
      return formPermintaan();
    } else if (_userStatus == 'Direktur') {
      return formMonitoring();
    } else if (_userStatus == 'Manager Service') {
      return formPenugasan();
    } else if (_userStatus == '') {
      return formWaiting();
    }
  }

  Widget formPenugasan() {
    return MonitoringPenugasa();
  }

  Widget formPermintaan() {
    return PermintaanKeliling();
  }

  Widget formMonitoring() {
    return MonitoringDemo();
  }

  Widget formWaiting() {
    return WaitingPage();
  }
}
