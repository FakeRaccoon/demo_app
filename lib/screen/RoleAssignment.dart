import 'package:atana/model/form_model.dart';
import 'package:atana/model/user_model.dart';
import 'package:atana/service/api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
    'Drirektur',
    'Manager Marketing',
    'Manager Service',
    'Kepala Gudang Barang Demo',
    'Kepala Gudang Lainnya',
    'Sales',
    'Teknisi',
    'Kasir',
  ];

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
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(20),
                    title: Text(snapshot.data[index].name),
                    subtitle: Text(snapshot.data[index].role ?? 'No role'),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => buildShowMaterialModalBottomSheet(context, snapshot, index),
                    ),
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future buildShowMaterialModalBottomSheet(BuildContext context, AsyncSnapshot snapshot, index) {
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
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text('Role', style: GoogleFonts.sourceSansPro(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  shrinkWrap: true,
                  itemCount: role.length,
                  itemBuilder: (context, i) {
                    UserResult user = snapshot.data[index];
                    return ListTile(
                      onTap: () {
                        API.updateUser(user.id, user.name, user.username, role[i] ?? user.role).whenComplete(() {
                          onRefresh();
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('Data berhasil diupdate!')));
                          Navigator.pop(context);
                        });
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
