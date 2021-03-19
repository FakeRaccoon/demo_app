import 'package:atana/model/form_model.dart';
import 'package:atana/model/user_model.dart';
import 'package:atana/service/api.dart';
import 'package:atana/service/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserManagement extends StatefulWidget {
  @override
  _UserManagementState createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onRefresh();
  }

  Future userFuture;

  Future onRefresh() async {
    userFuture = API.getUser('');
    setState(() {});
  }

  List<String> role = [
    'Admin',
    'Direktur',
    'Manager Marketing',
    'Manager Service',
    'Kepala Gudang Barang Demo',
    'Kepala Gudang Lainnya',
    'Sales',
    'Teknisi',
    'Kasir',
  ];

  SharedPreferences sharedPreferences;

  Future updateUser(int id, String name, String username, String role) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    try {
      final response = await Dio().put(baseDemoUrl + "user/update",
          options: Options(headers: {
            'Authorization': "Bearer $token",
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }),
          queryParameters: {
            "id": id,
            "name": name,
            "username": username,
            "role": role,
          });
      if (response.statusCode == 200) {
        NotificationAPI.usernameNotification(
          username,
          "$name, role anda sudah diperbarui menjadi $role. Silahkan login ulang",
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data berhasil diupdate!')));
        onRefresh();
        Navigator.pop(context);
      }
    } on DioError catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.response.statusMessage),
        backgroundColor: Colors.red,
      ));
      Navigator.pop(context);
    }
  }

  // Future firebaseNotification(username) async {
  //   await FirebaseFirestore.instance.collection('Users').doc(username).collection('notifications').add({});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
      ),
      body: FutureBuilder(
        future: userFuture,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                UserResult user = snapshot.data[index];
                if (user.username.toLowerCase().contains('superuser')) {
                  return SizedBox();
                } else {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.username),
                          SizedBox(height: 10),
                          Divider(thickness: 1),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(user.name),
                            subtitle: Text(user.role ?? 'User ini belum mempunyai role'),
                            trailing: IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => buildShowMaterialModalBottomSheet(context, user, index),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future buildShowMaterialModalBottomSheet(BuildContext context, UserResult user, index) {
    return showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * .60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('Role', style: GoogleFonts.sourceSansPro(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  shrinkWrap: true,
                  itemCount: role.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      onTap: () {
                        updateUser(user.id, user.name, user.username, role[i] ?? user.role);
                      },
                      contentPadding: EdgeInsets.zero,
                      title: Text(role[i]),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(thickness: 1);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
