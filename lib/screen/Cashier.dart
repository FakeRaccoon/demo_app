import 'dart:async';
import 'dart:ui';

import 'package:atana/component/CustomDenseButton.dart';
import 'package:atana/component/customTFsmall.dart';
import 'package:atana/model/COA.dart';
import 'package:atana/model/form_model.dart';
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

  TextEditingController cashController = TextEditingController();
  TextEditingController feeController = TextEditingController();

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
            height: MediaQuery.of(context).size.height * .25,
            decoration:
                BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
          ),
          SafeArea(
            child: FutureBuilder(
              future: formFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if(snapshot.data.isEmpty){
                    return Scaffold(body: Center(child: Text('Tidak ada data'),),);
                  }
                  return RefreshIndicator(
                    onRefresh: onRefresh,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, index) {
                        FormResult form = snapshot.data[index];
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
                                  title: Text(form.item,
                                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 18),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1),
                                  subtitle: Text(DateFormat('d MMMM y').format(form.createdAt)),
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
                                      itemCount: form.fee.length,
                                      itemBuilder: (BuildContext context, int i) {
                                        return Row(
                                          children: [
                                            Text(form.fee[i].description, style: GoogleFonts.openSans(fontSize: 16)),
                                            Spacer(),
                                            Text('Rp ' + currency.format(form.fee[i].fee),
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
                                    TextFormField(
                                      readOnly: true,
                                      onTap: () => biayaBottomSheet(context),
                                      decoration: InputDecoration(hintText: 'Pilih akun biaya'),
                                    ),
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
    );
  }

  Future kasBottomSheet(BuildContext context) {
    return showMaterialModalBottomSheet(
      context: context,
      expand: true,
      enableDrag: false,
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
                      Text('Akun Kas', style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: CustomTextFieldSmall(
                    hintText: 'Cari akun kas',
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
                                cashController.text = coa.coaName;
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
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future biayaBottomSheet(BuildContext context) {
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
                      Text('Akun Biaya', style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: CustomTextFieldSmall(
                    hintText: 'Cari akun biaya',
                    prefixIcon: Icon(Icons.search),
                    onchange: (value) {
                      print(value);
                    },
                  ),
                ),
                FutureBuilder(
                  future: feeFuture,
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
                                feeController.text = coa.coaName;
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
                    return Center(child: CircularProgressIndicator());
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
