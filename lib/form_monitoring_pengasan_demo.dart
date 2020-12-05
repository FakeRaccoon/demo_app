import 'package:atana/Body.dart';
import 'package:atana/component/cusomTF.dart';
import 'package:atana/model/transport_model.dart';
import 'package:atana/screen/pilih_teknisi.dart';
import 'package:atana/service/api.dart';
import 'package:atana/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MonitoringPenugasa extends StatefulWidget {
  @override
  _MonitoringPenugasaState createState() => _MonitoringPenugasaState();
}

class _MonitoringPenugasaState extends State<MonitoringPenugasa> {
  String getDocId;

  navigateToDetail(DocumentSnapshot post, String docID) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPagePenugasanDemo(
                  post: post,
                  docId: getDocId,
                )));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monitoring penugasan'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAll(Body());
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                                    Text(snapshot.data.docs[index]?.data()['tanggal_perkiraan'],
                                        style: GoogleFonts.openSans(fontSize: 16)),
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

class DetailPagePenugasanDemo extends StatefulWidget {
  final DocumentSnapshot post;
  final String docId;
  final selectedTechCount;
  final List selectedTech;

  const DetailPagePenugasanDemo(
      {Key key, this.post, this.docId, this.selectedTechCount, this.selectedTech})
      : super(key: key);
  @override
  _DetailPagePenugasanDemoState createState() => _DetailPagePenugasanDemoState();
}

class _DetailPagePenugasanDemoState extends State<DetailPagePenugasanDemo>
    with AutomaticKeepAliveClientMixin {
  navigateToDetail(String docID, DocumentSnapshot post) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PilihTeknisi(
                  docId: widget.docId,
                  post: widget.post,
                )));
  }

  final TextEditingController tanggalBerangkatContoller = TextEditingController();
  final TextEditingController tanggalKembaliController = TextEditingController();
  DateTime tanggalBerangkat;
  DateTime tanggalKembali;

  _tanggalBerangkat() async {
    final DateTime _pickedDate = await showDatePicker(
      context: context,
      initialDate: tanggalBerangkat,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2100),
    );
    if (_pickedDate != null) {
      setState(() {
        tanggalBerangkat = _pickedDate;
        tanggalBerangkatContoller.text = DateFormat('d MMMM y').format(tanggalBerangkat);
        returnDate = tanggalKembaliController.text;
      });
    }
  }

  _tanggalKembali() async {
    final DateTime _pickedDate = await showDatePicker(
      context: context,
      initialDate: tanggalKembali,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2100),
    );
    if (_pickedDate != null) {
      setState(() {
        tanggalKembali = _pickedDate;
        tanggalKembaliController.text = DateFormat('d MMMM y').format(tanggalKembali);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    tanggalBerangkat = DateTime.now();
    tanggalKembali = DateTime.now();
    // tanggalBerangkatContoller.text =
    //     DateFormat('d MMMM y').format(tanggalBerangkat);
    // tanggalKembaliController.text =
    //     DateFormat('d MMMM y').format(tanggalKembali);
    print(widget.docId);
  }

  bool isReturnDateVisible = false;
  bool isSwitched = false;
  String returnDate;
  String transportResult;
  String feeResult;
  String driverResult;

  TextEditingController feeController = TextEditingController();
  var currency = NumberFormat.decimalPattern();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.off(MonitoringPenugasa());
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                          navigateToDetail(widget.docId, widget.post);
                          // Get.bottomSheet(
                          //   ClipRRect(
                          //     borderRadius: BorderRadius.only(
                          //         topLeft: Radius.circular(10),
                          //         topRight: Radius.circular(10)),
                          //     child: Container(
                          //       color: Colors.white,
                          //       height: MediaQuery.of(context).size.height * .40,
                          //       child: Padding(
                          //         padding: const EdgeInsets.all(20),
                          //         child: Column(
                          //           crossAxisAlignment: CrossAxisAlignment.start,
                          //           children: [
                          //             Text(
                          //               'Teknisi yang ditugaskan',
                          //               style: GoogleFonts.openSans(
                          //                   fontSize: 16,
                          //                   fontWeight: FontWeight.bold),
                          //             ),
                          //
                          //             Spacer(),
                          //             CustomButton(
                          //               title: 'Simpan',
                          //               color: Colors.blue,
                          //               ontap: () {
                          //                 Get.snackbar('Berhasil',
                          //                     'Data Berhasil Diajukan',
                          //                     snackPosition: SnackPosition.BOTTOM,
                          //                     margin: EdgeInsets.all(20),
                          //                     colorText: Colors.white,
                          //                     backgroundColor: Colors.grey[900]);
                          //               },
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // );
                        },
                        readOnly: true,
                        hintText: widget.selectedTechCount == null
                            ? 'Teknisi'
                            : widget.selectedTechCount.toString() + ' Teknisi ditugaskan',
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
                              children: [
                                DropdownSearch(
                                  dropdownSearchDecoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(left: 15, right: 10)),
                                  mode: Mode.BOTTOM_SHEET,
                                  hint: 'Sopir',
                                  onFind: (String filter) async {
                                    var response = await Dio()
                                        .get(baseDemoUrl + 'transport', queryParameters: {
                                      'Accept': 'application/Json',
                                    });
                                    var models = TransportModel.fromJsonList(response.data);
                                    return models;
                                  },
                                  onChanged: (TransportModel data) {
                                    setState(() {
                                      driverResult = data.name;
                                    });
                                    print(driverResult);
                                  },
                                ),
                                SizedBox(height: 20),
                              ],
                            )
                          : SizedBox(),
                      DropdownSearch(
                        dropdownSearchDecoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 15, right: 10)),
                        mode: Mode.BOTTOM_SHEET,
                        hint: 'Kendaraan',
                        onFind: (String filter) async {
                          var response = await Dio().get(baseDemoUrl + 'transport',
                              options: Options(headers: {
                                'username': 'amt',
                                'password': 'kedungdoro',
                                'token': token
                              }),
                              queryParameters: {
                                'Accept': 'application/Json',
                              });
                          var models = TransportModel.fromJsonList(response.data['result']);
                          return models;
                        },
                        onChanged: (TransportModel data) {
                          setState(() {
                            transportResult = data.name;
                          });
                          print(transportResult);
                        },
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                        readOnly: true,
                        ontap: _tanggalBerangkat,
                        controller: tanggalBerangkatContoller,
                        icon: Icon(Icons.calendar_today),
                        hintText: 'Tanggal Berangkat',
                      ),
                      Visibility(
                        visible: returnDate == null ? false : true,
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            CustomTextField(
                              readOnly: true,
                              ontap: _tanggalKembali,
                              controller: tanggalKembaliController,
                              icon: Icon(Icons.calendar_today),
                              hintText: 'Tanggal Kembali',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
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
                          children: [
                            SizedBox(height: 20),
                            CustomTextField(
                              readOnly: false,
                              hintText: 'Deskripsi biaya',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          Database().penugasanDemo(
                              widget.docId,
                              transportResult,
                              tanggalBerangkatContoller.text,
                              tanggalKembaliController.text,
                              feeController.text,
                              feeController.text,
                              widget.selectedTech);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8), color: Colors.blue),
                          height: 40,
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              'Ajukan',
                              style: GoogleFonts.openSans(
                                  color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Text(widget.post['barang']),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
