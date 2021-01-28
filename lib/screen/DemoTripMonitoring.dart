import 'dart:async';

import 'package:atana/model/form_model.dart';
import 'package:atana/service/api.dart';
import 'package:atana/service/notification.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DemoTripMonitoring extends StatefulWidget {
  @override
  _DemoTripMonitoringState createState() => _DemoTripMonitoringState();
}

class _DemoTripMonitoringState extends State<DemoTripMonitoring> {
  var currency = new NumberFormat.decimalPattern();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onRefresh();
  }

  Future formFuture;

  Future onRefresh() async {
    formFuture = API.getFormStatus(4);
    setState(() {});
  }

  TextEditingController rejectController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        title: Text('Perjalanan demo'),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .25,
            color: Colors.blue,
          ),
          FutureBuilder(
            future: formFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.isEmpty) {
                  return Center(
                    child: Text('No Data'),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (_, index) {
                    FormResult form = snapshot.data[index];
                    int feeTotal = form.fee.map((e) => e.fee).toList().fold(0, (p, e) => p + e);
                    return showUI(index, feeTotal, context, form);
                  },
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget showUI(int index, int feeTotal, BuildContext context, FormResult form) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ExpandablePanel(
            theme: ExpandableThemeData(headerAlignment: ExpandablePanelHeaderAlignment.center),
            header: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    form.item.atanaName,
                    style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 17),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  subtitle: Row(
                    children: [
                      Text(form.city.name, style: GoogleFonts.openSans(fontSize: 16)),
                      Text(form.district == null ? '' : ', ${form.district.name}',
                          style: GoogleFonts.openSans(fontSize: 16)),
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
                Text('Detail perjalanan demo', style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('BIAYA', style: GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.grey)),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: form.fee.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Row(
                      children: [
                        Text(form.fee[i].description, style: GoogleFonts.openSans(fontSize: 16)),
                        Spacer(),
                        Text('Rp ' + currency.format(form.fee[i].fee), style: GoogleFonts.openSans(fontSize: 16)),
                      ],
                    );
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      Spacer(),
                      Text('Total', style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
                      SizedBox(width: 10),
                      Text('Rp ' + currency.format(feeTotal).toString(), style: GoogleFonts.openSans(fontSize: 16)),
                    ],
                  ),
                ),
                Text('KENDARAAN', style: GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.grey)),
                Text(form.transport.name, style: GoogleFonts.openSans(fontSize: 16)),
                SizedBox(height: 10),
                Text('TEKNISI YANG DITUGASKAN',
                    style: GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.grey)),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: form.technician.length,
                  itemBuilder: (BuildContext context, int idx) {
                    return Text(form.technician[idx].name, style: GoogleFonts.openSans(fontSize: 16));
                  },
                ),
                SizedBox(height: 10),
                Text('TANGGAL DEMO', style: GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.grey)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('d MMM y').format(form.departureDate).toString(),
                        style: GoogleFonts.openSans(fontSize: 16)),
                    Icon(Icons.arrow_forward),
                    Text(DateFormat('d MMM y').format(form.returnDate).toString(),
                        style: GoogleFonts.openSans(fontSize: 16)),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlineButton(
                        onPressed: () {
                          showMaterialModalBottomSheet(
                              expand: false,
                              shape:
                                  RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
                              context: context,
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: MediaQuery.of(context).viewInsets,
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Alasan reject',
                                            style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold),
                                          ),
                                          TextFormField(
                                            controller: rejectController,
                                            minLines: 10,
                                            maxLines: 10,
                                            decoration: InputDecoration(
                                              hintText: 'Tuliskan alasan reject',
                                              border: InputBorder.none,
                                            ),
                                          ),
                                          ButtonTheme(
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            minWidth: MediaQuery.of(context).size.width,
                                            child: OutlineButton(
                                              onPressed: () {
                                                API
                                                    .updateFormStatusAndRejectReason(3, form.id, rejectController.text)
                                                    .whenComplete(() {
                                                  Navigator.pop(context);
                                                  onRefresh();
                                                });
                                              },
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                              borderSide: BorderSide(color: Colors.red),
                                              child: Text(
                                                'Reject',
                                                style: TextStyle(color: Colors.red),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                            confirm: FlatButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              color: Colors.blue,
                              onPressed: () {
                                var id = form.id;
                                API.updateFormStatus(5, id);
                                Notif.roleNotification("Kepala Gudang", "Ada notif baru").whenComplete(() {
                                  onRefresh();
                                });
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
                          style: GoogleFonts.openSans(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
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
  }
}
