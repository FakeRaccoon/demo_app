import 'package:atana/Body.dart';
import 'package:atana/home.dart';
import 'package:atana/home2.0.dart';
import 'package:atana/root.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
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
  }

  Future<void> logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    sharedPreferences.commit();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => Root()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: InkWell(
          onTap: () {
            Get.defaultDialog(
                title: 'Alert',
                textConfirm: 'Ya',
                middleText: 'Apakah anda ingin keluar?',
                confirmTextColor: Colors.white,
                textCancel: 'Batal',
                onConfirm: () {
                  logout().whenComplete(() {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) => Root()),
                        (Route<dynamic> route) => false);
                  });
                });
          },
          child: Container(
            child: InkWell(
              onTap: logout,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.signOutAlt),
                  Text('Logout'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
