import 'dart:async';
import 'dart:io';

import 'package:atana/component/CustomDenseButton.dart';
import 'package:atana/model/form_model.dart';
import 'package:atana/service/api.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:expandable/expandable.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as Route;
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Warehouse extends StatefulWidget {
  @override
  _WarehouseState createState() => _WarehouseState();
}

class _WarehouseState extends State<Warehouse> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onRefresh();
  }

  // Future getDate() async {
  //   form.toList().forEach((element) {
  //     if (element.returnDate.day < DateTime.now().day &&
  //         DateTime.now().hour == 11 &&
  //         DateTime.now().minute == 24 &&
  //         DateTime.now().second < 7) {
  //       Notif.roleNotification("Admin", 'Barang ${element.item.atanaName} memasuki deadline');
  //     }
  //   });
  // }

  Future formFuture;
  Future formTripFuture;
  Future<File> file;
  Future<File> file2;

  Future onRefresh() async {
    formFuture = API.getFormStatus(5);
    formTripFuture = API.getFormStatus(6);
    setState(() {});
  }

  SharedPreferences sharedPreferences;
  Future setItemInfo(formId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('formId', formId);
    Route.Get.to(ImageUpload());
  }

  Future setItemInfoCode(formId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('formId', formId);
    Route.Get.to(CodeImageUpload());
  }

  Future setItemInfoReturn(formId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('formId', formId);
    Route.Get.to(ReturnImageUpload());
  }

  Future updateFormStatus(int id, int status) async {
    final String url = baseDemoUrl + "form/update/status";
    try {
      final response = await Dio().post(url, queryParameters: {
        "id": id,
        "status": status,
      });
      if (response.statusCode == 200) {
        onRefresh();
        print(response.data);
      }
    } on DioError catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Gagal'),
        backgroundColor: Colors.red,
      ));
      print(e.response.data);
    }
  }

  Map<int, File> files = {0: null, 1: null, 2: null, 3: null};

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Peminjaman Barang'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Permintaan Baru'),
              Tab(text: 'Dalam Perjalanan'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .25,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(15),
                    ),
                  ),
                ),
                SafeArea(
                  child: FutureBuilder(
                    future: formFuture,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.isEmpty) {
                          return Scaffold(
                            body: Center(
                              child: Text('Tidak ada permintaan penugasan baru'),
                            ),
                          );
                        }
                        return RefreshIndicator(
                          onRefresh: onRefresh,
                          child: ListView.builder(
                            padding: EdgeInsets.all(10),
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (_, index) {
                              FormResult form = snapshot.data[index];
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
                                        Text(
                                            form.warehouse.toLowerCase().contains('gudang')
                                                ? form.warehouse
                                                : "Gudang ${form.warehouse}",
                                            style: GoogleFonts.openSans()),
                                        SizedBox(height: 10),
                                        Divider(thickness: 1),
                                        ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(
                                            form.item,
                                            style: GoogleFonts.openSans(fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Row(
                                            children: [
                                              Text(form.city.name, style: GoogleFonts.openSans()),
                                              Text(form.district == null ? '' : ', ${form.district.name}',
                                                  style: GoogleFonts.openSans(fontSize: 16)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    expanded: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 20),
                                        Text('TANGGAL PENGAMBILAN BARANG',
                                            style:
                                                GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.grey)),
                                        Text(DateFormat('d MMMM y').format(form.departureDate),
                                            style: GoogleFonts.openSans(fontSize: 16)),
                                        SizedBox(height: 10),
                                        Text('TANGGAL KEMBALI BARANG',
                                            style:
                                                GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.grey)),
                                        Text(DateFormat('d MMMM y').format(form.returnDate),
                                            style: GoogleFonts.openSans(fontSize: 16)),
                                        SizedBox(height: 10),
                                        Text('FOTO TEKNISI DAN BARANG',
                                            style:
                                                GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.grey)),
                                        SizedBox(height: 10),
                                        DottedBorder(
                                            borderType: BorderType.RRect,
                                            color: Colors.grey,
                                            dashPattern: [8, 8],
                                            radius: Radius.circular(10),
                                            child: form.image == null
                                                ? showImage(form)
                                                : Image.network(
                                                    "https://demo.app.indofarm.id/public/storage/${form.image}",
                                                    fit: BoxFit.cover)),
                                        SizedBox(height: 20),
                                        Text('FOTO KODE BARANG',
                                            style:
                                                GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.grey)),
                                        SizedBox(height: 10),
                                        DottedBorder(
                                            borderType: BorderType.RRect,
                                            color: Colors.grey,
                                            dashPattern: [8, 8],
                                            radius: Radius.circular(10),
                                            child: form.codeImage == null
                                                ? showCodeImage(form)
                                                : Image.network(
                                                    "https://demo.app.indofarm.id/public/storage/${form.codeImage}",
                                                    fit: BoxFit.cover)),
                                        SizedBox(height: 10),
                                        Text(form.codeImage == null ? '*Masukkan foto kode barang yang diambil' : ""),
                                        SizedBox(height: 20),

                                        /// just in case
                                        CustomDenseButton(
                                          onTap: () {
                                            if (form.image != null) {
                                              updateFormStatus(form.id, 6);
                                            }
                                          },
                                          title: 'Konfirmasi',
                                          color: Colors.blue,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
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
                ),
              ],
            ),
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .25,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(15),
                    ),
                  ),
                ),
                SafeArea(
                  child: FutureBuilder(
                    future: formTripFuture,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.isEmpty) {
                          return Scaffold(
                            body: Center(
                              child: Text('Tidak ada permintaan penugasan baru'),
                            ),
                          );
                        }
                        return RefreshIndicator(
                          onRefresh: onRefresh,
                          child: ListView.builder(
                            padding: EdgeInsets.all(10),
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (_, index) {
                              FormResult form = snapshot.data[index];
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
                                        Text(
                                            form.warehouse.toLowerCase().contains('gudang')
                                                ? form.warehouse
                                                : "Gudang ${form.warehouse}",
                                            style: GoogleFonts.openSans()),
                                        SizedBox(height: 10),
                                        Divider(thickness: 1),
                                        ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(
                                            form.item,
                                            style: GoogleFonts.openSans(fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Row(
                                            children: [
                                              Text(form.city.name, style: GoogleFonts.openSans()),
                                              Text(form.district == null ? '' : ', ${form.district.name}',
                                                  style: GoogleFonts.openSans(fontSize: 16)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    expanded: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 20),
                                        Text('TANGGAL PENGAMBILAN BARANG',
                                            style:
                                                GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.grey)),
                                        Text(DateFormat('d MMMM y').format(form.departureDate),
                                            style: GoogleFonts.openSans(fontSize: 16)),
                                        SizedBox(height: 10),
                                        Text('BARANG HARUS KEMBALI PADA TANGGAL',
                                            style:
                                                GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.grey)),
                                        Text(DateFormat('d MMMM y').format(form.returnDate),
                                            style: GoogleFonts.openSans(fontSize: 16)),
                                        SizedBox(height: 10),
                                        Text('FOTO TEKNISI DAN BARANG',
                                            style:
                                                GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.grey)),
                                        SizedBox(height: 10),
                                        DottedBorder(
                                            borderType: BorderType.RRect,
                                            color: Colors.grey,
                                            dashPattern: [8, 8],
                                            radius: Radius.circular(10),
                                            child: form.returnImage == null
                                                ? showReturnImage(form)
                                                : Image.network(
                                                    "https://demo.app.indofarm.id/public/storage/${form.returnImage}",
                                                    fit: BoxFit.cover)),
                                        SizedBox(height: 10),
                                        Text(form.returnImage == null
                                            ? '*Masukkan foto barang yang telah kembali ke gudang'
                                            : ""),
                                        SizedBox(height: 20),

                                        /// just in case
                                        CustomDenseButton(
                                          onTap: () {
                                            if (form.returnImage != null) {
                                              updateFormStatus(form.id, 7);
                                            }
                                          },
                                          title: 'Selesai',
                                          color: Colors.blue,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget showImage(FormResult form) {
    return Container(
      child: InkWell(
        onTap: () => setItemInfo(form.id),
        child: Container(
          width: MediaQuery.of(context).size.width * .80,
          height: MediaQuery.of(context).size.width * .80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image),
              Text('Pilih foto'),
            ],
          ),
        ),
      ),
    );
  }

  Widget showCodeImage(FormResult form) {
    return Container(
      child: InkWell(
        onTap: () => setItemInfoCode(form.id),
        child: Container(
          width: MediaQuery.of(context).size.width * .80,
          height: MediaQuery.of(context).size.width * .80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image),
              Text('Pilih foto'),
            ],
          ),
        ),
      ),
    );
  }

  Widget showReturnImage(FormResult form) {
    return Container(
      child: InkWell(
        onTap: () => setItemInfoReturn(form.id),
        child: Container(
          width: MediaQuery.of(context).size.width * .80,
          height: MediaQuery.of(context).size.width * .80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image),
              Text('Pilih foto'),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageUpload extends StatefulWidget {
  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFormId();
  }

  SharedPreferences sharedPreferences;
  Future getFormId() async {
    sharedPreferences = await SharedPreferences.getInstance();
    int getFormId = sharedPreferences.getInt('formId');
    if (getFormId != null) {
      setState(() {
        formId = getFormId;
      });
    }
  }

  int formId;

  File file;
  final picker = ImagePicker();
  File thumbnail;

  Future _choose() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 50,
      preferredCameraDevice: CameraDevice.rear,
    );
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
// file = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future uploadImage(File file, id) async {
    try {
      final String url = baseDemoUrl + "image/upload";
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "img": await MultipartFile.fromFile(file.path, filename: fileName),
      });
      final response = await Dio().post(url, data: formData, onSendProgress: (int sent, int total) {
        setState(() {
          getSent = sent;
          getTotal = total;
        });
      });
      if (response.statusCode == 200) {
        print(response.data);
        updateImage(id, response.data['result']);
      }
    } on DioError catch (e) {
      print(e.response.data);
    }
  }

  Future updateImage(id, image) async {
    final response = await Dio().post(
      baseDemoUrl + "form/update/image",
      queryParameters: {
        'id': id,
        'image': image,
      },
    );
    if (response.statusCode == 200) {
      Flushbar(
        title: "Success",
        message: "Gambar berhasil di upload",
        duration: Duration(seconds: 2),
      )..show(context).then((value) => Navigator.pop(context));
    }
  }

  int getSent;
  int getTotal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Gambar"),
      ),
      floatingActionButton: getTotal == null
          ? SizedBox()
          : Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.upload_rounded,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "$getSent/$getTotal KB",
                      style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      body: formId == null
          ? CircularProgressIndicator()
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DottedBorder(
                        borderType: BorderType.RRect,
                        color: Colors.grey,
                        dashPattern: [8, 8],
                        radius: Radius.circular(10),
                        child: file == null
                            ? InkWell(
                                onTap: () {
                                  _choose();
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width * .80,
                                  height: MediaQuery.of(context).size.width * .80,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.image),
                                      Text('Pilih foto'),
                                    ],
                                  ),
                                ),
                              )
                            : Image.file(file)),
                    SizedBox(height: 20),
                    CustomDenseButton(
                      title: "Upload",
                      color: Colors.blue,
                      onTap: () {
                        if (file == null) {
                          Flushbar(
                            backgroundColor: Colors.red,
                            title: "Peringatan",
                            message: "Masukkan foto barang dan teknisi",
                            duration: Duration(seconds: 2),
                          )..show(context);
                        }
                        uploadImage(file, formId);
                      },
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

class CodeImageUpload extends StatefulWidget {
  @override
  _CodeImageUploadState createState() => _CodeImageUploadState();
}

class _CodeImageUploadState extends State<CodeImageUpload> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFormId();
  }

  SharedPreferences sharedPreferences;
  Future getFormId() async {
    sharedPreferences = await SharedPreferences.getInstance();
    int getFormId = sharedPreferences.getInt('formId');
    if (getFormId != null) {
      setState(() {
        formId = getFormId;
      });
    }
  }

  int formId;

  File file;
  final picker = ImagePicker();
  File thumbnail;

  Future _choose() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 50,
      preferredCameraDevice: CameraDevice.rear,
    );
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
// file = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future uploadImage(File file, id) async {
    try {
      final String url = baseDemoUrl + "image/upload";
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "img": await MultipartFile.fromFile(file.path, filename: fileName),
      });
      final response = await Dio().post(url, data: formData, onSendProgress: (int sent, int total) {
        setState(() {
          getSent = sent;
          getTotal = total;
        });
      });
      if (response.statusCode == 200) {
        print(response.data);
        updateImage(id, response.data['result']);
      }
    } on DioError catch (e) {
      print(e.response.data);
    }
  }

  Future updateImage(id, image) async {
    final response = await Dio().post(
      baseDemoUrl + "form/update/codeImage",
      queryParameters: {
        'id': id,
        'code_image': image,
      },
    );
    if (response.statusCode == 200) {
      Flushbar(
        title: "Success",
        message: "Gambar berhasil di upload",
        duration: Duration(seconds: 2),
      )..show(context).then((value) => Navigator.pop(context));
    }
  }

  int getSent;
  int getTotal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Gambar"),
      ),
      floatingActionButton: getTotal == null
          ? SizedBox()
          : Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.upload_rounded,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "$getSent/$getTotal KB",
                      style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      body: formId == null
          ? CircularProgressIndicator()
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DottedBorder(
                        borderType: BorderType.RRect,
                        color: Colors.grey,
                        dashPattern: [8, 8],
                        radius: Radius.circular(10),
                        child: file == null
                            ? InkWell(
                                onTap: () {
                                  _choose();
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width * .80,
                                  height: MediaQuery.of(context).size.width * .80,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.image),
                                      Text('Pilih foto'),
                                    ],
                                  ),
                                ),
                              )
                            : Image.file(file)),
                    SizedBox(height: 20),
                    CustomDenseButton(
                      title: "Upload",
                      color: Colors.blue,
                      onTap: () {
                        if (file == null) {
                          Flushbar(
                            backgroundColor: Colors.red,
                            title: "Peringatan",
                            message: "Masukkan foto barang dan teknisi",
                            duration: Duration(seconds: 2),
                          )..show(context);
                        }
                        uploadImage(file, formId);
                      },
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

class ReturnImageUpload extends StatefulWidget {
  @override
  _ReturnImageUploadState createState() => _ReturnImageUploadState();
}

class _ReturnImageUploadState extends State<ReturnImageUpload> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFormId();
  }

  SharedPreferences sharedPreferences;
  Future getFormId() async {
    sharedPreferences = await SharedPreferences.getInstance();
    int getFormId = sharedPreferences.getInt('formId');
    if (getFormId != null) {
      setState(() {
        formId = getFormId;
      });
    }
  }

  int formId;

  File file;
  final picker = ImagePicker();
  File thumbnail;

  Future _choose() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 50,
      preferredCameraDevice: CameraDevice.rear,
    );
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
// file = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future uploadImage(File file, id) async {
    try {
      final String url = baseDemoUrl + "image/upload";
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "img": await MultipartFile.fromFile(file.path, filename: fileName),
      });
      final response = await Dio().post(url, data: formData, onSendProgress: (int sent, int total) {
        setState(() {
          getSent = sent;
          getTotal = total;
        });
      });
      if (response.statusCode == 200) {
        print(response.data);
        updateImage(id, response.data['result']);
      }
    } on DioError catch (e) {
      print(e.response.data);
    }
  }

  Future updateImage(id, image) async {
    final response = await Dio().post(
      baseDemoUrl + "form/update/returnImage",
      queryParameters: {
        'id': id,
        'return_image': image,
      },
    );
    if (response.statusCode == 200) {
      Flushbar(
        title: "Success",
        message: "Gambar berhasil di upload",
        duration: Duration(seconds: 2),
      )..show(context).then((value) => Navigator.pop(context));
    }
  }

  int getSent;
  int getTotal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Gambar"),
      ),
      floatingActionButton: getTotal == null
          ? SizedBox()
          : Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.upload_rounded,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "$getSent/$getTotal KB",
                      style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      body: formId == null
          ? CircularProgressIndicator()
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DottedBorder(
                        borderType: BorderType.RRect,
                        color: Colors.grey,
                        dashPattern: [8, 8],
                        radius: Radius.circular(10),
                        child: file == null
                            ? InkWell(
                                onTap: () {
                                  _choose();
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width * .80,
                                  height: MediaQuery.of(context).size.width * .80,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.image),
                                      Text('Pilih foto'),
                                    ],
                                  ),
                                ),
                              )
                            : Image.file(file)),
                    SizedBox(height: 20),
                    CustomDenseButton(
                      title: "Upload",
                      color: Colors.blue,
                      onTap: () {
                        if (file == null) {
                          Flushbar(
                            backgroundColor: Colors.red,
                            title: "Peringatan",
                            message: "Masukkan foto barang dan teknisi",
                            duration: Duration(seconds: 2),
                          )..show(context);
                        }
                        uploadImage(file, formId);
                      },
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

// onTap: () async {
// files[index] = await ImagePicker.pickImage(source: ImageSource.camera);
// setState(() {});
// },
