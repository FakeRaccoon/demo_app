import 'dart:convert';
import 'dart:io';

import 'package:atana/model/item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../root.dart';

class Database {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult = await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);

    return 'signInWithGoogle succeeded: $user';
  }

  void signOutGoogle() async {
    auth.signOut().then((value) {
      Get.off(Root());
    });
  }

  Future<void> getUserUid(String uid, bool isManagerial, String status, String nama) async {
    final User user = auth.currentUser;
    final uid = user.uid;
    bool isAdmin = false;
    String getGoogleUsername = FirebaseAuth.instance.currentUser.displayName.toString();

    if (uid != null) {
      firestore.collection('Users').doc(uid).update({
        'nama': nama,
        'userName': getGoogleUsername,
        'admin': isAdmin,
        'managerial': isManagerial,
        'status': status
      });
      print('$uid added');
    } else {
      print('Error');
    }
  }

  Future<void> signInAnon() async {
    await FirebaseAuth.instance.signInAnonymously();
  }

  Future<void> addItem(
      String teknisi, String valItem, String valKota, tanggalPinjam, tanggalKembali, controller) async {
    FirebaseFirestore.instance.collection('Items').add({
      'timeStamp': DateTime.now(),
      'teknisi': teknisi,
      'name': valItem,
      'tanggalPinjam': tanggalPinjam,
      'tanggalKembali': tanggalKembali,
      'kota': valKota,
      'customer': controller,
      'isApproved': false,
    });
  }

  Future<void> addUserDetail(docId, status, nama, bool managerial) async {
    firestore.collection('Users').doc(docId).set({'status': status, 'nama': nama, 'managerial': managerial});
  }

  Future<void> approve(docId, approvedBy) async {
    firestore.collection('Items').doc(docId).update({'approvedBy': approvedBy, 'isApproved': true});
  }

  Future<void> reject(docId, rejectedBy) async {
    firestore.collection('Items').doc(docId).update({'rejectedBy': rejectedBy, 'isRejected': true});
  }

  Future<void> doesRegistered(String name) async {}

  Future<void> ajukanPermintaanDemo(String provinsi, String kota, String kecamatan, String barang,
      String tanggalPerkiraan, String tipeDemo, String salesPengaju, bool isApproved) async {
    firestore.collection('Items').add({
      'province': provinsi,
      'city': kota,
      'district': kecamatan,
      'tanggal_perkiraan': tanggalPerkiraan,
      'barang': barang,
      'tipe_demo': tipeDemo,
      'isApproved': isApproved,
      'isRejected': false,
      'kendaraan': '',
      'sales_pengaju': salesPengaju,
      'perlu_sopir': false,
      'teknisi': ['', ''],
      'time_stamp': DateTime.now(),
      'perkiraan_biaya': '',
    });
  }

  Future<void> penugasanDemo(
    docId,
    transport,
    tanggalBerangkat,
    tanggalKembali,
    estimasiBiaya,
    deskripsiBiaya,
    technician,
  ) async {
    firestore.collection('Items').doc(docId).update({
      'transport': transport,
      'tanggalBerangkat': tanggalBerangkat,
      'tanggalKembali': tanggalKembali,
      'estimasiBiaya': estimasiBiaya,
      'deskripsiBiaya': deskripsiBiaya,
      'editedByKepalaTeknisi': true,
      'teknisi': technician
    });
  }

  Future<void> addTechnician(technician, docId) async {
    await firestore.collection('Items').doc(docId).update({'teknisi': technician});
  }

  Future<void> deleteDoc(docId) async {
    await firestore.collection('Items').doc(docId).delete();
  }
}
