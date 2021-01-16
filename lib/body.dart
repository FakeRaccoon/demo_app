import 'package:atana/Home.dart';
import 'package:atana/screen/notification.dart';
import 'package:atana/screen/UserPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int selectedPage = 0;
  List<Widget> pageList = List<Widget>();

  @override
  void initState() {
    pageList.add(Home());
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
            icon: FaIcon(FontAwesomeIcons.solidBell),
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
