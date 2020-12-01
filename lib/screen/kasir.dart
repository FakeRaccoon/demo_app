import 'dart:ui';

import 'package:atana/component/button.dart';
import 'package:atana/component/cusomTF.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Cashier extends StatefulWidget {
  @override
  _CashierState createState() => _CashierState();
}

class _CashierState extends State<Cashier> {
  String getDocId;

  navigateToCashierDetail(DocumentSnapshot post, String docID) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CashierDetail(
                  post: post,
                  docId: getDocId,
                )));
  }

  var currency = NumberFormat.decimalPattern();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kasir'),
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
                        onTap: () {
                          navigateToCashierDetail(
                              snapshot.data.docs[index], getDocId);
                          setState(() {
                            getDocId = snapshot.data.docs[index].id;
                          });
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 4,
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
                                    Text(
                                        'Rp ' +
                                            currency
                                                .format(snapshot
                                                    .data.docs[index]
                                                    ?.data()['estimasiBiaya'])
                                                .toString(),
                                        style:
                                            GoogleFonts.openSans(fontSize: 16)),
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

class CashierDetail extends StatefulWidget {
  final String docId;
  final DocumentSnapshot post;

  const CashierDetail({Key key, this.docId, this.post}) : super(key: key);

  @override
  _CashierDetailState createState() => _CashierDetailState();
}

class _CashierDetailState extends State<CashierDetail> {
  TextEditingController feeController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  var currency = NumberFormat.decimalPattern();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Card(
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Akun Kas',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      icon: Icon(Icons.arrow_drop_down),
                      readOnly: true,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Akun Biaya',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      icon: Icon(Icons.arrow_drop_down),
                      controller: feeController,
                      readOnly: true,
                    ),
                    SizedBox(height: 50),
                    Row(
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                            'Rp ' +
                                currency
                                    .format(widget.post.data()['estimasiBiaya'])
                                    .toString(),
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 20),
                    CustomButton(
                      ontap: () {
                        print(feeController.text);
                      },
                      title: 'Konfirmasi',
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Text(widget.post.data()['barang']),
        ],
      ),
    );
  }
}
