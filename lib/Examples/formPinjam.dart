import 'dart:convert';
import 'dart:io';

import 'package:atana/component/button.dart';
import 'package:atana/component/cusomTF.dart';
import 'package:atana/model/item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import '../service/database.dart';
import 'formApproval.dart';


class FormPinjam extends StatefulWidget {
  @override
  _FormPinjamState createState() => _FormPinjamState();
}

class _FormPinjamState extends State<FormPinjam> {
  DateTime tanggalPinjam;
  DateTime tanggalKembali;
  TimeOfDay time;

  @override
  void initState() {
    super.initState();
    tanggalPinjam = DateTime.now();
    tanggalKembali = DateTime.now();
    time = TimeOfDay.now();
    getHttp();
    // _loadJson();
  }

  _tanggalPinjam() async {
    final DateTime _pickedDate = await showDatePicker(
      context: context,
      initialDate: tanggalPinjam,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2100),
    );
    if (_pickedDate != null) {
      setState(() {
        tanggalPinjam = _pickedDate;
        tanggalPinjamController.text = tanggalPinjam.toString();
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
        tanggalKembaliController.text = tanggalPinjam.toString();
      });
    }
  }
  List data = List();

  String _valItem;
  String _valKota;
  String _itemVal;
  String _googleUserName =
      FirebaseAuth.instance.currentUser.displayName.toString();

  List _listKota = ['Surabaya', 'Jakarta'];
  List<dynamic> _listItem = List();

  String apiUrl = 'http://103.56.149.39/amt_api/api/atana_get_item';
  String apiKey = 'IndofarmSurabaya';

  void getHttp() async {
    final response = await http.get(apiUrl, headers: {HttpHeaders.authorizationHeader: '$apiKey'});
    var listData = jsonDecode(response.body);
    setState(() {
      _listItem = listData;
    });
  }

  final TextEditingController customerController = TextEditingController();
  final TextEditingController tanggalPinjamController = TextEditingController();
  final TextEditingController tanggalKembaliController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Container(
              //   height: 50,
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(20),
              //     color: Color.fromRGBO(231, 235, 237, 100),
              //   ),
              //   child: DropdownButtonHideUnderline(
              //     child: ButtonTheme(
              //       alignedDropdown: true,
              //       child: DropdownButton(
              //         hint: Text("Select Item"),
              //         value: _itemVal,
              //         isExpanded: true,
              //         items: _listItem.map((item) {
              //           return DropdownMenuItem(
              //             child: Text(item['atanaName']),
              //             value: item['atanaName'],
              //           );
              //         }).toList(),
              //         onChanged: (value) {
              //           setState(() {
              //             _itemVal = value;
              //           });
              //         },
              //       ),
              //     ),
              //   ),
              // ),

              SizedBox(height: 20),
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromRGBO(231, 235, 237, 100),
                ),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: DropdownButton(
                        hint: Text("Pilih Kota"),
                        value: _valKota,
                        items: _listKota.map((value) {
                          return DropdownMenuItem(
                            child: Text(value),
                            value: value,
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _valKota = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              CustomTextField(
                readOnly: true,
                ontap: _tanggalPinjam,
                controller: tanggalPinjamController,
                icon: Icon(Icons.calendar_today),
                hintText: 'Tanggal Pinjam',
              ),
              SizedBox(height: 20),
              CustomTextField(
                readOnly: true,
                ontap: _tanggalKembali,
                controller: tanggalKembaliController,
                icon: Icon(Icons.calendar_today),
                hintText: 'Tanggal Kembali',
              ),
              SizedBox(height: 20),
              CustomTextField(
                hintText: 'Customer',
                readOnly: false,
                controller: customerController,
                icon: Icon(Icons.people),
              ),
              SizedBox(height: 20),
              CustomButton(
                title: 'Submit',
                ontap: () {
                  if (_valItem == null) {
                    Get.snackbar('Warning', 'Pilih Barang');
                  } else if (_valKota == null) {
                    Get.snackbar('Warnig', 'Pilih Kota');
                  } else if (customerController.text == '') {
                    Get.snackbar('Warning', 'Isi Customer');
                  } else if (_valItem != null &&
                      _valKota != null &&
                      customerController.text != null) {
                    Database()
                        .addItem(
                            _googleUserName,
                            _valItem,
                            _valKota,
                            tanggalPinjam,
                            tanggalKembali,
                            customerController.text)
                        .whenComplete(
                      () {
                        Get.snackbar('Success', 'Data Berhaasil');
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
