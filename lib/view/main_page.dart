import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/utils/firestore/users.dart';
import 'package:memorys/view/account/account_page.dart';
import 'package:memorys/view/bottomnavigationbar/bottom_navigation_bar.dart';
import 'package:memorys/view/time_line/calendar.dart';
import 'package:memorys/view/time_line/shop_page.dart';
import 'package:memorys/view/time_line/stylist_post_page.dart';
import 'package:memorys/view/time_line/time_line_page.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  final myAccount = FirebaseAuth.instance.currentUser!.uid;

  List<Widget> getPageList(bool isStylist) {
    List<Widget> basePageList = [
      // isStylist ? CustomerPageList() : TimeLinePage(),
      isStylist ? StylistPostPage() : CalendarScreen(),
      HomePage(),
      ShopPage(),
      AccountPage(),
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

    return FutureBuilder(
        future: UserFirestore.getUser(myAccount),
        builder: (context, snapshot) {
          final userData = snapshot.data as Account;

          print(snapshot.data);
          if (!snapshot.hasData) {
            return const SizedBox();
          }
          isStylist = userData.is_stylist;
          List<Widget> pageList = getPageList(isStylist);
          if (myAccount == null) {
            return const SizedBox();
          }
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
        });
  }
}
