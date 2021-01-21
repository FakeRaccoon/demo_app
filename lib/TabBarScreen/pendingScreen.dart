import 'dart:async';

import 'package:atana/service/api.dart';
import 'package:atana/service/notification.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PendingScreen extends StatefulWidget {
  @override
  _PendingScreenState createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadForm();
    _pendingController = new StreamController();
  }

  StreamController _pendingController;

  Future loadForm() async {
    API.getFormStatus(1).then((value) async {
      _pendingController.add(value);
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _pendingController.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data.isNotEmpty) {
              return Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * .25,
                    color: Colors.blue,
                  ),
                  SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 10),
                          child: Row(
                            children: [
                              Text('Pending ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                              Text(snapshot.data.length.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data.length,
                            itemBuilder: (_, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: ExpandablePanel(
                                      header: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            title: Text(
                                              snapshot.data[index].item.atanaName,
                                              style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 18),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(snapshot.data[index].city,
                                                        style: GoogleFonts.openSans(fontSize: 16)),
                                                    Text(
                                                        snapshot.data[index].district == null
                                                            ? ''
                                                            : ', ${snapshot.data[index].district}',
                                                        style: GoogleFonts.openSans(fontSize: 16)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      expanded: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Divider(thickness: 1),
                                          SizedBox(height: 10),
                                          Text('Detail',
                                              style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold)),
                                          SizedBox(height: 10),
                                          Text('TIPE DEMO',
                                              style: GoogleFonts.openSans(
                                                  fontWeight: FontWeight.bold, color: Colors.grey)),
                                          Text(snapshot.data[index].type, style: GoogleFonts.openSans(fontSize: 16)),
                                          SizedBox(height: 10),
                                          Text('SALES',
                                              style: GoogleFonts.openSans(
                                                  fontWeight: FontWeight.bold, color: Colors.grey)),
                                          Text(snapshot.data[index].user.name,
                                              style: GoogleFonts.openSans(fontSize: 16)),
                                          SizedBox(height: 10),
                                          Text('TANGGAL ESTIMASI',
                                              style: GoogleFonts.openSans(
                                                  fontWeight: FontWeight.bold, color: Colors.grey)),
                                          Text(
                                              DateFormat('MMMM y')
                                                  .format(snapshot.data[index].estimatedDate)
                                                  .toString(),
                                              style: GoogleFonts.openSans(fontSize: 16)),
                                          SizedBox(height: 20),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: OutlineButton(
                                                  onPressed: () {
                                                    Get.defaultDialog(
                                                      cancel: OutlineButton(
                                                        borderSide: BorderSide(color: Colors.red),
                                                        onPressed: () => Navigator.pop(context),
                                                        child: Text(
                                                          'Batal',
                                                          style: TextStyle(color: Colors.red),
                                                        ),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(20)),
                                                      ),
                                                      confirm: FlatButton(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(20)),
                                                        color: Colors.blue,
                                                        onPressed: () {
                                                          var id = snapshot.data[index].id;
                                                          print(id);
                                                          API.updateFormStatus(3, id);
                                                          Notif.usernameNotification(snapshot.data[index].user.name,
                                                                  '${snapshot.data[index].user.name}, pengajuan demo barang ${snapshot.data[index].user.name} anda di reject 😨')
                                                              .whenComplete(() {});
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text(
                                                          'Ya',
                                                          style: TextStyle(color: Colors.white),
                                                        ),
                                                      ),
                                                      title: 'Peringatan',
                                                      textCancel: 'Batal',
                                                      middleText: 'Apakah anda yakin?',
                                                    );
                                                  },
                                                  shape:
                                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                  borderSide: BorderSide(color: Colors.red),
                                                  child: Text(
                                                    'Reject',
                                                    style: TextStyle(color: Colors.red),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: FlatButton(
                                                  onPressed: () {
                                                    Get.defaultDialog(
                                                      cancel: OutlineButton(
                                                        borderSide: BorderSide(color: Colors.red),
                                                        onPressed: () => Navigator.pop(context),
                                                        child: Text(
                                                          'Batal',
                                                          style: TextStyle(color: Colors.red),
                                                        ),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(20)),
                                                      ),
                                                      confirm: FlatButton(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(20)),
                                                        color: Colors.blue,
                                                        onPressed: () {
                                                          var id = snapshot.data[index].id;
                                                          API.updateFormStatus(2, id);
                                                          Notif.usernameNotification(snapshot.data[index].user.username,
                                                                  '${snapshot.data[index].user.name}, pengajuan demo barang ${snapshot.data[index].item.atanaName} anda di approve')
                                                              .whenComplete(() {});
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text(
                                                          'Ya',
                                                          style: TextStyle(color: Colors.white),
                                                        ),
                                                      ),
                                                      title: 'Peringatan',
                                                      textCancel: 'Batal',
                                                      middleText: 'Apakah anda yakin?',
                                                    );
                                                  },
                                                  color: Colors.blue,
                                                  child: Text(
                                                    'Approve',
                                                    style: GoogleFonts.openSans(
                                                        color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                                                  ),
                                                  height: 40,
                                                  minWidth: MediaQuery.of(context).size.width / 2,
                                                  shape:
                                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return Scaffold(
              body: Center(
                child: Text('Tidak ada permintaan demo baru'),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
