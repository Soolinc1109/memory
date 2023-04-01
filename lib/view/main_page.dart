import 'package:flutter/material.dart';
import 'package:memorys/utils/authentication.dart';
import 'package:memorys/view/account/account_page.dart';
import 'package:memorys/view/bottomnavigationbar/bottom_navigation_bar.dart';
import 'package:memorys/view/time_line/calendar.dart';
import 'package:memorys/view/time_line/customer_page.dart';
import 'package:memorys/view/time_line/home_page.dart';
import 'package:memorys/view/time_line/shop_page.dart';
import 'package:memorys/view/time_line/time_line_page.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  List<Widget> getPageList(bool isStylist) {
    List<Widget> basePageList = [
      isStylist ? CustomerPageList() : TimeLinePage(),
      ShopPage(),
      AccountPage(),
      CalendarScreen(),
      HomePage(),
    ];
    return basePageList;
  }

  void onBottomIconPressed(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isStylist = false;
    //  = Authentication.myAccount!.is_stylist =
    List<Widget> pageList = getPageList(isStylist);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 30),
              child: pageList[selectedIndex],
            ),
          ),
          CustomBottomNavigationBar(
            onIconPresedCallback: onBottomIconPressed,
          ),
        ],
      ),
    );
  }
}
