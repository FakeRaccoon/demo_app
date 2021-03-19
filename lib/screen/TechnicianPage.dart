import 'package:atana/model/technician_task.dart';
import 'package:atana/service/api.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TechnicianPage extends StatefulWidget {
  @override
  _TechnicianPageState createState() => _TechnicianPageState();
}

class _TechnicianPageState extends State<TechnicianPage> {
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
                  if (snapshot.data.isEmpty) {
                    return Scaffold(
                      body: Center(
                        child: Text('Tidak ada penugasan baru'),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      Technician tech = snapshot.data[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(DateFormat('d MMM y').format(tech.depart)),
                              SizedBox(height: 10),
                              Divider(thickness: 1),
                              ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(tech.task, style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
                                  subtitle: Text(
                                      tech.warehouse.toLowerCase().contains('gudang')
                                          ? tech.warehouse
                                          : 'Gudang ${tech.warehouse}',
                                      style: GoogleFonts.openSans())),
                            ],
                          ),
                        ),
                      );
                    },
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
}
