import 'package:atana/component/button.dart';
import 'package:atana/form_monitoring_pengasan_demo.dart';
import 'package:atana/model/teknisi_model.dart';
import 'package:atana/perjalanan_demo.dart';
import 'package:atana/service/api.dart';
import 'package:atana/service/database.dart';
import 'package:atana/service/selected_technician.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PilihTeknisi extends StatefulWidget {
  final String docId;
  final DocumentSnapshot post;

  const PilihTeknisi({Key key, this.docId, this.post}) : super(key: key);

  @override
  _PilihTeknisiState createState() => _PilihTeknisiState();
}

class _PilihTeknisiState extends State<PilihTeknisi> with AutomaticKeepAliveClientMixin {
  TextEditingController searchController = TextEditingController();

  String searchResult;
  String itemCount;
  bool isLoading;
  bool isSelected = false;

  var mycolor = Colors.white;

  // List<Item> item = List();
  List<Teknisi> filteredItem = List();
  List<Teknisi> item = List();
  List<bool> listCheck = [];
  List<String> selectedTech = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading = true;
    });
    // API.getTeknisi().whenComplete(() {
    //   setState(() {
    //     isLoading = false;
    //   });
    // }).then((itemFromApi) {
    //   setState(() {
    //     item = itemFromApi;
    //     filteredItem = item;
    //   });
    // });
    // print(widget.docId);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBottomSheet();
          // Get.bottomSheet(technicianList());
        },
        child: Badge(
          badgeContent: Text(selectedTech.length.toString()),
          badgeColor: Colors.blue,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        selectedTech.clear();
                        navigateToDetail(selectedTech.length.toString(), selectedTech, widget.post);
                      },
                      child: Icon(Icons.arrow_back)),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey[200]),
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        onChanged: (string) {
                          setState(() {
                            filteredItem =
                                item.where((u) => (u.name.toLowerCase().contains(string.toLowerCase()))).toList();
                          });
                        },
                        controller: searchController,
                        autofocus: false,
                        decoration: InputDecoration(border: InputBorder.none, prefixIcon: Icon(Icons.search)),
                      ),
                    ),
                  ),
                  // ignore: null_aware_before_operator
                  searchController.text.isEmpty ? SizedBox() : Text('Cancel')
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: filteredItem.length == 0
                    ? Center(child: Text('Item tidak ditemukan'))
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: filteredItem.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedTech.add(filteredItem[index].name);
                              });
                            },
                            child: Card(
                              color: mycolor,
                              child: ListTile(
                                  selected: isSelected,
                                  title: Text(filteredItem[index].name),
                                  subtitle: Text(filteredItem[index].role),
                                  trailing: Icon(Icons.add)),
                            ),
                          );
                        }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget technicianList() {
  //   return Container(
  //     height: MediaQuery.of(context).size.height * .50,
  //     color: Colors.white,
  //     child: Padding(
  //       padding: const EdgeInsets.all(20),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               IconButton(
  //                 icon: Icon(Icons.cancel),
  //                 onPressed: () {},
  //               ),
  //               Text('Selected technician', style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold)),
  //               Spacer(),
  //               InkWell(
  //                 onTap: () {
  //                   setState(() {
  //                     selectedTech.clear();
  //                   });
  //                 },
  //                 child: Text('Clear', style: GoogleFonts.openSans(fontSize: 18)),
  //               ),
  //             ],
  //           ),
  //           Expanded(
  //             child: ListView.builder(
  //                 shrinkWrap: true,
  //                 itemCount: selectedTech.length,
  //                 itemBuilder: (context, index) {
  //                   return ListTile(
  //                     title: Text(selectedTech[index]),
  //                   );
  //                 }),
  //           ),
  //           CustomButton(
  //             ontap: () {
  //               Database().addTechnician(selectedTech, widget.docId);
  //             },
  //             color: Colors.blue,
  //             title: 'Simpan',
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  void showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Container(
                height: MediaQuery.of(context).size.height * .50,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {},
                          ),
                          Text('Selected technician',
                              style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold)),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              setModalState(() {
                                selectedTech.clear();
                              });
                              setState(() {
                                selectedTech.clear();
                              });
                            },
                            child: Text('Clear', style: GoogleFonts.openSans(fontSize: 18)),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: selectedTech.length,
                            itemBuilder: (BuildContext context, index) {
                              return ListTile(
                                title: Row(
                                  children: [
                                    Text(selectedTech[index]),
                                    Spacer(),
                                    IconButton(
                                        icon: Icon(Icons.clear),
                                        onPressed: () {
                                          setModalState(() {
                                            selectedTech.remove(selectedTech[index]);
                                          });
                                        }),
                                  ],
                                ),
                              );
                            }),
                      ),
                      CustomButton(
                        ontap: () {
                          print(selectedTech);
                          navigateToDetail(selectedTech.length.toString(), selectedTech, widget.post);
                          // Database().addTechnician(selectedTech, widget.docId);
                        },
                        color: Colors.blue,
                        title: 'Simpan',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  navigateToDetail(selectedTechCount, List selectedTechList, DocumentSnapshot post) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPagePenugasanDemo(
                  post: widget.post,
                  docId: widget.docId,
                  selectedTechCount: selectedTech.length,
                  selectedTech: selectedTech,
                )));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
