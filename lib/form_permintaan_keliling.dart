import 'package:atana/component/button.dart';
import 'package:atana/component/customTFsmall.dart';
import 'package:atana/model/post_result.dart';
import 'package:atana/service/api.dart';
import 'package:atana/service/notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'component/cusomTF.dart';
import 'model/result.dart';

class PermintaanKeliling extends StatefulWidget {
  final String parsedItem;

  const PermintaanKeliling({Key key, this.parsedItem}) : super(key: key);

  @override
  _PermintaanKelilingState createState() => _PermintaanKelilingState();
}

final _formKey = GlobalKey<FormState>();

class _PermintaanKelilingState extends State<PermintaanKeliling> {
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

  // _tanggalPinjam() async {
  //   final DateTime _pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: tanggalPinjam,
  //     firstDate: DateTime(2015, 8),
  //     lastDate: DateTime(2100),
  //   );
  //   if (_pickedDate != null) {
  //     setState(() {
  //       tanggalPinjam = _pickedDate;
  //       estimatedDateController.text =
  //           DateFormat('d MMMM y').format(tanggalPinjam);
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    estimatedDate = DateTime.now();
    buttonPressed = true;
    provinceLoading = true;

    isLoading = true;

    demoTypeId = 1;
    print('Demo type Id $demoTypeId');

    // ReqResPost.reqResPost();

    API.getItems2('bromo').then((value) {
      item = value;
      filteredItem = item;
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });

    API.getProvinceResult().whenComplete(() {
      // setState(() {
      //   isLoading = false;
      // });
    }).then((itemFromApi) {
      setState(() {
        province = itemFromApi;
        filteredProvince = province;
      });
    });
  }

  bool isCityVisible = false;
  bool isDistrictVisible = false;

  String provinceResult;
  String cityResult;
  String districtResult;
  String itemResult;

  bool buttonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Permintaan keliling'),
      ),
      body: isLoading == true
          ? LinearProgressIndicator()
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Provinsi',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              CustomTextField(
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'Provinsi tidak boleh kosong';
                                  }
                                },
                                controller: provinceResultController,
                                ontap: () => showMaterialModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  expand: true,
                                  enableDrag: false,
                                  isDismissible: false,
                                  builder: (BuildContext context) {
                                    return provinceBottomSheet();
                                  },
                                ),
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
                                    Text(
                                      'Kota',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10),
                                    CustomTextField(
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return 'Kota tidak boleh kosong';
                                        }
                                      },
                                      controller: cityResultController,
                                      ontap: () => showMaterialModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        expand: true,
                                        enableDrag: false,
                                        builder: (BuildContext context) {
                                          return cityBottomSheet();
                                        },
                                      ),
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
                                        Text(
                                          'Kecamatan',
                                          style:
                                              TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '(Opsional)',
                                          style:
                                              TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    CustomTextField(
                                      controller: districtResultController,
                                      ontap: () => showMaterialModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        expand: true,
                                        enableDrag: false,
                                        builder: (BuildContext context) {
                                          return districtBottomSheet();
                                        },
                                      ),
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
                                      ontap: () => showMaterialModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        expand: true,
                                        enableDrag: false,
                                        builder: (BuildContext context) {
                                          return itemBottomSheet();
                                        },
                                      ),
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
                                          side: BorderSide(
                                              color: buttonPressed == true
                                                  ? Colors.blue
                                                  : Colors.grey),
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
                                      color:
                                          buttonPressed == true ? Colors.blue : Colors.transparent,
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
                                          side: BorderSide(
                                              color: buttonPressed == false
                                                  ? Colors.blue
                                                  : Colors.grey),
                                          borderRadius: BorderRadius.circular(10)),
                                      onPressed: () {
                                        setState(() {
                                          buttonPressed = false;
                                          demoType = 'Test Mesin';
                                          demoTypeId = 2;
                                          print(demoType + demoTypeId.toString());
                                        });
                                      },
                                      textColor:
                                          buttonPressed == false ? Colors.white : Colors.grey,
                                      color:
                                          buttonPressed == false ? Colors.blue : Colors.transparent,
                                      child: Text(
                                        'Test Mesin',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              CustomButton(
                                color: Colors.blue,
                                title: 'Ajukan',
                                ontap: () {
                                  Notif.sendAndGetNotification(
                                      'Ada permintaan demo baru nih', ['admin']);
                                  // if (_formKey.currentState.validate()) {
                                  //   PostResult.postApi(
                                  //     provinceId,
                                  //     cityId,
                                  //     districtId,
                                  //     itemId,
                                  //     estimatedDate,
                                  //     demoTypeId,
                                  //   ).whenComplete(() {
                                  //     Get.snackbar('Success', 'Data berhasil di ajukan',
                                  //         snackPosition: SnackPosition.BOTTOM,
                                  //         margin: EdgeInsets.all(20),
                                  //         backgroundColor: Colors.grey[900],
                                  //         colorText: Colors.white);
                                  //   }).then((value) {
                                  //     setState(() {
                                  //       provinceResultController.clear();
                                  //       cityResultController.clear();
                                  //       districtResultController.clear();
                                  //       estimatedDateController.clear();
                                  //       itemResultController.clear();
                                  //       itemResultController.clear();
                                  //       isCityVisible = false;
                                  //       isDistrictVisible = false;
                                  //     });
                                  //   });
                                  // }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // List<PostResult> postResult = List();

  List<ProvinceResult> province = List();
  List<ProvinceResult> filteredProvince = List();

  bool provinceLoading = true;
  int provinceId;

  Widget provinceBottomSheet() {
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
                              filteredProvince = province;
                            });
                          }),
                      SizedBox(width: 10),
                      Text(
                        'Provinsi',
                        style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  CustomTextFieldSmall(
                    hintText: 'Cari provinsi',
                    prefixIcon: Icon(Icons.search),
                    readOnly: false,
                    onchange: (filter) {
                      setModalState(() {
                        filteredProvince = province
                            .where((u) => (u.name.toLowerCase().contains(filter.toLowerCase())))
                            .toList();
                      });
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: isLoading
                          ? Center(child: CircularProgressIndicator())
                          : ListView.separated(
                              itemCount: filteredProvince.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {
                                    setState(() {
                                      provinceResultController.text = filteredProvince[index].name;
                                      provinceId = filteredProvince[index].id;
                                      cityResultController.clear();
                                      districtResultController.clear();
                                      print(provinceId);
                                    });
                                    setState(() {
                                      API.getCityResult(provinceId.toString()).whenComplete(() {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }).then((value) {
                                        setState(() {
                                          city = value;
                                          filteredCity = city;
                                          isCityVisible = true;
                                          isDistrictVisible = false;
                                        });
                                      });
                                    });
                                    Navigator.pop(context);
                                    setModalState(() {
                                      filteredProvince = province;
                                    });
                                  },
                                  title: Text(filteredProvince[index].name),
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                return Divider();
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<CityResult> city = List();
  List<CityResult> filteredCity = List();
  bool cityLoading = true;
  int cityId;

  Widget cityBottomSheet() {
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
                              filteredCity = city;
                            });
                          }),
                      SizedBox(width: 10),
                      Text(
                        'Kota',
                        style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  CustomTextFieldSmall(
                    hintText: 'Cari kota',
                    prefixIcon: Icon(Icons.search),
                    readOnly: false,
                    onchange: (filter) {
                      setModalState(() {
                        filteredCity = city
                            .where((u) => (u.name.toLowerCase().contains(filter.toLowerCase())))
                            .toList();
                      });
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: isLoading
                          ? Center(child: CircularProgressIndicator())
                          : ListView.separated(
                              itemCount: filteredCity.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {
                                    setState(() {
                                      cityResultController.text = filteredCity[index].name;
                                      cityId = filteredCity[index].id;
                                      districtResultController.clear();
                                      print(cityId);
                                    });
                                    setState(() {
                                      API.getDistrictResult(cityId.toString()).whenComplete(() {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }).then((value) {
                                        setState(() {
                                          district = value;
                                          filteredDistrict = district;
                                          isDistrictVisible = true;
                                        });
                                      });
                                    });
                                    Navigator.pop(context);
                                    setModalState(() {
                                      filteredCity = city;
                                    });
                                  },
                                  title: Text(filteredCity[index].name),
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                return Divider();
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<DistrictResult> district = List();
  List<DistrictResult> filteredDistrict = List();
  bool districtLoading = true;
  int districtId;

  Widget districtBottomSheet() {
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
                              filteredDistrict = district;
                            });
                          }),
                      SizedBox(width: 10),
                      Text(
                        'Kecamatan',
                        style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  CustomTextFieldSmall(
                    hintText: 'Cari kecamatan',
                    prefixIcon: Icon(Icons.search),
                    readOnly: false,
                    onchange: (filter) {
                      setModalState(() {
                        filteredDistrict = district
                            .where((u) => (u.name.toLowerCase().contains(filter.toLowerCase())))
                            .toList();
                      });
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: isLoading
                          ? Center(child: CircularProgressIndicator())
                          : ListView.separated(
                              itemCount: filteredDistrict.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {
                                    setState(() {
                                      districtResultController.text = filteredDistrict[index].name;
                                      districtId = filteredDistrict[index].id;
                                    });
                                    Navigator.pop(context);
                                    setModalState(() {
                                      filteredDistrict = district;
                                    });
                                  },
                                  title: Text(filteredDistrict[index].name),
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                return Divider();
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<ItemResult> item = List();
  List<ItemResult> filteredItem = List();
  bool itemLoading = true;
  String itemId;
  int filterCount;

  Widget itemBottomSheet() {
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
                              filteredItem = item;
                            });
                          }),
                      SizedBox(width: 10),
                      Text(
                        'Barang',
                        style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  CustomTextFieldSmall(
                    hintText: 'Cari barang',
                    prefixIcon: Icon(Icons.search),
                    readOnly: false,
                    onchange: (String filter) {
                      print(filter.length);
                      if (filter.length >= 2) {
                        setModalState(() {
                          API.getItems2(filter.toString().toLowerCase()).then((value) {
                            item = value;
                            filteredItem = item;
                          });
                        });
                        // filteredItem = item
                        //     .where((u) => (u.name.toLowerCase().contains(filter.toLowerCase())))
                        //     .toList();
                      }
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: filteredItem.length == 0
                          ? Center(child: Text('Item tidak ditemukan'))
                          : ListView.separated(
                              itemCount: filteredItem.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {
                                    setState(() {
                                      itemResultController.text = filteredItem[index].name;
                                      itemId = filteredItem[index].id.toString();
                                      if (filteredItem[index].name == "400 bad request") {
                                        itemResultController.clear();
                                      }
                                      if (filteredItem[index].name == "404 not found") {
                                        itemResultController.clear();
                                      }
                                      print(itemId);
                                    });
                                    Navigator.pop(context);
                                    setModalState(() {
                                      filteredItem = item;
                                    });
                                  },
                                  title: Text(filteredItem[index].name),
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                return Divider();
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget datePicker() {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * .40,
        color: Colors.white,
        child: Center(
          child: DatePickerWidget(
            minDateTime: DateTime.parse('2020-01-01'),
            maxDateTime: DateTime.parse('2025-01-01'),
            initialDateTime: DateTime.now(),
            dateFormat: 'MMMM-yyyy',
            pickerTheme: DateTimePickerTheme(pickerHeight: 200),
            onChange: (date, selectedIndex) {
              setState(() {
                estimatedDate = date;
                estimatedDateController.text = DateFormat('MMMM yyyy').format(estimatedDate);
              });
              print(estimatedDate);
            },
          ),
        ),
      ),
    );
  }
}
