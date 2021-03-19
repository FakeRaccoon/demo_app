import 'dart:async';

import 'package:atana/component/CustomDenseButton.dart';
import 'package:atana/component/customTFsmall.dart';
import 'package:atana/model/atana_item_model.dart';
import 'package:atana/model/city_model.dart';
import 'package:atana/model/district_model.dart';
import 'package:atana/service/api.dart';
import 'package:atana/service/notification.dart';
import 'package:dio/dio.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../component/cusomTF.dart';
import '../model/province_model.dart';

class DemoRequest extends StatefulWidget {
  final String itemName;

  const DemoRequest({Key key, this.itemName}) : super(key: key);

  @override
  _DemoRequestState createState() => _DemoRequestState();
}

final _formKey = GlobalKey<FormState>();

class _DemoRequestState extends State<DemoRequest> {
  DateTime estimatedDate;

  String searchResult;

  bool isLoading = false;

  String demoType;
  int demoTypeId;

  TextEditingController estimatedDateController = TextEditingController();
  TextEditingController provinceResultController = TextEditingController();
  TextEditingController cityResultController = TextEditingController();
  TextEditingController districtResultController = TextEditingController();
  TextEditingController itemResultController = TextEditingController();

  @override
  void initState() {
    super.initState();
    estimatedDate = DateTime.now();
    buttonPressed = true;
    demoTypeId = 1;
    onRefresh();
  }

  Future futureItem;
  Future futureProvince;
  Future futureCity;
  Future futureDistrict;

  Future onRefresh() async {
    futureItem = API.getItems('yanmar');
    futureProvince = API.getProvince();
    setState(() {});
  }

  SharedPreferences sharedPreferences;
  Future createForm(provinceId, cityId, districtId, itemId, itemMeasureId, item, type, date) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final salesId = sharedPreferences.getInt('userId');
    final token = sharedPreferences.getString('token');
    final String url = baseDemoUrl + "form/create";
    try {
      final response = await Dio().post(url,
          options: Options(
              followRedirects: false,
              validateStatus: (status) {
                return status < 500;
              },
              headers: {
                "Authorization": "Bearer $token",
              }),
          queryParameters: {
            "province_id": provinceId,
            "city_id": cityId,
            "district_id": districtId,
            "item": item,
            "item_id": itemId,
            "item_measure_id": itemMeasureId,
            "user_id": salesId,
            "status": 1,
            "type": type,
            "estimated_date": date
          });
      if (response.statusCode == 200) {
        print(response.data);
        NotificationAPI.roleNotification('Direktur', "Ada permintaan demo baru");
        NotificationAPI.roleNotification('Manager Marketing', "Ada permintaan demo baru");
        Flushbar(
          title: "Berhasil",
          message: "Berhasil mengajukan permintaan demo",
          duration: Duration(seconds: 3),
        )..show(context);
        setState(() {
          provinceResultController.clear();
          cityResultController.clear();
          districtResultController.clear();
          estimatedDateController.clear();
          itemResultController.clear();
          itemResultController.clear();
          isCityVisible = false;
          isDistrictVisible = false;
        });
      }
    } catch (e) {
      print(e);
      Flushbar(
        message: e,
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      )..show(context);
    }
  }

  bool isCityVisible = false;
  bool isDistrictVisible = false;

  bool buttonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .25,
            decoration: BoxDecoration(color: Colors.blue),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Permintaan Demo',
                        style: GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20)),
                    SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Provinsi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                              CustomTextField(
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'Provinsi tidak boleh kosong';
                                  }
                                },
                                controller: provinceResultController,
                                ontap: () {
                                  provinceSearch = '';
                                  cityResultController.clear();
                                  districtResultController.clear();
                                  isCityVisible = false;
                                  isDistrictVisible = false;
                                  provinceBottomSheet(context);
                                },
                                customHeight: 50,
                                readOnly: true,
                                hintText: 'Provinsi',
                              ),
                              Visibility(
                                visible: isCityVisible,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 20),
                                    Text('Kota', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    SizedBox(height: 10),
                                    CustomTextField(
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return 'Kota tidak boleh kosong';
                                        }
                                      },
                                      controller: cityResultController,
                                      ontap: () {
                                        citySearch = '';
                                        isDistrictVisible = false;
                                        districtResultController.clear();
                                        cityBottomSheet(context);
                                      },
                                      customHeight: 50,
                                      readOnly: true,
                                      hintText: 'Kota',
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: isDistrictVisible,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Text('Kecamatan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                        SizedBox(width: 5),
                                        Text('(Opsional)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    CustomTextField(
                                      controller: districtResultController,
                                      ontap: () {
                                        districtBottomSheet(context);
                                        districtSearch = '';
                                      },
                                      customHeight: 50,
                                      readOnly: true,
                                      hintText: 'Kecamatan',
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Visibility(
                                visible: true,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Barang',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10),
                                    CustomTextField(
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return 'Barang tidak boleh kosong';
                                        }
                                      },
                                      controller: itemResultController,
                                      ontap: () {
                                        futureItem = API.getItems('yamaha');
                                        showMaterialModalBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          expand: true,
                                          enableDrag: false,
                                          builder: (BuildContext context) {
                                            return itemBottomSheet();
                                          },
                                        );
                                      },
                                      customHeight: 50,
                                      readOnly: true,
                                      hintText: 'Barang',
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: itemResultController.text.isEmpty ? false : true,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 20),
                                    Text(
                                      'Perkiraan',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10),
                                    CustomTextField(
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return 'Tanggal tidak boleh kosong';
                                        }
                                      },
                                      readOnly: true,
                                      ontap: () => showMaterialModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return datePicker();
                                        },
                                      ),
                                      controller: estimatedDateController,
                                      hintText: 'Tanggal Perkiraan Demo',
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              // Jenis Demo
                              Text(
                                'Tipe demo',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Container(
                                    height: 45,
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(color: buttonPressed == true ? Colors.blue : Colors.grey),
                                          borderRadius: BorderRadius.circular(10)),
                                      onPressed: () {
                                        setState(() {
                                          buttonPressed = true;
                                          demoType = 'Display';
                                          demoTypeId = 1;
                                          print(demoType + demoTypeId.toString());
                                        });
                                      },
                                      textColor: buttonPressed == true ? Colors.white : Colors.grey,
                                      color: buttonPressed == true ? Colors.blue : Colors.transparent,
                                      child: Text(
                                        'Display',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    height: 45,
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(color: buttonPressed == false ? Colors.blue : Colors.grey),
                                          borderRadius: BorderRadius.circular(10)),
                                      onPressed: () {
                                        setState(() {
                                          buttonPressed = false;
                                          demoType = 'Test Mesin';
                                          demoTypeId = 2;
                                          print(demoType + demoTypeId.toString());
                                        });
                                      },
                                      textColor: buttonPressed == false ? Colors.white : Colors.grey,
                                      color: buttonPressed == false ? Colors.blue : Colors.transparent,
                                      child: Text(
                                        'Test Mesin',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              CustomDenseButton(
                                color: Colors.blue,
                                title: 'Ajukan',
                                onTap: () {
                                  if (_formKey.currentState.validate()) {
                                    createForm(
                                      provinceId,
                                      cityId,
                                      districtId,
                                      itemId,
                                      itemMeasureId,
                                      itemResultController.text,
                                      demoTypeId,
                                      estimatedDate.toString(),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String provinceSearch = '';
  String citySearch = '';
  String districtSearch = '';
  int provinceId;
  int cityId;
  int districtId;
  int itemId;
  int itemMeasureId;

  Future provinceBottomSheet(BuildContext context) {
    return showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      expand: true,
      enableDrag: false,
      isDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              color: Colors.white,
              child: Column(
                children: [
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          SizedBox(width: 10),
                          Text('Provinsi', style: GoogleFonts.sourceSansPro(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomTextFieldSmall(
                      hintText: 'Cari provinsi',
                      prefixIcon: Icon(Icons.search),
                      readOnly: false,
                      onchange: (filter) {
                        setModalState(() {
                          provinceSearch = filter;
                        });
                      },
                    ),
                  ),
                  FutureBuilder(
                    future: futureProvince,
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        return Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.all(20),
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              ProvinceResult province = snapshot.data[index];
                              if (province.name.toLowerCase().contains(provinceSearch)) {
                                return Column(
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        provinceId = province.id;
                                        provinceResultController.text = province.name;
                                        Navigator.pop(context);
                                        futureCity = API.getCity(provinceId).whenComplete(() {
                                          setState(() {
                                            isCityVisible = true;
                                          });
                                        });
                                      },
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                        province.name,
                                        style: GoogleFonts.openSans(),
                                      ),
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
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future cityBottomSheet(BuildContext context) {
    return showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      expand: true,
      enableDrag: false,
      isDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              color: Colors.white,
              child: Column(
                children: [
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          SizedBox(width: 10),
                          Text(
                            'Kota',
                            style: GoogleFonts.sourceSansPro(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomTextFieldSmall(
                      hintText: 'Cari kota',
                      prefixIcon: Icon(Icons.search),
                      readOnly: false,
                      onchange: (filter) {
                        setModalState(() {
                          citySearch = filter;
                        });
                      },
                    ),
                  ),
                  FutureBuilder(
                    future: futureCity,
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        return Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.all(20),
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              CityResult city = snapshot.data[index];
                              if (city.name.toLowerCase().contains(citySearch)) {
                                return Column(
                                  children: [
                                    ListTile(
                                        onTap: () {
                                          cityId = city.id;
                                          cityResultController.text = city.name;
                                          Navigator.pop(context);
                                          futureDistrict = API.getDistrict(cityId).whenComplete(() {
                                            setState(() {
                                              isDistrictVisible = true;
                                            });
                                          });
                                        },
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(city.name, style: GoogleFonts.openSans())),
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
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future districtBottomSheet(BuildContext context) {
    return showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      expand: true,
      enableDrag: false,
      isDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              color: Colors.white,
              child: Column(
                children: [
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          SizedBox(width: 10),
                          Text(
                            'Kecamatan',
                            style: GoogleFonts.sourceSansPro(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomTextFieldSmall(
                      hintText: 'Cari kecamatan',
                      prefixIcon: Icon(Icons.search),
                      readOnly: false,
                      onchange: (filter) {
                        setModalState(() {
                          districtSearch = filter;
                        });
                      },
                    ),
                  ),
                  FutureBuilder(
                    future: futureDistrict,
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        return Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.all(20),
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              DistrictResult district = snapshot.data[index];
                              if (district.name.toLowerCase().contains(districtSearch)) {
                                return Column(
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        districtId = district.id;
                                        districtResultController.text = district.name;
                                        Navigator.pop(context);
                                      },
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(district.name, style: GoogleFonts.openSans()),
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
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget itemBottomSheet() {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setModalState) {
        return Container(
          color: Colors.white,
          child: Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      SizedBox(width: 10),
                      Text('Barang', style: GoogleFonts.sourceSansPro(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: CustomTextFieldSmall(
                  hintText: 'Cari barang',
                  prefixIcon: Icon(Icons.search),
                  readOnly: false,
                  onchange: (String filter) {
                    if (filter.isNotEmpty) {
                      print(filter);
                      setModalState(() {
                        futureItem = API.getItems(filter);
                      });
                    }
                    if (filter.isEmpty) {
                      setModalState(() {
                        futureItem = API.getItems('yamaha');
                      });
                    }
                  },
                ),
              ),
              FutureBuilder(
                future: futureItem,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error);
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Expanded(child: Center(child: CircularProgressIndicator()));
                  }
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          AtanaItemResult item = snapshot.data[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            onTap: () {
                              itemResultController.text = item.itemName;
                              itemId = item.itemId.toInt();
                              itemMeasureId = item.unitMeasureId.toInt();
                              print(itemId);
                              print('unitMeasureId: $itemMeasureId');
                              Navigator.pop(context);
                            },
                            title: Text(item.itemName, style: GoogleFonts.openSans()),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(thickness: 1);
                        },
                      ),
                    );
                  }
                  return Expanded(child: Center(child: Text('Barang tidak ditemukan')));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget datePicker() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        color: Colors.white,
      ),
      height: MediaQuery.of(context).size.height * .40,
      child: DatePickerWidget(
        initialDateTime: DateTime.now(),
        minDateTime: DateTime.now(),
        maxDateTime: DateTime(2030),
        dateFormat: 'MMMM-yyyy',
        onChange: (DateTime value, _) {
          setState(() {
            estimatedDate = value;
            print(estimatedDate);
          });
        },
        onConfirm: (DateTime value, _) {
          setState(() {
            estimatedDateController.text = DateFormat('MMMM y').format(value);
          });
        },
      ),
    );
  }
}
