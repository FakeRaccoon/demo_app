import 'package:atana/model/transport_detail.dart';
import 'package:atana/model/transport_model.dart';
import 'package:atana/service/RentalController.dart';
import 'package:atana/service/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Rental extends StatefulWidget {
  @override
  _RentalState createState() => _RentalState();
}

class _RentalState extends State<Rental> {
  final transport = Get.put(RentalController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onRefresh();
  }

  Future futureTransport;

  Future onRefresh() async {
    futureTransport = API.getTransport();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Transport Rental',
          style: GoogleFonts.openSans(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder(
        future: futureTransport,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: onRefresh,
              child: StaggeredGridView.countBuilder(
                shrinkWrap: true,
                padding: EdgeInsets.all(10),
                itemCount: snapshot.data.length,
                crossAxisCount: 2,
                itemBuilder: (BuildContext context, int index) {
                  Transport transportResult = snapshot.data[index];
                  return InkWell(
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => RentalDetail()));
                      Get.to(RentalDetail(), arguments: transportResult);
                      print(transportResult.id);
                      // showModalBottomSheet(
                      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
                      //   context: context,
                      //   builder: (BuildContext context) => Container(
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: [
                      //         Padding(
                      //           padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                      //           child: Text('Detail',
                      //               style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 18)),
                      //         ),
                      //         ListView(
                      //           padding: EdgeInsets.all(20),
                      //           shrinkWrap: true,
                      //           children: [
                      //             Text(transportResult.name),
                      //           ],
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              width: Get.width / 2,
                              height: Get.width * .45,
                              child: transportResult.image == null
                                  ? Image.network(
                                      "https://indonesiamodificationexpo.com/wp-content/uploads/2018/04/orionthemes-placeholder-image.jpg",
                                      fit: BoxFit.cover,
                                    )
                                  : Hero(
                                      tag: transportResult.name,
                                      child: Image.network(
                                          "https://demo.app.indofarm.id/public/storage/${transportResult.image}",
                                          // "http://10.0.2.2/demo/public/storage/${transportResult.image}",
                                          fit: BoxFit.contain)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(transportResult.name,
                                    style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 17)),
                                SizedBox(height: 5),
                                transportResult.plat == null ? SizedBox() : Text(transportResult.plat),
                                SizedBox(height: 5),
                                if (transportResult.kilometer == null)
                                  SizedBox()
                                else
                                  Text(
                                    "${transportResult.kilometer} KM",
                                    style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold),
                                  ),
                                if (transportResult.idle == false)
                                  SizedBox()
                                else
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(height: 20),
                                      Text('Available',
                                          style:
                                              GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.green)),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                staggeredTileBuilder: (int index) {
                  return StaggeredTile.fit(1);
                },
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class RentalDetail extends StatefulWidget {
  @override
  _RentalDetailState createState() => _RentalDetailState();
}

class _RentalDetailState extends State<RentalDetail> {
  Transport rental = Get.arguments;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    transportFuture = API.getTransportDetail(rental.id);
  }

  Future transportFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: transportFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          TransportDetail transport = snapshot.data[0];
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              title: Text('Transport Detail',
                  style: GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.black)),
            ),
            bottomNavigationBar: SizedBox(
              width: Get.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  onPressed: () {},
                  child: Text('Pinjam'),
                ),
              ),
            ),
            body: ListView(
              shrinkWrap: true,
              children: [
                if (transport.image != null)
                  Container(
                    color: Colors.white,
                    width: Get.width,
                    height: Get.width,
                    child: Hero(
                      tag: rental.name,
                      child: Image.network(
                        // 'http://10.0.2.2/demo/public/storage/${rental.image}',
                        'https://demo.app.indofarm.id/public/storage/${rental.image}',
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                else
                  Container(
                    width: Get.width,
                    height: Get.width,
                    child: Image.network(
                      "https://indonesiamodificationexpo.com/wp-content/uploads/2018/04/orionthemes-placeholder-image.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(transport.name, style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
                            transport.plat != null ? Text(transport.plat, style: GoogleFonts.openSans()) : SizedBox(),
                            SizedBox(height: 10),
                            if (transport.kilometer == null)
                              SizedBox()
                            else
                              Text('${transport.kilometer} KM',
                                  style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Spacer(),
                        if (transport.idle == true)
                          Text('Available',
                              style: GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.green))
                        else
                          Text('Not Available',
                              style: GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.red)),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('History', style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 17)),
                        SizedBox(height: 10),
                        if (transport.history.length != 0)
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: transport.history.length,
                            itemBuilder: (BuildContext context, int i) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(transport.history[i].driver.name),
                                    subtitle: Text(transport.history[i].description),
                                    leading: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          DateFormat('d \n MMM').format(transport.history[i].rentDate).toString(),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          )
                        else
                          Text('No History'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
