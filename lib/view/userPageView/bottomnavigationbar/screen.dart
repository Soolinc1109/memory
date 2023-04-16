import 'package:flutter/material.dart';
import 'package:memorys/view/userPageView/account/account_page.dart';
import 'package:memorys/view/userPageView/calendar.dart';
import 'package:memorys/view/userPageView/home_page.dart';
import 'package:memorys/view/userPageView/time_line_page.dart';

class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);

  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  int selectedIndex = 0;
  List<Widget> pageList = [
    HomePage(),
    TimeLinePage(),
    AccountPage(),
    CalendarScreen(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              size: 30,
            ),
            activeIcon: Icon(
              Icons.home_outlined,
              color: Colors.orange,
              size: 30,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: 30,
            ),
            activeIcon: Icon(
              Icons.search,
              color: Colors.orange,
              size: 30,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite_border,
              size: 30,
            ),
            activeIcon: Icon(
              Icons.favorite,
              color: Colors.orange,
              size: 30,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.perm_identity_outlined,
              size: 30,
            ),
            activeIcon: Icon(
              Icons.perm_identity_outlined,
              color: Colors.orange,
              size: 30,
            ),
            label: '',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}
