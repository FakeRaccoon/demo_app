import 'dart:async';
import 'dart:io';

import 'package:atana/component/CustomOutlineButton.dart';
import 'package:atana/model/form_model.dart';
import 'package:atana/service/api.dart';
import 'package:atana/service/notification.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

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

  Future onRefresh() async {
    formFuture = API.getFormStatus(5);
    setState(() {});
  }

  Map<int, File> files = {0: null, 1: null, 2: null, 3: null};

  @override
  Widget build(BuildContext context) {
    var mediaQ = MediaQuery.of(context).size;
    return Scaffold(
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
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.blue,
            height: MediaQuery.of(context).size.height * .25,
          ),
          SafeArea(
            child: FutureBuilder(
              future: formFuture,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.isEmpty) {
                    return Center(
                      child: Text('No data'),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: onRefresh,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, index) {
                        FormResult form = snapshot.data[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: ExpandablePanel(
                                theme: ExpandableThemeData(headerAlignment: ExpandablePanelHeaderAlignment.center),
                                header: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    form.item.atanaName,
                                    style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 18),
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
                                ),
                                expanded: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 20),
                                    Text('FOTO TEKNISI DAN BARANG',
                                        style: GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.grey)),
                                    SizedBox(height: 10),
                                    DottedBorder(
                                      borderType: BorderType.RRect,
                                      color: Colors.grey,
                                      dashPattern: [8, 8],
                                      radius: Radius.circular(10),
                                      child: Container(
                                        width: mediaQ.width,
                                        child: InkWell(
                                          onTap: () async {
                                            files[index] = await ImagePicker.pickImage(source: ImageSource.camera);
                                            setState(() {});
                                          },
                                          child: Container(
                                              width: MediaQuery.of(context).size.width * .80,
                                              height: MediaQuery.of(context).size.width * .80,
                                              child: form.image != null
                                                  ? Container(
                                                      child: files[index] == null && form.image == null
                                                          ? Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [Icon(Icons.image), Text('Pilih foto')],
                                                            )
                                                          : Image.network(form.image, fit: BoxFit.cover),
                                                    )
                                                  : Container(
                                                      child: files[index] == null
                                                          ? Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [Icon(Icons.image), Text('Pilih foto')],
                                                            )
                                                          : Image.file(
                                                              files[index],
                                                              fit: BoxFit.cover,
                                                            ))),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    CustomOutlineButton(
                                      ontap: () {},
                                      title: 'Upload',
                                      color: Colors.blue,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
