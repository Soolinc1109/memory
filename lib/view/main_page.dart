import 'package:flutter/material.dart';
import 'package:memorys/themes/extentions.dart';

import 'package:memorys/themes/light_color.dart';
import 'package:memorys/themes/theme.dart';
import 'package:memorys/themes/title_text.dart';
import 'package:memorys/view/account/account_page.dart';
import 'package:memorys/view/account/follwing_page.dart';
import 'package:memorys/view/account/people_page.dart';
import 'package:memorys/view/bottomnavigationbar/bottom_navigation_bar.dart';
import 'package:memorys/view/time_line/post_page.dart';
import 'package:memorys/view/time_line/shop_page.dart';
import 'package:memorys/view/time_line/stylists_page.dart';
import 'package:memorys/view/time_line/time_line_page.dart';
import 'package:memorys/view/time_line/time_line_page.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int homePageSelected = 0;

  List<Widget> pageList = [
    TimeLinePage(),
    ShopPage(),
    StylistsPage(),
    AccountPage(),
  ];

  void onBottomIconPressed(int index) {
    setState(() {
      homePageSelected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        // fit: StackFit.expand,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 30),
                    child: pageList[homePageSelected]),
              )
            ],
          ),
          CustomBottomNavigationBar(
            onIconPresedCallback: onBottomIconPressed,
          )
        ],
      ),
    );
  }
}
