import 'dart:io';

import 'package:atana/component/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class Warehouse extends StatefulWidget {
  @override
  _WarehouseState createState() => _WarehouseState();
}

class _WarehouseState extends State<Warehouse> {
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('no image');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Peminjaman Barang'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Items')
                  .where('editedByKepalaTeknisi', isEqualTo: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  print('Error');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (_, index) {
                      return InkWell(
                        // onTap: () {
                        //   navigateToDetail(snapshot.data.docs[index], getDocId);
                        //   setState(() {
                        //     getDocId = snapshot.data.docs[index].id;
                        //   });
                        // },
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Stack(
                              children: [
                                Positioned(
                                  child: Icon(Icons.arrow_forward),
                                  top: 1,
                                  right: 1,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                          snapshot.data.docs[index]
                                              ?.data()['barang'],
                                          style: GoogleFonts.openSans(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                      width: MediaQuery.of(context).size.width *
                                          .60,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                            snapshot.data.docs[index]
                                                .data()['city'],
                                            style: GoogleFonts.openSans(
                                                fontSize: 16)),
                                        Text(
                                            snapshot.data.docs[index]
                                                .data()['district'] ==
                                                null
                                                ? ''
                                                : ', ${snapshot.data.docs[index].data()['district']}',
                                            style: GoogleFonts.openSans(
                                                fontSize: 16)),
                                      ],
                                    ),
                                    // Text(
                                    //     snapshot.data.docs[index]
                                    //         .data()['transport'],
                                    //     style:
                                    //     GoogleFonts.openSans(fontSize: 16)),
                                    // Text(
                                    //     'Rp ' +
                                    //         snapshot.data.docs[index]
                                    //             .data()['estimasiBiaya'],
                                    //     style:
                                    //     GoogleFonts.openSans(fontSize: 16)),
                                    Row(
                                      children: [
                                        Text(
                                            snapshot.data.docs[index]
                                                ?.data()['tanggalBerangkat'],
                                            style: GoogleFonts.openSans(
                                                fontSize: 16)),
                                        Icon(Icons.arrow_forward),
                                        Text(
                                            snapshot.data.docs[index]
                                                ?.data()['tanggalKembali'],
                                            style: GoogleFonts.openSans(
                                                fontSize: 16)),
                                      ],
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                    ),
                                    SizedBox(height: 20),
                                    FlatButton(
                                      minWidth: MediaQuery.of(context).size.width,
                                      child: Text('Approve',
                                          style: GoogleFonts.openSans(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700)),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      color: Colors.blue,
                                      textColor: Colors.white,
                                      onPressed: () {
                                        print('approved');
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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
