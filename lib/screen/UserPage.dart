import 'package:atana/component/CustomOutlineButton.dart';
import 'package:atana/root.dart';
import 'package:atana/screen/LogScreen.dart';
import 'package:atana/service/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  SharedPreferences sharedPreferences;

  Future getUser() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final uname = sharedPreferences.getString('name');
    final urole = sharedPreferences.getString('role');
    if (uname != null && urole != null) {
      setState(() {
        name = uname;
        role = urole;
      });
    }
  }

  String name;
  String role;

  Future<void> logout() async {
    sharedPreferences = await SharedPreferences.getInstance();
    // final role = sharedPreferences.getString('role');
    // await OneSignal.shared.deleteTag('userRole');
    // await OneSignal.shared.deleteTags([
    //   'Admin',
    //   'Direktur',
    //   'Manager Marketing',
    //   'Manager Service',
    //   'Kepala Gudang Barang Demo',
    //   'Kepala Gudang Lainnya',
    //   'Sales',
    //   'Teknisi',
    //   'Kasir',
    // ]);
    // await OneSignal.shared.getTags();
    // await OneSignal.shared.setSubscription(false);
    sharedPreferences.clear();
    sharedPreferences.commit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .25,
            decoration: BoxDecoration(color: Colors.blue),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('User',
                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                  SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('User Info',
                              style: GoogleFonts.openSans(color: Colors.grey, fontWeight: FontWeight.bold)),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person),
                              ],
                            ),
                            title: Text(name ?? "", style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
                            subtitle: Text(role ?? "", style: GoogleFonts.openSans()),
                          ),
                        ],
                      ),
                    ),
                  ),
                  role != 'Superuser' && role != 'Direktur'
                      ? SizedBox()
                      : Column(
                          children: [
                            SizedBox(height: 10),
                            Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Fitur Tambahan',
                                        style: GoogleFonts.openSans(color: Colors.grey, fontWeight: FontWeight.bold)),
                                    ListTile(
                                      onTap: () => Get.to(Log()),
                                      contentPadding: EdgeInsets.zero,
                                      leading: Icon(Icons.list),
                                      title: Text("Log", style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
                                      trailing: Icon(Icons.arrow_forward_ios, size: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                  SizedBox(height: 20),
                  CustomOutlineButton(
                    title: 'Logout',
                    color: Colors.red,
                    ontap: () {
                      Get.defaultDialog(
                        cancel: OutlineButton(
                          borderSide: BorderSide(color: Colors.red),
                          onPressed: () => Navigator.pop(context),
                          child: Text('Batal', style: TextStyle(color: Colors.red)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        confirm: FlatButton(
                          color: Colors.blue,
                          onPressed: () {
                            Navigator.pop(context);
                            logout().then((value) => Get.offAll(Root()));
                          },
                          child: Text('Ya', style: TextStyle(color: Colors.white)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        title: 'Peringatan',
                        middleText: 'Apakah anda yakin ingin logout?',
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
