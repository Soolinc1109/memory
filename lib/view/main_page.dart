import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/utils/firestore/users.dart';
import 'package:memorys/view/userPageView/account/account_page.dart';
import 'package:memorys/view/userPageView/bottomnavigationbar/bottom_navigation_bar.dart';
import 'package:memorys/view/shopview/shop_account_page.dart';
import 'package:memorys/view/shopview/shop_stylist_page.dart';
import 'package:memorys/view/userPageView/calendar.dart';
import 'package:memorys/view/userPageView/stylist_post_page.dart';
import 'package:memorys/view/userPageView/time_line_page.dart';
import 'package:memorys/view/stylistView/user_list_page.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  final myAccount = FirebaseAuth.instance.currentUser!.uid;

  List<Widget> getPageList(bool isStylist, bool isOwner) {
    List<Widget> basePageList = [
      //1
      if (!isStylist && !isOwner)
        CalendarScreen()
      else if (!isOwner)
        StylistPostPage()
      else
        ShopStylistPage(),

      //2
      if (!isStylist && !isOwner)
        HomePage()
      else if (!isOwner)
        UserListView()
      else
        ShopStylistPage(),

      //3
      if (!isStylist && !isOwner)
        AccountPage()
      else if (!isOwner)
        AccountPage()
      else
        ShopAccountPage(),
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
    bool isOwner = false;

    return FutureBuilder(
        future: UserFirestore.getUser(myAccount),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: SizedBox(
                    width: 50.0, // インジケーターの幅
                    height: 50.0, // インジケーターの高さ
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.grey[200], // インジケーターの背景色
                      strokeWidth: 5, // インジケーターの線の太さ
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 234, 117, 255)), // インジケーターの色
                    ),
                  ),
                ) // データがない場合、インジケーターを表示

                ); // データがない場合、インジケーターを表示
          }
          final userData = snapshot.data as Account;
          isStylist = userData.is_stylist;
          isOwner = userData.is_owner;
          List<Widget> pageList = getPageList(isStylist, isOwner);
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
