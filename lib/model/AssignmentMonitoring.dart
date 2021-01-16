import 'package:atana/component/cusomTF.dart';
import 'package:atana/service/api.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../component/button.dart';
import '../component/customTFsmall.dart';
import 'form_model.dart';
import 'transport_model.dart';
import 'user_model_json.dart';

class MonitoringPenugasa extends StatefulWidget {
  @override
  _MonitoringPenugasaState createState() => _MonitoringPenugasaState();
}

class _MonitoringPenugasaState extends State<MonitoringPenugasa> {
  int getDocId;

  // navigateToDetail(String item, int docID) {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => DetailPagePenugasanDemo(
  //                 item: item,
  //                 docId: getDocId,
  //               )));
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    isSwitched = false;
    fetch();
  }

  List<TextEditingController> technicianController = new List();
  List<FormResult> form = List();
  List<UserResult> user = List();

  List temp = [];

  Future fetch() async {
    API.getFormStatus(2).then((value) => form = value).whenComplete(() {
      setState(() {});
    });
    API.getUser().then((value) => user = value).whenComplete(() {
      setState(() {});
    });
  }

  bool isLoading;
  bool isSwitched;

  SharedPreferences sharedPreferences;
  Future setItemInfo(formId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('formId', formId);
    Get.to(DemoAssignmentDetail());
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
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .25,
            color: Colors.blue,
          ),
          RefreshIndicator(
            onRefresh: fetch,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: form.length,
              itemBuilder: (BuildContext context, int index) {
                technicianController.add(new TextEditingController());
                return Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListTile(
                        onTap: () {
                          setItemInfo(form[index].id);
                          print(form[index].id);
                        },
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(DateFormat('d').format(form[index].estimatedDate).toString(),
                                style: GoogleFonts.sourceSansPro(fontSize: 20, fontWeight: FontWeight.bold)),
                            Text(DateFormat('MMM').format(form[index].estimatedDate).toString(),
                                style: GoogleFonts.sourceSansPro(fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        title: Text(
                          form[index].item.atanaName,
                          style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        subtitle: Row(
                          children: [
                            Text(form[index].city, style: GoogleFonts.openSans(fontSize: 16)),
                            Text(form[index]?.district == null ? '' : ', ${form[index].district}',
                                style: GoogleFonts.openSans(fontSize: 16)),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
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
}

class DemoAssignmentDetail extends StatefulWidget {
  @override
  _DemoAssignmentDetailState createState() => _DemoAssignmentDetailState();
}

class _DemoAssignmentDetailState extends State<DemoAssignmentDetail> with AutomaticKeepAliveClientMixin {
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
    isLoading = true;
    getFormDetail().whenComplete(() {
      getApi();
    });
  }

  SharedPreferences sharedPreferences;

  Future getFormDetail() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      docId = sharedPreferences.getInt('formId');
      item = sharedPreferences.getString('Item');
    });
    print(sharedPreferences.getInt('formId'));
  }

  List<UserResult> user = List();
  List<FormResult> form = List();

  List temp = [];

  Future getApi() async {
    API.getTransport().then((value) => vehicle = value).whenComplete(() {
      setState(() {});
    });
    API.getUser().then((value) {
      driver = value;
      user = value;
    }).whenComplete(() {
      setState(() {});
    });
    API.getFormId(sharedPreferences.getInt('formId')).then((value) => form = value).whenComplete(() {
      // form[0].technician.toList().forEach((element) => techDummy.add(element.name));
      setState(() {});
      if (form[0].technician.isNotEmpty) {
        setState(() {
          techController.text = '${form[0].technician.length} Teknisi ditugaskan';
        });
      }
    });
    // API.getTechnician(docId).then((value) => form = value).whenComplete(() {
    //   form => techDummy.add(element));
    //   if (form.length > 0) {
    //     techController.text = form.length.toString() + ' Teknisi ditugaskan';
    //   }
    // });
  }

  List techDummy = [];
  List techIndex = [];

  bool isReturnDateVisible = false;
  bool isSwitched = false;
  String transportResult;
  String feeResult;
  String driverResult;
  bool isLoading;
  int docId;
  String item;

  var vehicleController = TextEditingController();
  var driverController = TextEditingController();
  var feeController = TextEditingController();
  var feeDescController = TextEditingController();
  var techController = TextEditingController();
  var currency = NumberFormat.decimalPattern();

  // Future getToken() async {}
  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: user.isEmpty ? Center(child: CircularProgressIndicator()) : showUI(),
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
                  Text(
                    'Pilih teknisi',
                    style: GoogleFonts.openSans(fontWeight: FontWeight.bold),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: user.length,
                    itemBuilder: (BuildContext context, int i) {
                      return CheckboxListTile(
                        onChanged: (bool value) {
                          setModalState(() {
                            user[i].selected = value;
                          });
                          if (value == true) {
                            temp.add(user[i].name);
                          } else {
                            temp.remove(user[i].name);
                          }
                        },
                        value: user[i].selected,
                        title: Text(user[i].name),
                      );
                    },
                  ),
                  CustomButton(
                    ontap: () {
                      if (temp.isNotEmpty) {
                        print(temp.toSet().toList());
                        temp.toSet().toList().forEach((element) {
                          API.assignTechnician(element, sharedPreferences.getInt('formId'));
                        });
                      }
                    },
                    color: Colors.blue,
                    title: 'Simpan',
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget showUI() {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Card(
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
                  CustomTextField(
                    ontap: () {
                      techIndex.clear();
                      techDummy.clear();
                      user.toList().forEach((element) {
                        setState(() {
                          element.selected = false;
                        });
                      });
                      form[0].technician.toList().forEach((element) {
                        setState(() {
                          var idx = user.toList().indexWhere((val) => val.name == element.name);
                          user[idx].selected = true;
                          techDummy.add(user[idx].name);
                          print(techDummy);
                        });
                      });
                      showMaterialModalBottomSheet(
                          builder: (BuildContext context) {
                            return technicianBottom(context);
                          },
                          context: context);
                    },
                    readOnly: true,
                    hintText: 'Teknisi',
                    controller: techController,
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
                              ontap: () => showMaterialModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                expand: true,
                                enableDrag: false,
                                isDismissible: false,
                                builder: (BuildContext context) {
                                  return driverBottomSheet();
                                },
                              ),
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
                    // controller: provinceResultController,
                    ontap: () => showMaterialModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      expand: true,
                      enableDrag: false,
                      isDismissible: false,
                      builder: (BuildContext context) {
                        return transportBottomSheet();
                      },
                    ),
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
                  SizedBox(height: 20),
                  Text(
                    'Perkiraan Biaya',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Isi perkiraan biaya';
                      }
                    },
                    readOnly: false,
                    inputformat: [CurrencyTextInputFormatter(decimalDigits: 0)],
                    controller: feeController,
                    keyboardtype: TextInputType.number,
                    prefix: feeController.text.length > 0 ? Text('Rp ') : null,
                    hintText: 'Estimasi Biaya',
                    onchange: (value) {
                      setState(() {
                        feeResult = value;
                        var parsed = feeResult.replaceAll(",", "");
                        var f = int.tryParse(parsed);
                        print(f);
                      });
                    },
                  ),
                  Visibility(
                    visible: feeController.text.length > 0 ? true : false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'Deskripsi Biaya',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Isi deskripsi biaya';
                            }
                          },
                          controller: feeDescController,
                          readOnly: false,
                          hintText: 'Deskripsi biaya',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    color: Colors.blue,
                    title: 'Ajukan',
                    ontap: () {
                      print(docId);
                      if (formKey.currentState.validate()) {
                        var parsed = feeController.text.replaceAll(",", "");
                        var f = int.tryParse(parsed);
                        API
                            .updateForm(docId, 4, driverId, vehicleId, departDate, returnDate, f.toString(),
                                feeDescController.text)
                            .whenComplete(() {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Data berhasil diajukan'),
                          ));
                          print('success');
                          form.clear();
                          isSwitched = false;
                          driverController.clear();
                          vehicleController.clear();
                          departDateController.clear();
                          returnDateController.clear();
                          feeController.clear();
                          feeDescController.clear();
                        });
                        API.updateTechnician(docId, item, departDate, returnDate);
                        // Notif.multiRoleNotification('Admin', 'Direktur', "ada permintaan penugasan");
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  StatefulBuilder driverBottomSheet() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setModalState) {
        return SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height * .70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            Navigator.pop(context);
                            setModalState(() {
                              // filteredVehicle = employee;
                            });
                          }),
                      SizedBox(width: 10),
                      Text(
                        'Driver',
                        style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  CustomTextFieldSmall(
                    hintText: 'Cari Driver',
                    prefixIcon: Icon(Icons.search),
                    readOnly: false,
                    onchange: (String filter) {
                      // if (filter.isNotEmpty) {
                      //   setModalState(() {
                      //     print(filter);
                      //     vehicleLoading = true;
                      //     API.getTransport(filter).then((value) {
                      //       vehicle = value;
                      //       filteredVehicle = vehicle;
                      //     }).whenComplete(() {
                      //       setModalState(() {
                      //         vehicleLoading = false;
                      //       });
                      //     });
                      //   });
                      //   // filteredItem = item
                      //   //     .where((u) => (u.name.toLowerCase().contains(filter.toLowerCase())))
                      //   //     .toList();
                      // }
                      // if (filter.isEmpty) {
                      //   setModalState(() {
                      //     vehicleLoading = true;
                      //     API.getTransport().then((value) {
                      //       vehicle = value;
                      //       filteredVehicle = vehicle;
                      //     }).whenComplete(() {
                      //       setModalState(() {
                      //         vehicleLoading = false;
                      //       });
                      //     });
                      //   });
                      // }
                    },
                  ),
                  driver.length == 0
                      ? Center(child: Text('Item tidak ditemukan'))
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: driver.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                setState(() {
                                  driverController.text = driver[index].name;
                                  driverId = driver[index].id.toString();
                                  // if (filteredItem[index].name == "400 bad request") {
                                  //   itemResultController.clear();
                                  // }
                                  // if (filteredItem[index].name == "404 not found") {
                                  //   itemResultController.clear();
                                  // }
                                  print(driver[index].id);
                                });
                                Navigator.pop(context);
                                // setModalState(() {
                                //   filteredVehicle = vehicle;
                                // });
                              },
                              title: Text(driver[index].name),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider();
                          },
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<UserResult> driver = List();
  bool driverLoading;
  String driverId;
  // int filterCount;

  List<TransportResult> vehicle = List();
  bool vehicleLoading;
  String vehicleId;
  int filterCount;

  Widget transportBottomSheet() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setModalState) {
        return SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height * .70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            Navigator.pop(context);
                            setModalState(() {});
                          }),
                      SizedBox(width: 10),
                      Text(
                        'Kendaraan',
                        style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  CustomTextFieldSmall(
                    hintText: 'Cari kendaraan',
                    prefixIcon: Icon(Icons.search),
                    readOnly: false,
                    onchange: (String filter) {
                      // if (filter.isNotEmpty) {
                      //   setModalState(() {
                      //     print(filter);
                      //     vehicleLoading = true;
                      //     API.getTransport(filter).then((value) {
                      //       vehicle = value;
                      //       filteredVehicle = vehicle;
                      //     }).whenComplete(() {
                      //       setModalState(() {
                      //         vehicleLoading = false;
                      //       });
                      //     });
                      //   });
                      //   // filteredItem = item
                      //   //     .where((u) => (u.name.toLowerCase().contains(filter.toLowerCase())))
                      //   //     .toList();
                      // }
                      // if (filter.isEmpty) {
                      //   setModalState(() {
                      //     vehicleLoading = true;
                      //     API.getTransport().then((value) {
                      //       vehicle = value;
                      //       filteredVehicle = vehicle;
                      //     }).whenComplete(() {
                      //       setModalState(() {
                      //         vehicleLoading = false;
                      //       });
                      //     });
                      //   });
                      // }
                    },
                  ),
                  vehicle.length == 0
                      ? Center(child: Text('Item tidak ditemukan'))
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: vehicle.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                setState(() {
                                  vehicleController.text = vehicle[index].name;
                                  vehicleId = vehicle[index].id.toString();
                                  // if (filteredItem[index].name == "400 bad request") {
                                  //   itemResultController.clear();
                                  // }
                                  // if (filteredItem[index].name == "404 not found") {
                                  //   itemResultController.clear();
                                  // }
                                  print(vehicleId);
                                });
                                Navigator.pop(context);
                                // setModalState(() {
                                //   vehicle = vehicle;
                                // });
                              },
                              title: Text(vehicle[index].name),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider();
                          },
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
