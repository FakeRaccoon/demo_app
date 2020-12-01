import 'package:atana/component/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../component/cusomTF.dart';
import '../service/database.dart';
import '../home.dart';

class AddData extends StatefulWidget {
  @override
  _AddDataState createState() => _AddDataState();
}

String status;

String uid = FirebaseAuth.instance.currentUser.uid;
String _googleUsername = FirebaseAuth.instance.currentUser.displayName;
TextEditingController nameController = TextEditingController();

String _valStatus;
List _listStatus = [
  'Direktur',
  'Manager Marketing',
  'Sales',
  'Manager Service'
];

class _AddDataState extends State<AddData> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Hi, ', style: GoogleFonts.openSans(fontSize: 18)),
                    Text(_googleUsername,
                        style: GoogleFonts.openSans(fontSize: 18) ?? 'Null'),
                  ],
                ),
                Text('Silahkan isi Informasi user baru.',
                    style: GoogleFonts.openSans(fontSize: 16)),
                SizedBox(height: MediaQuery.of(context).size.height * .10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nama :', style: GoogleFonts.openSans(fontSize: 16)),
                    SizedBox(height: 10),
                    CustomTextField(
                      readOnly: false,
                      controller: nameController,
                      icon: Icon(Icons.person),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Text('Status :', style: GoogleFonts.openSans(fontSize: 16)),
                // SizedBox(height: 10),
                // Container(
                //   height: 50,
                //   width: double.infinity,
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(20),
                //       color: Color.fromRGBO(231, 235, 237, 100)),
                //   child: DropdownButtonHideUnderline(
                //     child: ButtonTheme(
                //       padding: EdgeInsets.only(right: 10),
                //       alignedDropdown: true,
                //       child: DropdownButton(
                //         hint: Text("Pilih Status"),
                //         value: _valStatus,
                //         items: _listStatus.map((value) {
                //           return DropdownMenuItem(
                //             child: Text(value),
                //             value: value,
                //           );
                //         }).toList(),
                //         onChanged: (value) {
                //           setState(() {
                //             _valStatus = value;
                //           });
                //         },
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(height: 10),
                CustomButton(
                  title: 'Daftar',
                  ontap: () async {
                    await Database()
                        .addUserDetail(uid, '', nameController.text, false)
                        .whenComplete(() async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(),
                        ),
                      );
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
