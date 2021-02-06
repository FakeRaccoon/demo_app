import 'package:atana/Home.dart';
import 'package:atana/screen/NotificationScreen.dart';
import 'package:atana/screen/UserPage.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int selectedPage = 0;
  List<Widget> pageList = [];

  SharedPreferences sharedPreferences;

  @override
  void initState() {
    pageList.add(Home());
    pageList.add(UserPage());
    super.initState();
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    getSharedPref();
  }

  Future getSharedPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final getName = sharedPreferences.getString('name');
    if (getName != null) {
      setState(() {
        username = getName;
      });
    }
  }

  String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedPage,
        children: pageList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.home),
            label: 'Home',
          ),
          // BottomNavigationBarItem(
          //   icon: StreamBuilder<QuerySnapshot>(
          //     stream: FirebaseFirestore.instance
          //         .collection('Users')
          //         .doc(username)
          //         .collection('notifications')
          //         .where('read', isEqualTo: false)
          //         .snapshots(),
          //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return FaIcon(FontAwesomeIcons.solidBell);
          //       }
          //       if (snapshot.data.docs.length == 0 || snapshot.data == null) {
          //         return FaIcon(FontAwesomeIcons.solidBell);
          //       }
          //       return Badge(
          //         badgeContent: Text(snapshot.data.docs.length.toString(), style: TextStyle(color: Colors.white)),
          //         child: FaIcon(FontAwesomeIcons.solidBell),
          //       );
          //     },
          //   ),
          //   label: 'Notifikasi',
          // ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidUser),
            label: 'User',
          ),
        ],
        currentIndex: selectedPage,
        selectedItemColor: Colors.blue,
        onTap: onItemTapped,
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedPage = index;
      if (selectedPage == 0) {
        FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
        FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
      }
      if (selectedPage == 1) {
        FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
        FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
      }
      if (selectedPage == 2) {
        FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
        FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
      }
    });
  }
}
