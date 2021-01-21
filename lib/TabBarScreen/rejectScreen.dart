import 'dart:async';

import 'package:atana/service/api.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class RejectScreen extends StatefulWidget {
  @override
  _RejectScreenState createState() => _RejectScreenState();
}

class _RejectScreenState extends State<RejectScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadForm();
    _rejectController = new StreamController();
  }

  StreamController _rejectController;

  Future loadForm() async {
    API.getFormStatus(3).then((value) async {
      _rejectController.add(value);
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _rejectController.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.isEmpty) {
            Center(
              child: Text('No data'),
            );
          }
          return Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .25,
                color: Colors.blue,
              ),
              SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: Row(
                        children: [
                          Text('Rejected ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          Text(snapshot.data.length.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: ExpandablePanel(
                                  header: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        title: Text(
                                          snapshot.data[index].item.atanaName,
                                          style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 18),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(snapshot.data[index].city,
                                                    style: GoogleFonts.openSans(fontSize: 16)),
                                                Text(
                                                    snapshot.data[index].district == null
                                                        ? ''
                                                        : ', ${snapshot.data[index].district}',
                                                    style: GoogleFonts.openSans(fontSize: 16)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ],
                                  ),
                                  expanded: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Divider(thickness: 1),
                                      SizedBox(height: 10),
                                      Text('Detail',
                                          style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold)),
                                      SizedBox(height: 10),
                                      Text('TIPE DEMO',
                                          style: GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.grey)),
                                      SizedBox(height: 10),
                                      Text(snapshot.data[index].type, style: GoogleFonts.openSans(fontSize: 16)),
                                      SizedBox(height: 10),
                                      Text('SALES',
                                          style: GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.grey)),
                                      Text(snapshot.data[index].user.name, style: GoogleFonts.openSans(fontSize: 16)),
                                      SizedBox(height: 10),
                                      Text('TANGGAL ESTIMASI',
                                          style: GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.grey)),
                                      Text(DateFormat('MMMM y').format(snapshot.data[index].estimatedDate).toString(),
                                          style: GoogleFonts.openSans(fontSize: 16)),
                                      SizedBox(height: 20),
                                      ButtonTheme(
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        minWidth: MediaQuery.of(context).size.width,
                                        child: OutlineButton(
                                          onPressed: () {},
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          borderSide: BorderSide(color: Colors.red),
                                          child: Text(
                                            'Hapus',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        if (snapshot.hasError) {
          return Text(snapshot.error);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
