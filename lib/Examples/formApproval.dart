

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FormApproval extends StatefulWidget {
  @override
  _FormApprovalState createState() => _FormApprovalState();
}

bool checked = false;

class _FormApprovalState extends State<FormApproval> {


  String getDocID;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Items')
            .where('isApproved', isEqualTo: false)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print('Error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (_, index) {
                      return InkWell(

                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Card(
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(snapshot.data.docs[index].data()['barang']),
                                  Text(snapshot.data.docs[index].data()['kota']),
                                  Text(snapshot.data.docs[index].data()['pengaju']),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          );
        },
      ),
    );
  }
}

// return ListView(
//   children:
//       snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
//     return Card(
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             Text(documentSnapshot.data()['name']),
//             Text(documentSnapshot.data()['customer']),
//             Text(documentSnapshot.data()['teknisi']),
//           ],
//         ),
//       ),
//     );
//   }).toList(),
// );
