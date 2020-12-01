import 'package:atana/component/button.dart';
import 'package:atana/component/cusomTF.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PerjalananDemo extends StatefulWidget {
  @override
  _PerjalananDemoState createState() => _PerjalananDemoState();
}

class _PerjalananDemoState extends State<PerjalananDemo> {
  String getDocId;

  navigateToDetail(DocumentSnapshot post, String docID) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DetailPagePenugasan(post: post, docId: getDocId)));
  }

  String userName = FirebaseAuth.instance.currentUser.displayName;

  var currency = new NumberFormat.decimalPattern();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perjalanan demo'),
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
                          navigateToDetail(snapshot.data.docs[index], getDocId);
                          setState(() {
                            getDocId = snapshot.data.docs[index].id;
                          });
                        },
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                                      child: Text(snapshot.data.docs[index]?.data()['barang'],
                                          style: GoogleFonts.openSans(
                                              fontWeight: FontWeight.bold, fontSize: 18)),
                                      width: MediaQuery.of(context).size.width * .60,
                                    ),
                                    Row(
                                      children: [
                                        Text(snapshot.data.docs[index].data()['city'],
                                            style: GoogleFonts.openSans(fontSize: 16)),
                                        Text(
                                            snapshot.data.docs[index].data()['district'] == null
                                                ? ''
                                                : ', ${snapshot.data.docs[index].data()['district']}',
                                            style: GoogleFonts.openSans(fontSize: 16)),
                                      ],
                                    ),
                                    Text(snapshot.data.docs[index].data()['transport'],
                                        style: GoogleFonts.openSans(fontSize: 16)),
                                    Text(
                                        'Rp ' +
                                            currency
                                                .format(snapshot.data.docs[index]
                                                    .data()['estimasiBiaya'])
                                                .toString(),
                                        style: GoogleFonts.openSans(fontSize: 16)),
                                    Row(
                                      children: [
                                        Text(snapshot.data.docs[index]?.data()['tanggalBerangkat'],
                                            style: GoogleFonts.openSans(fontSize: 16)),
                                        Icon(Icons.arrow_forward),
                                        Text(snapshot.data.docs[index]?.data()['tanggalKembali'],
                                            style: GoogleFonts.openSans(fontSize: 16)),
                                      ],
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        FlatButton(
                                          minWidth: 150,
                                          child: Text('Reject',
                                              style: GoogleFonts.openSans(
                                                  fontSize: 14, fontWeight: FontWeight.w700)),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10)),
                                          color: Colors.red,
                                          textColor: Colors.white,
                                          onPressed: () {
                                            showMaterialModalBottomSheet(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.only(
                                                        topRight: Radius.circular(10),
                                                        topLeft: Radius.circular(10))),
                                                context: context,
                                                builder: (context) => Container(
                                                      height:
                                                          MediaQuery.of(context).size.height * .50,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(20),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              'Alasan Reject',
                                                              style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold),
                                                            ),
                                                            Expanded(
                                                              child: TextFormField(
                                                                maxLines: 16,
                                                                decoration: InputDecoration(
                                                                    hintText: 'Tuliskan alasan reject...'),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment.bottomCenter,
                                                              child: CustomButton(
                                                                title: 'Confirm',
                                                                color: Colors.blue,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ));
                                            print('rejected');
                                          },
                                        ),
                                        FlatButton(
                                          minWidth: 150,
                                          child: Text('Approve',
                                              style: GoogleFonts.openSans(
                                                  fontSize: 14, fontWeight: FontWeight.w700)),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10)),
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

class DetailPagePenugasan extends StatefulWidget {
  final DocumentSnapshot post;
  final String docId;

  const DetailPagePenugasan({Key key, this.post, this.docId}) : super(key: key);
  @override
  _DetailPagePenugasanState createState() => _DetailPagePenugasanState();
}

String _googleUserName = FirebaseAuth.instance.currentUser.displayName.toString();

class _DetailPagePenugasanState extends State<DetailPagePenugasan> {
  final TextEditingController tanggalBerangkatContoller = TextEditingController();
  final TextEditingController tanggalKembaliController = TextEditingController();
  DateTime tanggalBerangkat;
  DateTime tanggalKembali;

  // _tanggalBerangkat() async {
  //   final DateTime _pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: tanggalBerangkat,
  //     firstDate: DateTime(2015, 8),
  //     lastDate: DateTime(2100),
  //   );
  //   if (_pickedDate != null) {
  //     setState(() {
  //       tanggalBerangkat = _pickedDate;
  //       tanggalBerangkatContoller.text =
  //           DateFormat('d MMMM y').format(tanggalBerangkat);
  //       returnDate = tanggalKembaliController.text;
  //     });
  //   }
  // }
  //
  // _tanggalKembali() async {
  //   final DateTime _pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: tanggalKembali,
  //     firstDate: DateTime(2015, 8),
  //     lastDate: DateTime(2100),
  //   );
  //   if (_pickedDate != null) {
  //     setState(() {
  //       tanggalKembali = _pickedDate;
  //       tanggalKembaliController.text =
  //           DateFormat('d MMMM y').format(tanggalKembali);
  //     });
  //   }
  // }

  var currency = new NumberFormat.decimalPattern();

  @override
  void initState() {
    super.initState();
    tanggalBerangkat = DateTime.now();
    tanggalKembali = DateTime.now();
    warehouse1 = true;
    warehouse2 = false;
    warehouse3 = false;
    print(currency.format(widget.post.data()['estimasiBiaya']));
  }

  bool isReturnDateVisible = false;
  bool isSwitched = false;
  bool warehouse1;
  bool warehouse2;
  bool warehouse3;
  String selectedWarehouse;
  String returnDate;
  String driverResult;

  TextEditingController feeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.all(20),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gudang',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      readOnly: true,
                      icon: Icon(Icons.arrow_drop_down),
                      hintText: 'Pilih gudang',
                    ),
                    SizedBox(height: 20),
                    Text(widget.post['barang']),
                    Text('Rp ' + currency.format(widget.post['estimasiBiaya']).toString()),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FlatButton(
                          minWidth: 150,
                          child: Text('Reject',
                              style:
                                  GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.w700)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          color: Colors.red,
                          textColor: Colors.white,
                          onPressed: () {
                            print('rejected');
                          },
                        ),
                        FlatButton(
                          minWidth: 150,
                          child: Text('Approve',
                              style:
                                  GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.w700)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
          ],
        ),
      ),
    );
  }
}
