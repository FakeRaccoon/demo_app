import 'package:atana/model/form_model.dart';
import 'package:atana/service/api.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TripMonitoring extends StatefulWidget {
  @override
  _TripMonitoringState createState() => _TripMonitoringState();
}

class _TripMonitoringState extends State<TripMonitoring> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tripFuture = API.getFormStatus(6);
    returnFuture = API.getFormStatus(7);
  }

  Future tripFuture;
  Future returnFuture;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Trip Monitoring'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Datam Perjalanan'),
              Tab(text: 'Sudah Kembali'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FutureBuilder(
              future: tripFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.isEmpty) {
                    if (snapshot.data.isEmpty) {
                      return Scaffold(
                        body: Center(
                          child: Text('Tidak ada data'),
                        ),
                      );
                    }
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      FormResult form = snapshot.data[index];
                      final date = form.returnDate.difference(DateTime.now()).inDays;
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: ExpandablePanel(
                            theme: ExpandableThemeData(
                              tapHeaderToExpand: true,
                              headerAlignment: ExpandablePanelHeaderAlignment.center,
                            ),
                            header: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(form.warehouse),
                                SizedBox(height: 10),
                                Divider(thickness: 1),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    form.item,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(form.province.name),
                                ),
                                Text(DateFormat('d MMMM y').format(form.departureDate)),
                                SizedBox(height: 10),
                                if (date == 0)
                                  Text(
                                    "Harus kembali hari ini",
                                    style: GoogleFonts.sourceSansPro(
                                        fontWeight: FontWeight.bold, fontSize: 17, color: Colors.red),
                                  )
                                else
                                  Text(
                                    "Harus kembali dalam $date hari",
                                    style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 17),
                                  ),
                                if (form.type == "Test Mesin")
                                  Text("Barang ini harus kembali ke Gudang Demo")
                                else
                                  SizedBox(),
                              ],
                            ),
                            expanded: Column(
                              children: [
                                SizedBox(height: 10),
                                Image.network("https://demo.app.indofarm.id/public/storage/${form.image}"),
                                SizedBox(height: 10),
                                Image.network("https://demo.app.indofarm.id/public/storage/${form.codeImage}"),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            FutureBuilder(
              future: returnFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.isEmpty) {
                    if (snapshot.data.isEmpty) {
                      return Scaffold(
                        body: Center(
                          child: Text('Tidak ada data'),
                        ),
                      );
                    }
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      FormResult form = snapshot.data[index];
                      final date = form.returnDate.difference(DateTime.now()).inDays;
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(form.type == "Test Mesin" ? "Gudang Demo" : form.warehouse),
                              SizedBox(height: 10),
                              Divider(thickness: 1),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  form.item,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(form.province.name),
                              ),
                              Text(DateFormat('d MMMM y').format(form.returnDate)),
                              SizedBox(height: 10),
                              if (form.returnImage == null)
                                SizedBox()
                              else
                                Image.network("https://demo.app.indofarm.id/public/storage/${form.returnImage}"),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
