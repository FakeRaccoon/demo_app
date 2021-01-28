import 'dart:async';
import 'dart:ui';

import 'package:atana/component/CustomDenseButton.dart';
import 'package:atana/component/customTFsmall.dart';
import 'package:atana/model/COA.dart';
import 'package:atana/service/api.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class Cashier extends StatefulWidget {
  @override
  _CashierState createState() => _CashierState();
}

class _CashierState extends State<Cashier> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onRefresh();
  }

  Future formFuture;
  Future cashFuture;
  Future feeFuture;

  Future onRefresh() async {
    formFuture = API.getFormStatus(5);
    cashFuture = API.getCOA(1000);
    feeFuture = API.getCOA(9200);
    setState(() {});
  }

  String getDocId;
  var currency = NumberFormat.decimalPattern();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        title: Text('Kasir'),
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
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return RefreshIndicator(
                    onRefresh: onRefresh,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, index) {
                        int total = snapshot.data[index].fee.map((e) => e.fee).toList().fold(0, (p, e) => p + e);
                        return Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: ExpandablePanel(
                                theme: ExpandableThemeData(headerAlignment: ExpandablePanelHeaderAlignment.center),
                                header: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    snapshot.data[index].item.atanaName,
                                    style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 18),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                expanded: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Divider(thickness: 1),
                                    SizedBox(height: 10),
                                    Text('Detail',
                                        style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16)),
                                    SizedBox(height: 20),
                                    Text('BIAYA',
                                        style: GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.grey)),
                                    ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data[index].fee.length,
                                      itemBuilder: (BuildContext context, int i) {
                                        return Row(
                                          children: [
                                            Text(snapshot.data[index].fee[i].description,
                                                style: GoogleFonts.openSans(fontSize: 16)),
                                            Spacer(),
                                            Text('Rp ' + currency.format(snapshot.data[index].fee[i].fee),
                                                style: GoogleFonts.openSans(fontSize: 16)),
                                          ],
                                        );
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Spacer(),
                                        Text('Total',
                                            style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold)),
                                        SizedBox(width: 10),
                                        Text('Rp ' + currency.format(total), style: GoogleFonts.openSans(fontSize: 16)),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Text('AKUN KAS', style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
                                    TextFormField(
                                        readOnly: true,
                                        onTap: () => kasBottomSheet(context),
                                        decoration: InputDecoration(hintText: 'Pilih akun kas')),
                                    SizedBox(height: 20),
                                    Text('AKUN BIAYA', style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
                                    TextFormField(decoration: InputDecoration(hintText: 'Pilih akun biaya')),
                                    SizedBox(height: 20),
                                    CustomDenseButton(
                                      onTap: () {},
                                      title: 'Konfirmasi',
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

  Future kasBottomSheet(BuildContext context) {
    return showMaterialModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      IconButton(
                          padding: EdgeInsets.zero, icon: Icon(Icons.clear), onPressed: () => Navigator.pop(context)),
                      Text('Gudang', style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: CustomTextFieldSmall(
                    hintText: 'Cari gudang',
                    prefixIcon: Icon(Icons.search),
                    onchange: (value) {
                      print(value);
                    },
                  ),
                ),
                FutureBuilder(
                  future: cashFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.only(right: 20, left: 20),
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            Coa coa = snapshot.data[index];
                            return ListTile(
                              onTap: () {
                                // warehouseController.text = snapshot.data[index].warehouseName;
                                Navigator.pop(context);
                              },
                              contentPadding: EdgeInsets.zero,
                              title: Text(coa.coaName, style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
                              subtitle: Text(coa.coaCode),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(thickness: 1);
                          },
                        ),
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// class CashierDetail extends StatefulWidget {
//   final String docId;
//   final int fee;
//
//   const CashierDetail({Key key, this.docId, this.fee}) : super(key: key);
//
//   @override
//   _CashierDetailState createState() => _CashierDetailState();
// }
//
// class _CashierDetailState extends State<CashierDetail> {
//   TextEditingController kasController = TextEditingController();
//   TextEditingController feeController = TextEditingController();
//
//   bool isLoading = false;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//
//   var currency = NumberFormat.decimalPattern();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(10),
//             child: Card(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Akun Kas',
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 10),
//                     CustomTextField(
//                       controller: kasController,
//                       icon: Icon(Icons.arrow_drop_down),
//                       readOnly: true,
//                       ontap: () => showMaterialModalBottomSheet(
//                         backgroundColor: Colors.transparent,
//                         context: context,
//                         expand: true,
//                         enableDrag: false,
//                         isDismissible: false,
//                         builder: (BuildContext context) {
//                           return kasBottomSheet();
//                         },
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Text(
//                       'Akun Biaya',
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 10),
//                     CustomTextField(
//                       icon: Icon(Icons.arrow_drop_down),
//                       controller: feeController,
//                       readOnly: true,
//                       ontap: () => showMaterialModalBottomSheet(
//                         backgroundColor: Colors.transparent,
//                         context: context,
//                         expand: true,
//                         enableDrag: false,
//                         isDismissible: false,
//                         builder: (BuildContext context) {
//                           return feeBottomSheet();
//                         },
//                       ),
//                     ),
//                     SizedBox(height: 50),
//                     Row(
//                       children: [
//                         Text(
//                           'Total',
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                         Spacer(),
//                         Text('Rp ' + currency.format(widget.fee).toString(), style: TextStyle(fontSize: 16)),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     CustomOutlineButton(
//                       ontap: () {
//                         print(feeController.text);
//                       },
//                       title: 'Konfirmasi',
//                       color: Colors.blue,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<Coa> kas = List();
//   List<Coa> filteredKas = List();
//
//   bool kasLoading = true;
//   int kasId;
//
//   Widget kasBottomSheet() {
//     return StatefulBuilder(
//       builder: (BuildContext context, StateSetter setModalState) {
//         return SafeArea(
//           child: Container(
//             height: MediaQuery.of(context).size.height * .70,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(10),
//                 topRight: Radius.circular(10),
//               ),
//               color: Colors.white,
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       IconButton(
//                           icon: Icon(Icons.clear),
//                           onPressed: () {
//                             Navigator.pop(context);
//                             setModalState(() {
//                               filteredKas = kas;
//                             });
//                           }),
//                       SizedBox(width: 10),
//                       Text(
//                         'Akun Kas',
//                         style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                   CustomTextFieldSmall(
//                     hintText: 'Cari akun kas',
//                     prefixIcon: Icon(Icons.search),
//                     readOnly: false,
//                     onchange: (filter) {
//                       setModalState(() {
//                         filteredKas = kas.where((u) => (u.name.toLowerCase().contains(filter.toLowerCase()))).toList();
//                       });
//                     },
//                   ),
//                   Expanded(
//                     child: Center(
//                       child: isLoading
//                           ? Center(child: CircularProgressIndicator())
//                           : ListView.separated(
//                               itemCount: filteredKas.length,
//                               itemBuilder: (context, index) {
//                                 return ListTile(
//                                   onTap: () {
//                                     setState(() {
//                                       kasController.text = filteredKas[index].name;
//                                       kasId = filteredKas[index].id.toInt();
//                                       print(kasId);
//                                     });
//                                     Navigator.pop(context);
//                                     setModalState(() {
//                                       filteredKas = kas;
//                                     });
//                                   },
//                                   title: Text(filteredKas[index].name),
//                                 );
//                               },
//                               separatorBuilder: (BuildContext context, int index) {
//                                 return Divider();
//                               },
//                             ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   List<Coa> fee = List();
//   List<Coa> filteredFee = List();
//
//   bool feeLoading = true;
//   int feeId;
//
//   Widget feeBottomSheet() {
//     return StatefulBuilder(
//       builder: (BuildContext context, StateSetter setModalState) {
//         return SafeArea(
//           child: Container(
//             height: MediaQuery.of(context).size.height * .70,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(10),
//                 topRight: Radius.circular(10),
//               ),
//               color: Colors.white,
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       IconButton(
//                           icon: Icon(Icons.clear),
//                           onPressed: () {
//                             Navigator.pop(context);
//                             setModalState(() {
//                               filteredFee = fee;
//                             });
//                           }),
//                       SizedBox(width: 10),
//                       Text(
//                         'Akun Biaya',
//                         style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                   CustomTextFieldSmall(
//                     hintText: 'Cari akun biaya',
//                     prefixIcon: Icon(Icons.search),
//                     readOnly: false,
//                     onchange: (filter) {
//                       setModalState(() {
//                         filteredFee = fee.where((u) => (u.name.toLowerCase().contains(filter.toLowerCase()))).toList();
//                       });
//                     },
//                   ),
//                   Expanded(
//                     child: Center(
//                       child: isLoading
//                           ? Center(child: CircularProgressIndicator())
//                           : ListView.separated(
//                               itemCount: filteredKas.length,
//                               itemBuilder: (context, index) {
//                                 return ListTile(
//                                   onTap: () {
//                                     setState(() {
//                                       feeController.text = filteredFee[index].name;
//                                       feeId = filteredFee[index].id.toInt();
//                                       print(feeId);
//                                     });
//                                     Navigator.pop(context);
//                                     setModalState(() {
//                                       filteredFee = fee;
//                                     });
//                                   },
//                                   title: Text(filteredFee[index].name),
//                                 );
//                               },
//                               separatorBuilder: (BuildContext context, int index) {
//                                 return Divider();
//                               },
//                             ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
