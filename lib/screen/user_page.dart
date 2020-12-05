import 'package:atana/root.dart';
import 'package:flutter/material.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              onTap: () => Get.defaultDialog(
                  title: 'Peringatan',
                  textConfirm: 'Ya',
                  middleText: 'Apakah anda yakin ingin keluar?',
                  confirmTextColor: Colors.white,
                  textCancel: 'Batal',
                  onConfirm: () {
                    logout().whenComplete(() {
                      Get.offAll(Root());
                    });
                  }),
              leading: Icon(Icons.exit_to_app),
              title: Text('Keluar'),
            ),
            Divider(thickness: 1),
          ],
        ),
      ),
    );
  }
}
