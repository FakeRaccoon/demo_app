import 'package:atana/component/CustomOutlineButton.dart';
import 'package:atana/root.dart';
import 'package:atana/screen/FutureBuilder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
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
    final role = sharedPreferences.getString('role');
    await OneSignal.shared.deleteTag(role);
    await OneSignal.shared.setSubscription(false);
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
            color: Colors.blue,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User Page',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User info',
                            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                          ),
                          ListTile(
                            onTap: () => Get.to(FutureBuilderClass()),
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(Icons.person),
                            title: Text('User'),
                            trailing: Icon(Icons.arrow_forward_ios, size: 15),
                          ),
                          Divider(thickness: 1),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(Icons.person),
                            title: Text('User'),
                            trailing: Icon(Icons.arrow_forward_ios, size: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomOutlineButton(
                    title: 'Logout',
                    color: Colors.red,
                    ontap: () {
                      Get.defaultDialog(
                        title: 'Peringatan',
                        textConfirm: 'Ya',
                        middleText: 'Apakah anda yakin ingin keluar?',
                        confirmTextColor: Colors.white,
                        textCancel: 'Batal',
                        onConfirm: () {
                          logout().whenComplete(() {
                            Get.offAll(Root());
                          });
                        },
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
