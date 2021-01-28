import 'dart:async';

import 'package:atana/component/CustomDenseButton.dart';
import 'package:atana/component/Fee.dart';
import 'package:atana/component/FeeCard.dart';
import 'package:atana/component/cusomTF.dart';
import 'package:atana/component/customTFsmall.dart';
import 'package:atana/model/WAREHOUSE.dart';
import 'package:atana/service/api.dart';
import 'package:atana/service/notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/form_model.dart';
import '../model/user_model.dart';

class DemoAssignmentMonitoring extends StatefulWidget {
  @override
  _DemoAssignmentMonitoringState createState() => _DemoAssignmentMonitoringState();
}

class _DemoAssignmentMonitoringState extends State<DemoAssignmentMonitoring> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    formFuture = API.getFormStatus(2);
  }

  Future formFuture;

  SharedPreferences sharedPreferences;
  Future setItemInfo(formId, itemName, itemId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('formId', formId);
    prefs.setString('itemName', itemName);
    prefs.setInt('itemId', itemId);
    Get.to(DemoAssignmentDetail());
  }

  Future onRefresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        title: Text('Monitoring penugasan'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder(
        future: formFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isEmpty) {
              return Scaffold(
                body: Center(
                  child: Text('No data'),
                ),
              );
            }
            return Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .25,
                  color: Colors.blue,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    FormResult form = snapshot.data[index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: ListTile(
                            onTap: () {
                              setItemInfo(form.id, form.item.atanaName, form.item.id);
                            },
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(DateFormat('d').format(form.estimatedDate),
                                    style: GoogleFonts.sourceSansPro(fontSize: 20, fontWeight: FontWeight.bold)),
                                Text(DateFormat('MMM').format(form.estimatedDate),
                                    style: GoogleFonts.sourceSansPro(fontSize: 20, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            title: Text(
                              form.item.atanaName,
                              style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            subtitle: Wrap(
                              children: [
                                Text(
                                  form?.district == null ? form.city.name : '${form.city.name}, ${form.district.name}',
                                  style: GoogleFonts.openSans(fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                            trailing: Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Terjadi kesalahan'),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class DemoAssignmentDetail extends StatefulWidget {
  @override
  _DemoAssignmentDetailState createState() => _DemoAssignmentDetailState();
}

class _DemoAssignmentDetailState extends State<DemoAssignmentDetail> {
  final TextEditingController departDateController = TextEditingController();
  final TextEditingController returnDateController = TextEditingController();

  DateTime departDate;
  DateTime returnDate;

  _departDate() async {
    final DateTime _pickedDate = await showDatePicker(
      context: context,
      initialDate: departDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2100),
    );
    if (_pickedDate != null) {
      setState(() {
        departDate = _pickedDate;
        departDateController.text = DateFormat('d MMMM y').format(departDate);
        returnDate = _pickedDate;
      });
    }
  }

  _returnDate() async {
    final DateTime _pickedDate = await showDatePicker(
      context: context,
      initialDate: returnDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2100),
    );
    if (_pickedDate != null) {
      setState(() {
        returnDate = _pickedDate;
        returnDateController.text = DateFormat('d MMMM y').format(returnDate);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    departDate = DateTime.now();
    returnDate = DateTime.now();
    warehouseFuture = API.getWarehouse();
    driverFuture = API.getUser('');
    transportFuture = API.getTransport();
    getFormDetail();
  }

  Future warehouseFuture;
  Future driverFuture;
  Future transportFuture;

  SharedPreferences sharedPreferences;

  Future getFormDetail() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      docId = sharedPreferences.getInt('formId');
      itemId = sharedPreferences.getInt('itemId');
      item = sharedPreferences.getString('itemName');
    });
    print(sharedPreferences.getInt('formId'));
  }

  List<UserResult> user = [];
  List<FormResult> form = [];

  List temp = [];

  List techDummy = [];
  List techIndex = [];

  bool isReturnDateVisible = false;
  bool isSwitched = false;
  int itemId;
  String transportResult;
  String feeResult;
  String driverResult;
  bool isLoading;
  int docId;
  String item;
  int driverId;
  int transportId;

  var vehicleController = TextEditingController();
  var driverController = TextEditingController();
  var warehouseController = TextEditingController();
  var techController = TextEditingController();
  var currency = NumberFormat.decimalPattern();

  // Future getToken() async {}
  final formKey = new GlobalKey<FormState>();

  List<FeeForm> fees = [];
  int indexCount = 0;

  void onDelete(FeeData feeData) {
    setState(() {
      var find = fees.firstWhere(
        (value) => value.feeData == feeData,
        orElse: () => null,
      );
      if (find != null) fees.removeAt(fees.indexOf(find));
    });
  }

  void onAddForm() {
    if (fees.length > 3) {
      return;
    }
    setState(() {
      var _fees = FeeData();
      fees.add(FeeForm(
        feeData: _fees,
        onDelete: () => onDelete(_fees),
      ));
    });
  }

  void onSave() {
    if (fees.length > 0) {
      var allValid = true;
      fees.forEach((form) => allValid = allValid && form.isValid());
      if (allValid) {
        API.updateForm(docId, 4, driverId, transportId, departDate, returnDate).whenComplete(() {
          Notif.roleNotification("Admin", "Ada permintaan penugasan demo baru!");
          Notif.roleNotification("Direktur", "Ada permintaan penugasan demo baru!");
          fees.forEach((element) {
            var parsed = element.feeData.fee.replaceAll(",", "");
            var f = int.tryParse(parsed);
            print('$f = ${element.feeData.feeDesc}');
            API.updateFormFee(docId, f, element.feeData.feeDesc);
          });
          temp.toSet().toList().forEach((element) {
            API.assignTechnician(element, docId, sharedPreferences.getString('itemName'), departDate, returnDate);
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data berhasil diajukan')));
          isSwitched = false;
          driverController.clear();
          vehicleController.clear();
          departDateController.clear();
          returnDateController.clear();
          setState(() {
            fees.clear();
          });
          Get.off(DemoAssignmentMonitoring());
        });
        // var data = fees.map((it) => it.feeData).toList();
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     fullscreenDialog: true,
        //     builder: (_) => Scaffold(
        //       appBar: AppBar(
        //         title: Text('List of Users'),
        //       ),
        //       body: ListView.builder(
        //         itemCount: data.length,
        //         itemBuilder: (_, i) => ListTile(
        //           leading: CircleAvatar(
        //             child: Text(data[i].fee.substring(0, 1)),
        //           ),
        //           title: Text(data[i].fee),
        //           subtitle: Text(data[i].feeDesc),
        //         ),
        //       ),
        //     ),
        //   ),
        // );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: showUI(),
    );
  }

  Widget showUI() {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Isi data penugasan demo',
                        style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Gudang',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          controller: warehouseController,
                          readOnly: true,
                          onTap: () => warehouseBottomSheet(),
                          decoration: InputDecoration(hintText: 'Pilih Gudang'),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Pilih Teknisi',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          readOnly: true,
                          controller: techController,
                          onTap: () => showMaterialModalBottomSheet(
                            shape:
                                RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
                            isDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return technicianBottom(context);
                            },
                          ),
                          onSaved: (val) => temp.length = val as int,
                          validator: (val) => val.isNotEmpty ? null : 'Pilih teknisi',
                          decoration: InputDecoration(
                            hintText: 'Teknisi',
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          CupertinoSwitch(
                            activeColor: Colors.blue,
                            value: isSwitched,
                            onChanged: (newValue) {
                              setState(() {
                                isSwitched = newValue;
                                driverResult = null;
                              });
                            },
                          ),
                          Text('Perlu Sopir'),
                        ],
                      ),
                      SizedBox(height: 20),
                      isSwitched == true
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sopir',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                CustomTextField(
                                  ontap: () => driverBottomSheet(),
                                  validator: isSwitched == true
                                      ? (String value) {
                                          if (value.isEmpty) {
                                            return 'Isi sopir';
                                          }
                                        }
                                      : null,
                                  controller: driverController,
                                  customHeight: 50,
                                  readOnly: true,
                                  hintText: 'Sopir',
                                  icon: Icon(Icons.arrow_drop_down),
                                ),
                                SizedBox(height: 20),
                              ],
                            )
                          : SizedBox(),
                      Text(
                        'Kendaraan',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      CustomTextField(
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Provinsi tidak boleh kosong';
                          }
                        },
                        ontap: () => transportBottomSheet(),
                        controller: vehicleController,
                        customHeight: 50,
                        readOnly: true,
                        hintText: 'Kendaraan',
                        icon: Icon(Icons.arrow_drop_down),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Tanggal Berangkat',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      CustomTextField(
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Isi tanggal berangkat';
                          }
                        },
                        readOnly: true,
                        ontap: _departDate,
                        controller: departDateController,
                        icon: Icon(Icons.calendar_today),
                        hintText: 'Tanggal Berangkat',
                      ),
                      Visibility(
                        visible: departDateController.text.isEmpty ? false : true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Text(
                              'Tanggal Kembali',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            CustomTextField(
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Isi tanggal kembali';
                                }
                              },
                              readOnly: true,
                              ontap: _returnDate,
                              controller: returnDateController,
                              icon: Icon(Icons.calendar_today),
                              hintText: 'Tanggal Kembali',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: fees.length,
                itemBuilder: (BuildContext context, int index) {
                  return fees[index];
                },
              ),
              FlatButton(
                  onPressed: () {
                    onAddForm();
                    setState(() {
                      indexCount += 1;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 10),
                      Text('Tambah biaya perjalanan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  )),
              SizedBox(height: 20),
              CustomDenseButton(
                color: Colors.blue,
                title: 'Ajukan',
                onTap: () {
                  if (formKey.currentState.validate() && fees.isNotEmpty) {
                    print(docId);
                    onSave();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Tambahkan biaya perjalanan'),
                      backgroundColor: Colors.red,
                    ));
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget technicianBottom(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setModalState) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Teknisi', style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold)),
                  FutureBuilder(
                    future: driverFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.separated(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int i) {
                            return CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              onChanged: (bool value) {
                                setModalState(() {
                                  snapshot.data[i].selected = value;
                                });
                                if (value == false) {
                                  temp.remove(snapshot.data[i].name);
                                } else {
                                  temp.add(snapshot.data[i].name);
                                  print(temp);
                                }
                              },
                              value: snapshot.data[i].selected,
                              title: Text(snapshot.data[i].name),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(thickness: 1);
                          },
                        );
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                  CustomDenseButton(
                      onTap: () {
                        if (temp.isNotEmpty) {
                          setState(() {
                            techController.text = '${temp.length} teknisi ditugaskan';
                          });
                        } else {
                          setState(() {
                            techController.clear();
                          });
                        }
                        Navigator.pop(context);
                        print(temp.toSet().toList());
                      },
                      color: Colors.blue,
                      title: 'Simpan'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String warehouseSearch = '';
  Future warehouseBottomSheet() {
    return showMaterialModalBottomSheet(
      enableDrag: false,
      expand: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setModalState) {
            return SafeArea(
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(Icons.clear),
                              onPressed: () => Navigator.pop(context)),
                          Text('Gudang', style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: CustomTextFieldSmall(
                        hintText: 'Cari gudang',
                        prefixIcon: Icon(Icons.search),
                        onchange: (value) {
                          setModalState(() {
                            warehouseSearch = value;
                          });
                        },
                      ),
                    ),
                    FutureBuilder(
                      future: warehouseFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.only(right: 20, left: 20),
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                Warehouse warehouse = snapshot.data[index];
                                if (warehouse.warehouseName.toLowerCase().contains(warehouseSearch)) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        onTap: () {
                                          warehouseController.text = snapshot.data[index].warehouseName;
                                          Navigator.pop(context);
                                        },
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(snapshot.data[index].warehouseName,
                                            style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
                                        subtitle: Text(snapshot.data[index].warehouseCode),
                                      ),
                                      Divider(thickness: 1),
                                    ],
                                  );
                                } else {
                                  return SizedBox();
                                }
                              },
                            ),
                          );
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future driverBottomSheet() {
    return showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      expand: true,
      enableDrag: false,
      isDismissible: false,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height * .60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      IconButton(
                          padding: EdgeInsets.zero, icon: Icon(Icons.clear), onPressed: () => Navigator.pop(context)),
                      Text('Sopir', style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                FutureBuilder(
                  future: driverFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.only(right: 20, left: 20),
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                                onTap: () {
                                  driverId = snapshot.data[index].id;
                                  driverController.text = snapshot.data[index].name;
                                  Navigator.pop(context);
                                },
                                contentPadding: EdgeInsets.zero,
                                title: Text(snapshot.data[index].name, style: GoogleFonts.openSans())
                                // subtitle: Text(snapshot.data[index].warehouseCode),
                                );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(thickness: 1);
                          },
                        ),
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future transportBottomSheet() {
    return showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      expand: true,
      enableDrag: false,
      isDismissible: false,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height * .60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      IconButton(
                          padding: EdgeInsets.zero, icon: Icon(Icons.clear), onPressed: () => Navigator.pop(context)),
                      Text('Transport', style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                FutureBuilder(
                  future: transportFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.only(right: 20, left: 20),
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                                onTap: () {
                                  transportId = snapshot.data[index].id;
                                  vehicleController.text = snapshot.data[index].name;
                                  Navigator.pop(context);
                                },
                                contentPadding: EdgeInsets.zero,
                                title: Text(snapshot.data[index].name,
                                    style: GoogleFonts.openSans(fontWeight: FontWeight.bold))
                                // subtitle: Text(snapshot.data[index].warehouseCode),
                                );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(thickness: 1);
                          },
                        ),
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
