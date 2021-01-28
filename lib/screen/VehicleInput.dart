import 'package:atana/component/CustomDenseButton.dart';
import 'package:atana/model/form_model.dart';
import 'package:atana/model/transport_model.dart';
import 'package:atana/service/api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class VehicleInput extends StatefulWidget {
  @override
  _VehicleInputState createState() => _VehicleInputState();
}

class _VehicleInputState extends State<VehicleInput> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onRefresh();
  }

  Future onRefresh() async {
    vehicleFuture = API.getTransport();
    setState(() {});
  }

  Future vehicleFuture;

  TextEditingController vehicleController = TextEditingController();
  TextEditingController platController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => createVehicleBottomSheet(context),
      ),
      appBar: AppBar(),
      body: FutureBuilder(
        future: vehicleFuture,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(10),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                TransportResult transport = snapshot.data[index];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(20),
                    title: Text(transport.name),
                    subtitle: Text(transport.platNo ?? ''),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        vehicleController.text = transport.name;
                        transport.platNo != null ? platController.text = transport.platNo : platController.clear();
                        print(platController.text);
                        vehicleEditBottomSheet(context, transport);
                      },
                    ),
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future createVehicleBottomSheet(BuildContext context) {
    return showMaterialModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tambah Kendaraan', style: GoogleFonts.sourceSansPro(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 30),
                  Text('Kendaraan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  TextFormField(controller: vehicleController, decoration: InputDecoration(hintText: 'Nama kendaraan')),
                  SizedBox(height: 20),
                  Text('Plat Nomor', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  TextFormField(controller: platController, decoration: InputDecoration(hintText: 'Plat Nomor')),
                  SizedBox(height: 20),
                  CustomDenseButton(
                      title: 'Tambah',
                      color: Colors.blue,
                      onTap: () {
                        API.createTransport(vehicleController.text, platController.text).whenComplete(() {
                          onRefresh();
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('Berhasil menambahkan data')));
                          Navigator.pop(context);
                        });
                      }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future vehicleEditBottomSheet(BuildContext context, TransportResult transport) {
    return showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Edit Kendaraan', style: GoogleFonts.sourceSansPro(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 30),
                  Text('Kendaraan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  TextFormField(controller: vehicleController, decoration: InputDecoration(hintText: 'Nama kendaraan')),
                  SizedBox(height: 20),
                  Text('Plat Nomor', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  TextFormField(controller: platController, decoration: InputDecoration(hintText: 'Plat Nomor')),
                  SizedBox(height: 20),
                  CustomDenseButton(
                      title: 'Simpan',
                      color: Colors.blue,
                      onTap: () {
                        print(transport.id);
                        API.updateTransport(transport.id, vehicleController.text, platController.text).whenComplete(() {
                          onRefresh();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Berhasil')));
                          Navigator.pop(context);
                        });
                      }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
