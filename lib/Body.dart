import 'package:atana/home2.0.dart';
import 'package:atana/screen/notification.dart';
import 'package:atana/screen/user_page.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int selectedPage = 0;
  List<Widget> pageList = List<Widget>();

  @override
  void initState() {
    pageList.add(Home2());
    pageList.add(NotificationPage());
    pageList.add(UserPage());
    super.initState();
  }

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
          BottomNavigationBarItem(
            icon: Badge(
              badgeContent:
                  Text('2', style: GoogleFonts.openSans(color: Colors.white)),
              badgeColor: Colors.blue,
              animationType: BadgeAnimationType.fade,
              child: FaIcon(FontAwesomeIcons.solidBell),
            ),
            label: 'Notifikasi',
          ),
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
    });
  }
}
