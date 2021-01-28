import 'package:atana/model/technician_task.dart';
import 'package:atana/service/api.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Technician extends StatefulWidget {
  @override
  _TechnicianState createState() => _TechnicianState();
}

class _TechnicianState extends State<Technician> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onRefresh();
  }

  Future onRefresh() async {
    techFuture = API.getTechnician();
    setState(() {});
  }

  Future techFuture;

  @override
  Widget build(BuildContext context) {
    var mediaQ = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Tugas teknisi'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Container(
            height: mediaQ.height * .25,
            color: Colors.blue,
          ),
          SafeArea(
            child: FutureBuilder(
              future: techFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      TechnicianTaskResult tech = snapshot.data[index];
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: ExpandablePanel(
                              header: ListTile(
                                  title: Text(tech.task,
                                      style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold)),
                                  subtitle: Text(DateFormat('d MMMM y').format(tech.departDate),
                                      style: GoogleFonts.openSans(fontSize: 16))),
                              // expanded: Row(
                              //   children: [
                              //     Text(
                              //       DateFormat('d MMMM y').format(tech[index].departDate),
                              //       style: GoogleFonts.openSans(fontSize: 16),
                              //     ),
                              //     Text(
                              //       DateFormat('d MMMM y').format(tech[index].returnDate),
                              //       style: GoogleFonts.openSans(fontSize: 16),
                              //     ),
                              //   ],
                              // ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
