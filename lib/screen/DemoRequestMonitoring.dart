import 'dart:async';
import 'dart:core';

import 'package:atana/model/form_model.dart';
import 'package:atana/service/api.dart';
import 'package:atana/service/notification.dart';
import 'package:expandable/expandable.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DemoRequestMonitoring extends StatefulWidget {
  @override
  _DemoRequestMonitoringState createState() => _DemoRequestMonitoringState();
}

class _DemoRequestMonitoringState extends State<DemoRequestMonitoring> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onRefresh();
    getUserInfo();
  }

  SharedPreferences sharedPreferences;

  Future getUserInfo() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final getName = sharedPreferences.getString('name');
    if (getName != null) {
      setState(() {
        name = getName;
      });
    }
  }

  String name;

  Future pendingFuture;
  Future approveFuture;
  Future rejectFuture;

  Future onRefresh() async {
    pendingFuture = API.getFormStatus(1);
    approveFuture = API.getFormStatus(2);
    rejectFuture = API.getFormStatus(3);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          title: Text('Monitoring permintaan demo'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Approved'),
              Tab(text: 'Rejected'),
            ],
          ),
        ),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                color: Colors.blue,
              ),
            ),
            TabBarView(
              children: [
                pendingUI(),
                approveUI(),
                rejectUI(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget pendingUI() {
    return FutureBuilder(
      future: pendingFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.isNotEmpty) {
            return SafeArea(
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
                    child: RefreshIndicator(
                      onRefresh: onRefresh,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, index) {
                          FormResult form = snapshot.data[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: ExpandablePanel(
                                  theme: ExpandableThemeData(headerAlignment: ExpandablePanelHeaderAlignment.center),
                                  header: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(
                                          form.item,
                                          style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 18),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(form.city.name, style: GoogleFonts.openSans(fontSize: 16)),
                                                Text(form.district == null ? '' : ', ${form.district.name}',
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
                                          style: GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.grey)),
                                      Text(form.type, style: GoogleFonts.openSans(fontSize: 16)),
                                      SizedBox(height: 10),
                                      Text('SALES',
                                          style: GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.grey)),
                                      Text(form.user.name, style: GoogleFonts.openSans(fontSize: 16)),
                                      SizedBox(height: 10),
                                      Text('TANGGAL ESTIMASI',
                                          style: GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.grey)),
                                      Text(DateFormat('MMMM y').format(form.estimatedDate).toString(),
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
                                                    shape:
                                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                  ),
                                                  confirm: FlatButton(
                                                    shape:
                                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                    color: Colors.blue,
                                                    onPressed: () {
                                                      var id = form.id;
                                                      API.updateFormStatus(3, id).whenComplete(() {
                                                        API.createLog(
                                                            'Pengajuan demo ${form.item} was rejected by $name');
                                                        NotificationAPI.usernameNotification(form.user.username,
                                                            '${form.user.name}, pengajuan demo ${form.item} anda di reject');
                                                        NotificationAPI.roleNotification(
                                                            'Manager Service', 'Ada permintaan penugasan baru');
                                                        onRefresh();
                                                        Navigator.pop(context);
                                                        Flushbar(
                                                          message: "Reject berhasil",
                                                          duration: Duration(seconds: 2),
                                                          backgroundColor: Colors.red,
                                                        )..show(context);
                                                      });
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
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                              borderSide: BorderSide(color: Colors.red),
                                              child: Text('Reject', style: TextStyle(color: Colors.red)),
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
                                                    shape:
                                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                  ),
                                                  confirm: FlatButton(
                                                    shape:
                                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                    color: Colors.blue,
                                                    onPressed: () {
                                                      var id = form.id;
                                                      API.updateFormStatus(2, id).whenComplete(() {
                                                        API.createLog(
                                                            'Pengajuan demo ${form.item} was approved by $name');
                                                        NotificationAPI.usernameNotification(
                                                          form.user.username,
                                                          '${form.user.name}, pengajuan demo ${form.item} anda di approve',
                                                        );
                                                        onRefresh();
                                                        Navigator.pop(context);
                                                        Flushbar(
                                                          message: "Approve berhasil",
                                                          duration: Duration(seconds: 2),
                                                        )..show(context);
                                                      });
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
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                  ),
                ],
              ),
            );
          }
          return Scaffold(
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/image1.png', fit: BoxFit.cover),
                  Center(
                      child: Text(
                    'Tidak ada permintaan demo baru.',
                    style: GoogleFonts.openSans(),
                  )),
                ],
              ),
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget approveUI() {
    return FutureBuilder(
      future: approveFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.isEmpty) {
            return Scaffold(
              body: Center(
                child: Text('Belum ada permintaan yang di approve'),
              ),
            );
          }
          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: Row(
                    children: [
                      Text(
                        'Approved ',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        snapshot.data.length.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, index) {
                      FormResult form = snapshot.data[index];
                      return form.status != "Pending" || form.status != "Reject"
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: ExpandablePanel(
                                    theme: ExpandableThemeData(headerAlignment: ExpandablePanelHeaderAlignment.center),
                                    header: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(
                                            form.item,
                                            style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 18),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(form.city.name, style: GoogleFonts.openSans(fontSize: 16)),
                                                  Text(form.district == null ? '' : ', ${form.district.name}',
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
                                            style:
                                                GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.grey)),
                                        Text(form.type, style: GoogleFonts.openSans(fontSize: 16)),
                                        SizedBox(height: 10),
                                        Text('SALES',
                                            style:
                                                GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.grey)),
                                        Text(form.user.name, style: GoogleFonts.openSans(fontSize: 16)),
                                        SizedBox(height: 10),
                                        Text('TANGGAL ESTIMASI',
                                            style:
                                                GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.grey)),
                                        Text(DateFormat('MMMM y').format(form.estimatedDate).toString(),
                                            style: GoogleFonts.openSans(fontSize: 16)),
                                        SizedBox(height: 20),
                                        ButtonTheme(
                                          highlightColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          minWidth: MediaQuery.of(context).size.width,
                                          child: OutlineButton(
                                            onPressed: () =>
                                                API.updateFormStatus(0, form.id).whenComplete(() => onRefresh()),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                            borderSide: BorderSide(color: Colors.red),
                                            child: Text(
                                              'Hapus',
                                              style: TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox();
                    },
                  ),
                ),
              ],
            ),
          );
        }
        if (snapshot.hasError) {
          return Text(snapshot.error);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget rejectUI() {
    return FutureBuilder(
      future: rejectFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.isEmpty) {
            return Scaffold(
              body: Center(
                child: Text('Belum ada permintaan yang di reject'),
              ),
            );
          }
          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: Row(
                    children: [
                      Text('Rejected ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
                      FormResult form = snapshot.data[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: ExpandablePanel(
                              theme: ExpandableThemeData(headerAlignment: ExpandablePanelHeaderAlignment.center),
                              header: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    title: Text(
                                      form.item,
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 18),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(form.city.name, style: GoogleFonts.openSans(fontSize: 16)),
                                            Text(form.district == null ? '' : ', ${form.district.name}',
                                                style: GoogleFonts.openSans(fontSize: 16)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    contentPadding: EdgeInsets.zero,
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
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.grey)),
                                  Text(form.type, style: GoogleFonts.openSans(fontSize: 16)),
                                  SizedBox(height: 10),
                                  Text('SALES',
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.grey)),
                                  Text(form.user.name, style: GoogleFonts.openSans(fontSize: 16)),
                                  SizedBox(height: 10),
                                  Text('TANGGAL ESTIMASI',
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.grey)),
                                  Text(DateFormat('MMMM y').format(form.estimatedDate).toString(),
                                      style: GoogleFonts.openSans(fontSize: 16)),
                                  form.rejectReason == null
                                      ? SizedBox()
                                      : Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 10),
                                            Text('ALASAN REJECT',
                                                style: GoogleFonts.openSans(
                                                    fontWeight: FontWeight.bold, color: Colors.grey)),
                                            Text(form.rejectReason, style: GoogleFonts.openSans(fontSize: 16)),
                                          ],
                                        ),
                                  SizedBox(height: 20),
                                  ButtonTheme(
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    minWidth: MediaQuery.of(context).size.width,
                                    child: OutlineButton(
                                      onPressed: () => API.updateFormStatus(0, form.id).whenComplete(() => onRefresh()),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      borderSide: BorderSide(color: Colors.red),
                                      child: Text(
                                        'Hapus',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
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
          );
        }
        if (snapshot.hasError) {
          return Text(snapshot.error);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
