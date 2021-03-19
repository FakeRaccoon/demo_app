import 'dart:io';

import 'package:atana/body.dart';
import 'package:atana/component/CustomDenseButton.dart';
import 'package:atana/model/transport_detail.dart';
import 'package:atana/model/transport_model.dart';
import 'package:atana/service/api.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as Get;
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VehicleInput extends StatefulWidget {
  @override
  _VehicleInputState createState() => _VehicleInputState();
}

class _VehicleInputState extends State<VehicleInput> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onRefresh();
  }

  Future onRefresh() async {
    vehicleFuture = API.getTransport();
    setState(() {});
  }

  SharedPreferences sharedPreferences;

  Future updateTransport(int id, String platNo, kilometer, idle, image) async {
    final String url = baseDemoUrl + "transport/update";
    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    try {
      final response = await Dio().post(url,
          options: Options(headers: {
            'Authorization': "Bearer $token",
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }),
          queryParameters: {
            "id": id,
            "plat_no": platNo,
            "kilometer": kilometer,
            "idle": idle,
            "image": image,
          });
      if (response.statusCode == 200) {
        onRefresh().then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Berhasil'))));
      }
    } on DioError catch (e) {
      print(e.response.data);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data gagal diproses!")));
    }
  }

  Future createTransport(name, platNo) async {
    final String url = baseDemoUrl + "transport/create";
    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    try {
      final response = await Dio().post(url,
          options: Options(headers: {
            'Authorization': "Bearer $token",
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }),
          queryParameters: {
            "name": name,
            "plat_no": platNo,
            "idle": 0,
          });
      if (response.statusCode == 200) {
        onRefresh();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Berhasil')));
      }
    } on DioError catch (e) {
      print(e.response.data);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }

  File image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future vehicleFuture;

  TextEditingController vehicleController = TextEditingController();
  TextEditingController platController = TextEditingController();
  TextEditingController kilometerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          vehicleController.clear();
          platController.clear();
          createVehicleBottomSheet(context);
        },
      ),
      appBar: AppBar(
        title: Text('Transport Management'),
      ),
      body: FutureBuilder(
        future: vehicleFuture,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: onRefresh,
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(10),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Transport transport = snapshot.data[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(transport.name),
                          SizedBox(height: 10),
                          Divider(thickness: 1),
                          ListTile(
                            onTap: () {
                              vehicleController.text = transport.name;
                              transport.plat != null ? platController.text = transport.plat : platController.clear();
                              transport.kilometer != null
                                  ? kilometerController.text = transport.kilometer.toString()
                                  : kilometerController.clear();
                              Get.Get.to(() => TransportEdit(), arguments: transport);
                            },
                            contentPadding: EdgeInsets.zero,
                            title: Text(transport.name),
                            subtitle: Text(transport.plat ?? ''),
                            trailing: CupertinoSwitch(
                              activeColor: Colors.blue,
                              onChanged: (bool value) {
                                if (value == false) {
                                  updateTransport(
                                    transport.id,
                                    transport.plat,
                                    transport.kilometer,
                                    0,
                                    transport.image,
                                  );
                                  setState(() {
                                    transport.idle = false;
                                  });
                                  print('false');
                                } else {
                                  updateTransport(
                                    transport.id,
                                    transport.plat,
                                    transport.kilometer,
                                    1,
                                    transport.image,
                                  );
                                  setState(() {
                                    transport.idle = true;
                                  });
                                }
                              },
                              value: transport.idle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future createVehicleBottomSheet(BuildContext context) {
    return showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tambah Kendaraan', style: GoogleFonts.sourceSansPro(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 30),
                  Text('Kendaraan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  TextFormField(controller: vehicleController, decoration: InputDecoration(hintText: 'Nama kendaraan')),
                  SizedBox(height: 20),
                  Text('Plat Nomor', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  TextFormField(controller: platController, decoration: InputDecoration(hintText: 'Plat Nomor')),
                  SizedBox(height: 20),
                  CustomDenseButton(
                    title: 'Tambah',
                    color: Colors.blue,
                    onTap: () {
                      createTransport(vehicleController.text, platController.text);
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
}

class TransportEdit extends StatefulWidget {
  @override
  _TransportEditState createState() => _TransportEditState();
}

class _TransportEditState extends State<TransportEdit> {
  Transport transportId = Get.Get.arguments;

  SharedPreferences sharedPreferences;

  Future onRefresh() async {
    transportFuture = API.getTransportDetail(transportId.id);
    setState(() {});
  }

  Future updateTransport(int id, String name, String platNo, kilometer, idle, image) async {
    final String url = baseDemoUrl + "transport/update";
    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    try {
      final response = await Dio().post(url,
          options: Options(headers: {
            'Authorization': "Bearer $token",
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }),
          queryParameters: {
            "id": id,
            "plat_no": platNo,
            "kilometer": kilometer,
            "idle": idle,
            "image": image,
          });
      if (response.statusCode == 200) {
        Get.Get.back();
        onRefresh().then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Berhasil'))));
      }
    } on DioError catch (e) {
      print(e.response.data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Data gagal diproses!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    onRefresh();
  }

  TextEditingController platController = TextEditingController();
  TextEditingController kilometerController = TextEditingController();

  Future transportFuture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transport Edit'),
      ),
      body: FutureBuilder(
        future: transportFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                TransportDetail transport = snapshot.data[0];
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Nama'),
                        subtitle: Text(transport.name),
                        // trailing: TextButton(
                        //   onPressed: () {},
                        //   child: Text('Edit', style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
                        // ),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Plat Nomor'),
                        subtitle: Text(transport.plat ?? 'null'),
                        trailing: TextButton(
                          onPressed: () {
                            showMaterialModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                              ),
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
                                            'Edit',
                                            style: GoogleFonts.sourceSansPro(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          TextFormField(
                                            controller: platController,
                                            decoration: InputDecoration(hintText: 'Plat nomor'),
                                          ),
                                          SizedBox(height: 20),
                                          CustomDenseButton(
                                            title: "Confirm",
                                            onTap: () {
                                              var idleInt = transport.idle == false ? 0 : 1;
                                              updateTransport(
                                                transport.id,
                                                transport.name,
                                                platController.text,
                                                transport.kilometer,
                                                idleInt,
                                                transport.image,
                                              );
                                            },
                                            color: Colors.blue,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Text('Edit', style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Kilometer'),
                        subtitle: Text('${transport.kilometer ?? null} KM'),
                        trailing: TextButton(
                          onPressed: () {
                            showMaterialModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                              ),
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
                                            'Edit',
                                            style: GoogleFonts.sourceSansPro(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          TextFormField(
                                            controller: kilometerController,
                                            decoration: InputDecoration(hintText: 'Kilometer'),
                                          ),
                                          SizedBox(height: 20),
                                          CustomDenseButton(
                                            title: "Confirm",
                                            onTap: () {
                                              var idleInt = transport.idle == false ? 0 : 1;
                                              updateTransport(
                                                transport.id,
                                                transport.name,
                                                transport.plat,
                                                kilometerController.text,
                                                idleInt,
                                                transport.image,
                                              );
                                            },
                                            color: Colors.blue,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Text('Edit', style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Gambar'),
                        trailing: TextButton(
                          onPressed: () => Get.Get.to(() => EditTransportImage(), arguments: transport),
                          child: Text(
                            transport.image != null ? 'Edit' : 'Add',
                            style: GoogleFonts.openSans(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      if (transport.image != null)
                        Container(
                          width: Get.Get.width,
                          child: Image.network('https://demo.app.indofarm.id/public/storage/${transport.image}'),
                        )
                      else
                        SizedBox()
                    ],
                  ),
                );
              },
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

class EditTransportImage extends StatefulWidget {
  @override
  _EditTransportImageState createState() => _EditTransportImageState();
}

class _EditTransportImageState extends State<EditTransportImage> {
  TransportDetail transport = Get.Get.arguments;

  File file;
  final picker = ImagePicker();

  SharedPreferences sharedPreferences;

  Future updateTransport(int id, String name, String platNo, image, kilometer, int idle) async {
    final String url = baseDemoUrl + "transport/update";
    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    try {
      final response = await Dio().post(url,
          options: Options(headers: {
            'Authorization': "Bearer $token",
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }),
          queryParameters: {
            "id": id,
            "plat_no": platNo,
            "kilometer": kilometer,
            "image": image,
            "idle": idle,
          });
      if (response.statusCode == 200) {
        print(response.data);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Berhasil')));
      }
    } on DioError catch (e) {
      print(e.response.data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Data gagal diproses!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future deleteImageFromStorage(String name) async {
    final String url = baseDemoUrl + "image/delete";
    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    try {
      final response = await Dio().post(url,
          options: Options(headers: {
            'Authorization': "Bearer $token",
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }),
          queryParameters: {
            "img": name,
          });
      if (response.statusCode == 200) {
        print(response.data);
        print("image deleted from storage");
      }
    } on DioError catch (e) {
      print(e.response.data);
    }
  }

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

  Future _chooseGallery() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
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

  Future uploadImage(File file) async {
    final String url = baseDemoUrl + "image/upload/transport";
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "img": await MultipartFile.fromFile(file.path, filename: fileName),
    });
    final response = await Dio().post(url, data: formData, onSendProgress: (int sent, int total) {
      setState(() {
        // getSent = sent;
        // getTotal = total;
        print(total);
      });
    });
    if (response.statusCode == 200) {
      deleteImageFromStorage(transport.image);
      Get.Get.off(() => Body());
      var idleCheck = transport.idle == true ? 1 : 0;
      print(response.data);
      updateTransport(
        transport.id,
        transport.name,
        transport.plat,
        response.data['result'],
        transport.kilometer,
        idleCheck,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transport Image'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              if (file != null)
                Image.file(file)
              else
                Container(
                  height: Get.Get.width / 4,
                  width: Get.Get.width,
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    color: Colors.grey,
                    dashPattern: [8, 8],
                    radius: Radius.circular(10),
                    child: InkWell(
                      onTap: _choose,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt),
                            Text('Open Camera'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              if (file == null)
                Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      height: Get.Get.width / 4,
                      width: Get.Get.width,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        color: Colors.grey,
                        dashPattern: [8, 8],
                        radius: Radius.circular(10),
                        child: InkWell(
                          onTap: _chooseGallery,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image),
                                Text('Pick From Gallery'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              else
                SizedBox(),
              SizedBox(height: 20),
              SizedBox(
                width: Get.Get.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: file == null ? Colors.grey : Colors.blue, elevation: 0),
                  onPressed: () => uploadImage(file),
                  child: Text('Upload'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
