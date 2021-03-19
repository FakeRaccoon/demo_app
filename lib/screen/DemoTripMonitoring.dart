import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:atana/model/form_model.dart';
import 'package:atana/model/warehouse_check_model.dart';
import 'package:atana/service/api.dart';
import 'package:atana/service/notification.dart';
import 'package:dio/dio.dart';
import 'package:flushbar/flushbar.dart';
import 'package:http/http.dart' as http;
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    date();
  }

  Future date() async {
    print(DateFormat('d/M/y').format(DateTime.now()));
  }

  Future formFuture;
  Future processFuture;

  Future onRefresh() async {
    formFuture = API.getFormStatus(4);
    // formFuture = API.getFormStatus(5);
    setState(() {});
  }

  SharedPreferences sharedPreferences;

  Future updateFinalTech(int formId) async {
    try {
      final response = await Dio().post(baseDemoUrl + 'technician/update/final', queryParameters: {
        'form_id': formId,
        'confirmed': 1,
      });
      if (response.statusCode == 200) {
        print(response.data);
      }
    } on DioError catch (e) {
      print(e.response.data);
    }
  }

  /// Mutasi

  Future mutasi(itemId, warehouseIdSource, unitMeasureId) async {
    try {
      final atanaResponse = await Dio().post(atanaUrl + "login/signin",
          options: Options(headers: {
            "username": "FLUTTERAPPS",
            "password": "a0d2f3a1ebdcf8681c5fd16f3d28a9cc",
          }));
      if (atanaResponse.statusCode == 200) {
        var atanaToken = atanaResponse.data['token']['tokenKey'];
        final url = Uri.http("192.168.0.250:5050", "api/Mutasi/PostMutasi");
        try {
          final response = await http.post(url,
              headers: {
                'Authorization': 'Bearer $atanaToken',
                'Content-Type': 'application/json',
              },
              body: jsonEncode({
                "mutasiExtCode": null,
                "mutasiDate": "${DateFormat('M/d/y').format(DateTime.now())}",
                "mutasiCategoryId": null,
                "warehouseIdSource": warehouseIdSource,
                "warehouseIdDest": 64,
                "flagUseDORR": "0",
                "deliveryOrderCode": null,
                "receivingRecordCode": null,
                "journalCode": null,
                "costProfitId": 1,
                "internalMemo": null,
                "statementMemo": "DEMO APP",
                "author": "DEMO APP",
                "mutasiDt": [
                  {
                    "orderNo": 1,
                    "itemId": itemId,
                    "description": "DEMO APP",
                    "qtyDisplay": 1,
                    "unitMeasureId": unitMeasureId,
                    "constValue": 1.0,
                    "qty": 1.0000,
                    "cogs": 0.0000,
                    "amount": 0.0000,
                    "author": "DEMO APP"
                  }
                ]
              }));
          if (response.statusCode == 200) {
            print(response.body);
            print('Mutasi Berhasil');
          }
        } on SocketException {
          print('Connection Error');
        } on HttpException {
          print("Not found");
        } on FormatException {
          print("Bad Request");
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future qtyPending(itemId, warehouseIdSource, unitMeasureId, expireDate) async {
    try {
      final atanaResponse = await Dio().post(atanaUrl + "login/signin",
          options: Options(headers: {
            "username": "FLUTTERAPPS",
            "password": "a0d2f3a1ebdcf8681c5fd16f3d28a9cc",
          }));
      if (atanaResponse.statusCode == 200) {
        var atanaToken = atanaResponse.data['token']['tokenKey'];
        final url = Uri.http("192.168.0.250:5050", "api/StockReadyPendings/PostStockReadyPending");
        try {
          final response = await http.post(url,
              headers: {
                'Authorization': 'Bearer $atanaToken',
                'Content-Type': 'application/json',
              },
              body: jsonEncode({
                "warehouseId": warehouseIdSource,
                "itemId": itemId,
                "partnerIdSalesman": 2317,
                "partnerIdCustomer": null,
                "pendingDate": "${DateFormat('M/d/y').format(DateTime.now())}",
                "pendingExpired": "${DateFormat('M/d/y').format(expireDate)}",
                "qtyDisplay": 1,
                "unitMeasureId": unitMeasureId,
                "constValue": 1,
                "qty": 1,
                "description": "DEMO APP",
                "author": "DEMO APP"
              }));
          if (response.statusCode == 200) {
            print(response.body);
            print('Qty Pending Berhasil');
          }
        } catch (e) {
          print('qty pending error $e');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future updateFormStatus(status, id) async {
    final String url = baseDemoUrl + "form/update/status";
    try {
      final response = await Dio().post(url, queryParameters: {
        "id": id,
        "status": status,
      });
      if (response.statusCode == 200) {
        print(response.data);
      }
    } on DioError catch (e) {
      print(e.response.data);
    }
  }

  List qtyReady = [];
  List warehouseIdList = [];

  List<WarehouseCheckResult> warehouseCheck = [];

  TextEditingController rejectController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // return DefaultTabController(
    //   length: 3,
    //   child: Scaffold(
    //     extendBodyBehindAppBar: true,
    //     appBar: AppBar(
    //       elevation: 0,
    //       title: Text('Perjalanan demo'),
    //       bottom: TabBar(
    //         tabs: [
    //           Tab(text: 'Pending'),
    //           Tab(text: 'On process'),
    //           Tab(text: 'Completed'),
    //         ],
    //       ),
    //     ),
    //     body: TabBarView(
    //       children: [
    //         pendingUI(context),
    //         onProcess(context),
    //         onProcess(context),
    //       ],
    //     ),
    //   ),
    // );
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        title: Text('Perjalanan demo'),
      ),
      body: pendingUI(context),
    );
  }

  Widget onProcess(BuildContext context) {
    return Center(
      child: Text('On process'),
    );
  }

  Stack pendingUI(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * .25,
          decoration:
              BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
        ),
        FutureBuilder(
          future: formFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.isEmpty) {
                return Scaffold(
                  body: Center(
                    child: Text('Tidak ada permintaan perjalanan demo baru'),
                  ),
                );
              }
              return SafeArea(
                child: ListView.builder(
                  padding: EdgeInsets.all(10),
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (_, index) {
                    FormResult form = snapshot.data[index];
                    int feeTotal = form.fee.map((e) => e.fee).toList().fold(0, (p, e) => p + e);
                    return showUI(index, feeTotal, context, form);
                  },
                ),
              );
            }
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget showUI(int index, int feeTotal, BuildContext context, FormResult form) {
    return Card(
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
                  form.item,
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
              Text('TIPE DEMO', style: GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.grey)),
              Text(form.type, style: GoogleFonts.openSans(fontSize: 16)),
              SizedBox(height: 10),
              Text('GUDANG', style: GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.grey)),
              Text(form.warehouse, style: GoogleFonts.openSans(fontSize: 16)),
              SizedBox(height: 10),
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
                    child: OutlinedButton(
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
                                            onPressed: () async {
                                              sharedPreferences = await SharedPreferences.getInstance();
                                              final name = sharedPreferences.getString('name');
                                              if (name.isNotEmpty) {
                                                API
                                                    .updateFormStatusAndRejectReason(3, form.id, rejectController.text)
                                                    .whenComplete(() {
                                                  API.createLog(
                                                      'Request perjalanan demo ${form.item} was rejected by $name');
                                                  onRefresh();
                                                  Navigator.pop(context);
                                                });
                                              }
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
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          side: BorderSide(width: 1, color: Colors.red)),
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
                            onPressed: () async {
                              sharedPreferences = await SharedPreferences.getInstance();
                              final name = sharedPreferences.getString('name');
                              if (name.isNotEmpty) {
                                var id = form.id;
                                API
                                    .warehouseCheck(form.itemId)
                                    .then((value) => warehouseCheck = value)
                                    .whenComplete(() {
                                  setState(() {
                                    qtyReady.clear();
                                    warehouseIdList.clear();
                                    qtyReady = warehouseCheck.map((e) => e.qtyReadyBalance).toList();
                                    warehouseIdList = warehouseCheck.map((e) => e.warehouseId).toList();
                                    print(qtyReady);
                                    print(warehouseIdList);
                                    print(form.warehouseId);
                                    if (qtyReady.isNotEmpty && warehouseIdList.contains(form.warehouseId)) {
                                      // var stock =
                                      //     warehouseCheck.where((element) => element.warehouseId == form.warehouseId);
                                      if (form.type == "Tes Mesin") {
                                        print("mutasi asdasdsadas");
                                        mutasi(form.itemId.toDouble(), form.warehouseId, form.itemMeasureId.toDouble());
                                      } else if (form.type == "Display") {
                                        qtyPending(
                                          form.itemId.toDouble(),
                                          form.warehouseId,
                                          form.itemMeasureId.toDouble(),
                                          form.returnDate,
                                        );
                                      }
                                      API.createLog('Request perjalanan demo ${form.item} was approved by $name');
                                      updateFormStatus(5, id);
                                      updateFinalTech(id);
                                      form.technician.forEach((element) {
                                        NotificationAPI.usernameNotification(element.name,
                                            'Ada penugasan pengambilan ${form.item} di ${form.warehouse}');
                                      });
                                      NotificationAPI.roleNotification("Kepala Gudang", "Ada notif baru");
                                      onRefresh();
                                    } else {
                                      Flushbar(
                                        title: "Perhatian",
                                        message: "Stok kosong",
                                        duration: Duration(seconds: 5),
                                        backgroundColor: Colors.red,
                                      )..show(context);
                                    }
                                  });
                                });
                                Navigator.pop(context);
                              }
                            },
                            child: Text('Ya', style: TextStyle(color: Colors.white)),
                          ),
                          title: 'Peringatan',
                          textCancel: 'Batal',
                          middleText: 'Apakah anda yakin?',
                        );
                      },
                      color: Colors.blue,
                      child: Text('Approve',
                          style: GoogleFonts.openSans(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
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
    );
  }
}
