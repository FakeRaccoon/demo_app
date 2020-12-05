import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import 'component/button.dart';
import 'service/database.dart';

class MonitoringDemo extends StatefulWidget {
  @override
  _MonitoringDemoState createState() => _MonitoringDemoState();
}

class _MonitoringDemoState extends State<MonitoringDemo> {
  navigateToDetail(DocumentSnapshot post, String docID) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPage(
                  post: post,
                  docId: getDocId,
                )));
  }

  String getDocId;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Monitoring permintaan demo'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Approved'),
              Tab(text: 'Rejected'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Items')
                    .where('isApproved', isEqualTo: false)
                    .where('isRejected', isEqualTo: false)
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Pending ',
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              snapshot.data.docs.length.toString(),
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (_, index) {
                              return InkWell(
                                onTap: () {
                                  // navigateToDetail(
                                  //     snapshot.data.docs[index], getDocId);
                                  // setState(() {
                                  //   getDocId = snapshot.data.docs[index].id;
                                  // });
                                  //
                                  // Get.bottomSheet(
                                  //   ClipRRect(
                                  //     borderRadius: BorderRadius.only(
                                  //         topRight: Radius.circular(20),
                                  //         topLeft: Radius.circular(20)),
                                  //     child: Container(
                                  //       height:
                                  //           MediaQuery.of(context).size.height *
                                  //               .70,
                                  //       color: Colors.white,
                                  //       child: Padding(
                                  //         padding: const EdgeInsets.all(20),
                                  //         child: Column(
                                  //           crossAxisAlignment:
                                  //               CrossAxisAlignment.start,
                                  //           children: [
                                  //             Text(
                                  //                 snapshot.data.docs[index]
                                  //                     .data()['barang'],
                                  //                 style: GoogleFonts.openSans(
                                  //                     fontWeight:
                                  //                         FontWeight.bold,
                                  //                     fontSize: 20)),
                                  //             Text(
                                  //                 snapshot.data.docs[index]
                                  //                     .data()['sales_pengaju'],
                                  //                 style: GoogleFonts.openSans(
                                  //                     fontSize: 16)),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 10),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          child: Icon(Icons.arrow_forward),
                                          top: 0,
                                          right: 0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .80,
                                              child: Text(
                                                  snapshot.data.docs[index]
                                                      .data()['barang'],
                                                  style: GoogleFonts.openSans(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18)),
                                            ),
                                            Text(
                                                snapshot.data.docs[index]
                                                        .data()[
                                                    'tanggal_perkiraan'],
                                                style: GoogleFonts.openSans(
                                                    fontSize: 16)),
                                            Row(
                                              children: [
                                                Text(
                                                    snapshot.data.docs[index]
                                                        .data()['city'],
                                                    style: GoogleFonts.openSans(
                                                        fontSize: 16)),
                                                Text(
                                                    snapshot.data.docs[index]
                                                                    .data()[
                                                                'district'] ==
                                                            null
                                                        ? ''
                                                        : ', ${snapshot.data.docs[index].data()['district']}',
                                                    style: GoogleFonts.openSans(
                                                        fontSize: 16)),
                                              ],
                                            ),
                                            Text(
                                                snapshot.data.docs[index]
                                                    .data()['tipe_demo'],
                                                style: GoogleFonts.openSans(
                                                    fontSize: 16)),
                                            SizedBox(height: 20),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: FlatButton(
                                                    onPressed: () {},
                                                    color: Colors.blue,
                                                    child: Text(
                                                      'Approve',
                                                      style: GoogleFonts.openSans(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 14),
                                                    ),
                                                    height: 40,
                                                    minWidth: MediaQuery.of(context).size.width / 2,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                  ),
                                                ),
                                                SizedBox(width: 20),
                                                Expanded(
                                                  child: FlatButton(
                                                    onPressed: () {},
                                                    color: Colors.red,
                                                    child: Text(
                                                      'Reject',
                                                      style: GoogleFonts.openSans(
                                                          color: Colors.white,
                                                          fontWeight:
                                                          FontWeight.w700,
                                                          fontSize: 14),
                                                    ),
                                                    height: 40,
                                                    minWidth: MediaQuery.of(context).size.width / 2,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                  ),
                                                ),
                                              ],
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
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            //// Approved ////

            Center(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Items')
                    .where('isApproved', isEqualTo: true)
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Approved ',
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              snapshot.data.docs.length.toString(),
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (_, index) {
                              return InkWell(
                                onTap: () {
                                  // navigateToDetail(
                                  //     snapshot.data.docs[index], getDocId);
                                  // setState(() {
                                  //   getDocId = snapshot.data.docs[index].id;
                                  // });

                                  Get.bottomSheet(
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          topLeft: Radius.circular(20)),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .70,
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  snapshot.data.docs[index]
                                                      .data()['barang'],
                                                  style: GoogleFonts.openSans(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20)),
                                              Text(
                                                  snapshot.data.docs[index]
                                                      .data()['sales_pengaju'],
                                                  style: GoogleFonts.openSans(
                                                      fontSize: 16)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 5),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          child: Icon(Icons.arrow_forward),
                                          top: 0,
                                          right: 0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .80,
                                              child: Text(
                                                  snapshot.data.docs[index]
                                                      .data()['barang'],
                                                  style: GoogleFonts.openSans(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18)),
                                            ),
                                            Text(
                                                snapshot.data.docs[index]
                                                        .data()[
                                                    'tanggal_perkiraan'],
                                                style: GoogleFonts.openSans(
                                                    fontSize: 16)),
                                            Row(
                                              children: [
                                                Text(
                                                    snapshot.data.docs[index]
                                                        .data()['city'],
                                                    style: GoogleFonts.openSans(
                                                        fontSize: 16)),
                                                Text(
                                                    snapshot.data.docs[index]
                                                                    .data()[
                                                                'district'] ==
                                                            null
                                                        ? ''
                                                        : ', ${snapshot.data.docs[index].data()['district']}',
                                                    style: GoogleFonts.openSans(
                                                        fontSize: 16)),
                                              ],
                                            ),
                                            Text(
                                                snapshot.data.docs[index]
                                                    .data()['tipe_demo'],
                                                style: GoogleFonts.openSans(
                                                    fontSize: 16)),
                                            Column(children: [
                                              snapshot.data.docs[index].data()[
                                                          'approvedBy'] ==
                                                      null
                                                  ? SizedBox(width: 0)
                                                  : Row(children: [
                                                      Text(
                                                          'Approved by ' +
                                                              snapshot.data
                                                                      .docs[index]
                                                                      .data()[
                                                                  'approvedBy'],
                                                          style: GoogleFonts
                                                              .openSans(
                                                                  fontSize:
                                                                      16)),
                                                    ])
                                            ]),
                                            SizedBox(height: 20),
                                            CustomButton(
                                              ontap: () => Get.defaultDialog(
                                                  title: 'Apakah anda yakin?',
                                                  middleText: '',
                                                  textConfirm: 'Ya',
                                                  textCancel: 'Batal',
                                                  confirmTextColor:
                                                      Colors.white,
                                                  onConfirm: () {
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      getDocId = snapshot
                                                          .data.docs[index].id;
                                                    });
                                                    Database()
                                                        .approve(getDocId,
                                                            'Admin')
                                                        .whenComplete(() {
                                                      Get.snackbar(
                                                        'Success',
                                                        'Data berhasil di approve',
                                                        margin:
                                                            EdgeInsets.all(20),
                                                        colorText: Colors.white,
                                                        backgroundColor:
                                                            Colors.grey[900],
                                                        snackPosition:
                                                            SnackPosition
                                                                .BOTTOM,
                                                      );
                                                    });
                                                  }),
                                              color: Colors.red,
                                              title: 'Hapus',
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
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            //// Rejected ////

            Center(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Items')
                    .where('isApproved', isEqualTo: true)
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Rejected ',
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              snapshot.data.docs.length.toString(),
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (_, index) {
                              return InkWell(
                                onTap: () {
                                  // navigateToDetail(
                                  //     snapshot.data.docs[index], getDocId);
                                  // setState(() {
                                  //   getDocId = snapshot.data.docs[index].id;
                                  // });

                                  Get.bottomSheet(
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          topLeft: Radius.circular(20)),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .70,
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  snapshot.data.docs[index]
                                                      .data()['barang'],
                                                  style: GoogleFonts.openSans(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20)),
                                              Text(
                                                  snapshot.data.docs[index]
                                                      .data()['sales_pengaju'],
                                                  style: GoogleFonts.openSans(
                                                      fontSize: 16)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 5),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          child: Icon(Icons.arrow_forward),
                                          top: 0,
                                          right: 0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .80,
                                              child: Text(
                                                  snapshot.data.docs[index]
                                                      .data()['barang'],
                                                  style: GoogleFonts.openSans(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18)),
                                            ),
                                            Text(
                                                snapshot.data.docs[index]
                                                        .data()[
                                                    'tanggal_perkiraan'],
                                                style: GoogleFonts.openSans(
                                                    fontSize: 16)),
                                            Row(
                                              children: [
                                                Text(
                                                    snapshot.data.docs[index]
                                                        .data()['city'],
                                                    style: GoogleFonts.openSans(
                                                        fontSize: 16)),
                                                Text(
                                                    snapshot.data.docs[index]
                                                                    .data()[
                                                                'district'] ==
                                                            null
                                                        ? ''
                                                        : ', ${snapshot.data.docs[index].data()['district']}',
                                                    style: GoogleFonts.openSans(
                                                        fontSize: 16)),
                                              ],
                                            ),
                                            Text(
                                                snapshot.data.docs[index]
                                                    .data()['tipe_demo'],
                                                style: GoogleFonts.openSans(
                                                    fontSize: 16)),
                                            Column(children: [
                                              snapshot.data.docs[index].data()[
                                                          'approvedBy'] ==
                                                      null
                                                  ? SizedBox(width: 0)
                                                  : Row(children: [
                                                      Text(
                                                          'Rejected by ' +
                                                              snapshot.data
                                                                      .docs[index]
                                                                      .data()[
                                                                  'approvedBy'],
                                                          style: GoogleFonts
                                                              .openSans(
                                                                  fontSize:
                                                                      16)),
                                                    ])
                                            ]),
                                            SizedBox(height: 20),
                                            CustomButton(
                                              ontap: () => Get.defaultDialog(
                                                  title: 'Apakah anda yakin?',
                                                  middleText: '',
                                                  textConfirm: 'Ya',
                                                  textCancel: 'Batal',
                                                  confirmTextColor:
                                                      Colors.white,
                                                  onConfirm: () {
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      getDocId = snapshot
                                                          .data.docs[index].id;
                                                    });
                                                    Database()
                                                        .approve(getDocId,
                                                            'Admin')
                                                        .whenComplete(() {
                                                      Get.snackbar(
                                                        'Success',
                                                        'Data berhasil di approve',
                                                        margin:
                                                            EdgeInsets.all(20),
                                                        colorText: Colors.white,
                                                        backgroundColor:
                                                            Colors.grey[900],
                                                        snackPosition:
                                                            SnackPosition
                                                                .BOTTOM,
                                                      );
                                                    });
                                                  }),
                                              color: Colors.red,
                                              title: 'Hapus',
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
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  final DocumentSnapshot post;
  final String docId;

  const DetailPage({Key key, this.post, this.docId}) : super(key: key);
  @override
  _DetailPageState createState() => _DetailPageState();
}

String _googleUserName =
    FirebaseAuth.instance.currentUser.displayName.toString();

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Text(widget.post.data()['barang']),
            Padding(
              padding: const EdgeInsets.all(20),
              child: InkWell(
                onTap: () {
                  Database()
                      .approve(widget.docId, _googleUserName)
                      .whenComplete(() {
                    Navigator.pop(context);
                    Get.snackbar('title', 'Data Approved');
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue),
                  height: 40,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Approve',
                      style: GoogleFonts.openSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
