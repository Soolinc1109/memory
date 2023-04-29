import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/model/shop/shop.dart';
import 'package:memorys/model/shop/stylistpost.dart';
import 'package:memorys/utils/authentication.dart';
import 'package:memorys/utils/color.dart';
import 'package:memorys/utils/firestore/shops.dart';
import 'package:memorys/utils/firestore/stylistposts.dart';
import 'package:memorys/view/userPageView/account/edit_account_page.dart';
import 'package:memorys/view/startup/login_page.dart';
import 'package:memorys/view/userPageView/before_after.dart';
import 'package:memorys/view/userPageView/shop_page.dart';
import 'package:memorys/view/userPageView/upload_favorite_hair_page.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: AppColors.thirdColor,
      ),
      home: AccountPage(),
//      home: const NestedScrollViewSamplePage(),
    );
  }
}

const _tabs = <Widget>[
  Tab(
      icon: Icon(
    Icons.filter,
    color: Colors.black,
  )),
  Tab(
      icon: Icon(
    Icons.content_cut,
    color: Colors.black,
  )),
];

/// Sticky TabBarを実現するページ
class AccountPage extends StatefulWidget {
  bool? isFollwing;
  // final Account? userInfo;
  AccountPage({Key? key, this.isFollwing}) : super(key: key);
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Account myAccount = Authentication.myAccount!;
  bool _isFirstBuild = true;

  List<StylistPost> _posts = [];

  static final _firestoreInstance = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstBuild) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _isFirstBuild = false;
        });
      });
    }
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    List<String>? favoriteimage = [
      myAccount.favorite_image_0!,
      myAccount.favorite_image_1!,
      myAccount.favorite_image_2!,
      myAccount.favorite_image_3!,
      myAccount.favorite_image_4!,
    ];
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        // ここでDrawerウィジェットをカスタマイズします。
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('設定'),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
              ),
            ),
            ListTile(
              title: Text('プロフィール編集'),
              onTap: () async {
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserUpdatePage(
                            account: myAccount,
                          )),
                );
                if (result == true) {
                  setState(() {});
                }
                // ここでタップ時の処理を記述します。
              },
            ),
            ListTile(
              title: Text('ログアウト'),
              onTap: () async {
                bool shouldLogout = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('確認'),
                      content: Text('本当にログアウトしますか？'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('いいえ'),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                        ),
                        TextButton(
                          child: Text('はい'),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                        ),
                      ],
                    );
                  },
                );
                if (shouldLogout) {
                  Authentication.signOut();
                  while (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                }
              },
            ),
            ListTile(
              title: Text('ガイド'),
              onTap: () async {},
            ),
            ListTile(
              title: Text('よくある質問'),
              onTap: () async {},
            ),
            ListTile(
              title: Text('プライバシーポリシー'),
              onTap: () async {},
            ),
          ],
        ),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black, size: 30),
          backgroundColor: Colors.white,
          title: Text(
            "",
            style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: DefaultTabController(
        length: _tabs.length, // This is the number of tabs.
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(right: 15, left: 15, top: 20),
                      height: 140,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  CircleAvatar(
                                    radius: 35,
                                    foregroundImage:
                                        NetworkImage(myAccount.imagepath),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      //ステイトフルウィジェットのクラスをステイトのクラスで使おうとするときにwidget.が必要！
                                      myAccount.name,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 68.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '前回美容室に行ってから',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '23',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 35),
                                        ),
                                        Text(
                                          '日経ってます',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyTabBarDelegate(
                  TabBar(
                    tabs: <Widget>[
                      Tab(
                        child: Text(
                          'Memory',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          '予約履歴',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Center(
                          child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    "あなたがなりたい髪型",
                                    style: TextStyle(
                                      fontSize: 17, // 文字サイズを大きくする (例: 24)
                                      fontWeight: FontWeight.bold, // 文字を太くする
                                    ),
                                  ),
                                )
                              ],
                            ),
                            InkWell(
                                onTap: () async {
                                  var result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UploadFavoriteHairPage(
                                              account: myAccount,
                                            )),
                                  );
                                  if (result == true) {
                                    setState(() {});
                                  }
                                  // ここでタップ時の処理を記述します。
                                },
                                child: SlideImage(
                                  favoriteHairImages: favoriteimage,
                                  screenWidth: screenWidth,
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    "あなたのmemory",
                                    style: TextStyle(
                                      fontSize: 17, // 文字サイズを大きくする (例: 24)
                                      fontWeight: FontWeight.bold, // 文字を太くする
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              height: 100,
                              width: 350,
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: _isFirstBuild
                                      ? StylistPostFirestore.posts
                                          .where('customer_id',
                                              isEqualTo: myAccount.id)
                                          // .orderBy('created_at', descending: true)
                                          .snapshots()
                                      : null,
                                  builder: (context, postSnapshot) {
                                    if (postSnapshot.hasData &&
                                        !postSnapshot.data!.docs.isEmpty) {
                                      List<String> postAccountIds = [];
                                      postSnapshot.data!.docs.forEach((doc) {
                                        Map<String, dynamic> data =
                                            doc.data() as Map<String, dynamic>;
                                        if (!postAccountIds.contains(
                                            data['post_account_id'])) {
                                          postAccountIds
                                              .add(data['post_account_id']);
                                        }
                                      });
                                      Map<String, dynamic> data =
                                          postSnapshot.data!.docs[0].data()
                                              as Map<String, dynamic>;

                                      var visitTime = data['created_at'];

                                      DateTime visitDateTime =
                                          visitTime.toDate();

                                      final month = DateFormat('M月')
                                          .format(visitDateTime);
                                      final day =
                                          DateFormat('d').format(visitDateTime);
                                      return ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              postSnapshot.data!.docs.length +
                                                  1,
                                          itemBuilder: (context, index) {
                                            if (index == 0) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4.0,
                                                    right: 5.0,
                                                    bottom: 15.0,
                                                    top: 5.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          7.0),
                                                  child: Container(
                                                    width: 80,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          height: 25,
                                                          color: Color.fromARGB(
                                                              255,
                                                              171,
                                                              223,
                                                              173), // Set the color of the upper container here
                                                          child: Center(
                                                              child: Text(
                                                            month,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        89,
                                                                        162,
                                                                        92)),
                                                          )),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            color: Color.fromARGB(
                                                                255,
                                                                221,
                                                                238,
                                                                200), // Set the color of the lower container here
                                                            child: Center(
                                                                child: Text(
                                                              day,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 22,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          89,
                                                                          162,
                                                                          92)),
                                                            )),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              Map<String, dynamic> data1 =
                                                  postSnapshot
                                                          .data!.docs[index - 1]
                                                          .data()
                                                      as Map<String, dynamic>;

                                              StylistPost stylistpost = StylistPost(
                                                  carte_id: data['carte_id'],
                                                  shop_id: data1['shop_id'],
                                                  customer_id:
                                                      data1['customer_id'],
                                                  poster_image_url:
                                                      myAccount.imagepath,
                                                  before_image:
                                                      data1['before_image'],
                                                  message_for_customer: data1[
                                                      'message_for_customer'],
                                                  after_image:
                                                      data1['after_image'],
                                                  postAccountId:
                                                      data1['post_account_id'],
                                                  createdTime:
                                                      data1['created_at']);

                                              final beforeimageUrl =
                                                  stylistpost.before_image;

                                              final afterimageUrl =
                                                  stylistpost.after_image;

                                              return beforeimageUrl != null
                                                  ? InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  BeforeAfterDetail(
                                                                    beforeimage:
                                                                        stylistpost
                                                                            .before_image,
                                                                    afterimage:
                                                                        stylistpost
                                                                            .after_image,
                                                                    stylistpost:
                                                                        stylistpost,
                                                                  )),
                                                        );
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 4.0,
                                                                right: 5.0,
                                                                bottom: 5.0,
                                                                top: 5.0),
                                                        child: Column(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          7.0),
                                                              child: Container(
                                                                width: 80,
                                                                height: 80,
                                                                child: Row(
                                                                  children: [
                                                                    AspectRatio(
                                                                      aspectRatio:
                                                                          0.5,
                                                                      child: Image
                                                                          .network(
                                                                        beforeimageUrl[
                                                                            0],
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                    AspectRatio(
                                                                      aspectRatio:
                                                                          0.5,
                                                                      child: Image
                                                                          .network(
                                                                        afterimageUrl![
                                                                            0],
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : Container();
                                            }
                                          });
                                    } else {
                                      return Container(
                                        child: Text('まだカルテがありません'),
                                      );
                                    }
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    "ミディアムボブ",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: SizedBox(
                                  height: 210,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                              ),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/%E3%80%90%E3%82%B7%E3%83%A7%E3%83%BC%E3%83%88%E7%B7%A8%E3%80%91%E6%AF%9B%E9%87%8F%E3%81%8B%E3%82%99%E5%A4%9A%E3%81%84%E3%81%BB%E3%82%9A%E3%81%A3%E3%81%A1%E3%82%83%E3%82%8A%E3%81%95%E3%82%93%E3%81%93%E3%81%9D%E4%BC%BC%E5%90%88%E3%81%86%E2%99%AA%E5%A4%8F%E3%82%89%E3%81%97%E3%81%84%E9%AB%AA%E5%9E%8B5%E3%81%A4%20_%204MEEE.jpeg?alt=media&token=a20fce81-bef0-44d2-80f6-03b01b6c2a41"),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            width: 120,
                                            height: 160,
                                          ),
                                          Container(
                                            color: Colors.white,
                                            width: 120,
                                            height: 50, // 任意の高さに設定
                                            child: Padding(
                                              padding: EdgeInsets.all(4),
                                              child: Column(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: Text(
                                                      "bob",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Align(
                                                        alignment: Alignment
                                                            .bottomLeft,
                                                        child: Text(
                                                          "1位",
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      54,
                                                                      171,
                                                                      244),
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Icon(Icons.favorite,
                                                          color: Color.fromARGB(
                                                              255,
                                                              208,
                                                              208,
                                                              208))
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/%E5%89%8D%E9%AB%AA%E9%95%B7%E3%82%81%E3%81%AE%E9%9F%93%E5%9B%BD%E9%A2%A8%E5%A4%96%E3%83%8F%E3%83%8D%E3%83%9F%E3%83%86%E3%82%99%E3%82%A3%E3%82%A2%E3%83%A0%EF%BC%9AL109234638%EF%BD%9C%E3%82%AB%E3%82%99%E3%83%AC%E3%83%AA%E3%82%A2%E3%82%A8%E3%83%AC%E3%82%AB%E3%82%99%E3%83%B3%E3%83%86%20%E6%A0%84%E5%BA%97(GALLARIA%20Elegante)%E3%81%AE%E3%83%98%E3%82%A2%E3%82%AB%E3%82%BF%E3%83%AD%E3%82%AF%E3%82%99%EF%BD%9C%E3%83%9B%E3%83%83%E3%83%88%E3%83%98%E3%82%9A%E3%83%83%E3%83%8F%E3%82%9A%E3%83%BC%E3%83%92%E3%82%99%E3%83%A5%E3%83%BC%E3%83%86%E3%82%A3%E3%83%BC.jpeg?alt=media&token=4e3b1f7a-69a5-429b-9b59-454b8c2869f0"),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            width: 120,
                                            height: 160,
                                          ),
                                          Container(
                                            color: Colors.white,
                                            width: 120,
                                            height: 50, // 任意の高さに設定
                                            child: Padding(
                                              padding: EdgeInsets.all(4),
                                              child: Column(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: Text(
                                                      "bob",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Align(
                                                        alignment: Alignment
                                                            .bottomLeft,
                                                        child: Text(
                                                          "2位",
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      54,
                                                                      171,
                                                                      244),
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Icon(Icons.favorite,
                                                          color: Color.fromARGB(
                                                              255,
                                                              208,
                                                              208,
                                                              208))
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/%E5%A4%A7%E4%BA%BA%E3%81%AB%E5%90%88%E3%81%86%E9%BB%92%E9%AB%AA%E3%83%9E%E3%83%83%E3%82%B7%E3%83%A5%E3%82%A6%E3%83%AB%E3%83%95%E7%89%B9%E9%9B%86%E3%80%82%E5%B0%8F%E9%A1%94%E8%A6%8B%E3%81%9B%E3%82%92%E5%8F%B6%E3%81%88%E3%82%8B%E7%94%98%E8%BE%9B%E3%83%98%E3%82%A2%E3%82%92%E3%83%AC%E3%83%B3%E3%82%AF%E3%82%99%E3%82%B9%E5%88%A5%E3%81%A6%E3%82%99%E3%81%93%E3%82%99%E7%B4%B9%E4%BB%8B%20_%20folk.png?alt=media&token=e546aaf4-e66a-46cf-bbbf-5c46f7345556"),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            width: 120,
                                            height: 160,
                                          ),
                                          Container(
                                            color: Colors.white,
                                            width: 120,
                                            height: 50, // 任意の高さに設定
                                            child: Padding(
                                              padding: EdgeInsets.all(4),
                                              child: Column(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: Text(
                                                      "bob",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Align(
                                                        alignment: Alignment
                                                            .bottomLeft,
                                                        child: Text(
                                                          "3位",
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      54,
                                                                      171,
                                                                      244),
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Icon(Icons.favorite,
                                                          color: Color.fromARGB(
                                                              255,
                                                              208,
                                                              208,
                                                              208))
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/%E5%8F%AF%E6%84%9B%E3%81%84%E3%81%AE%E3%81%AB%E5%A4%A7%E4%BA%BA%E3%81%A3%E3%81%BB%E3%82%9A%E3%81%84%E3%80%82%E3%83%9F%E3%83%86%E3%82%99%E3%82%A3%E3%82%A2%E3%83%A0%E3%83%98%E3%82%A2%E3%81%AE%E9%AB%AA%E5%9E%8B%E3%81%A6%E3%82%99%E5%8F%B6%E3%81%88%E3%82%8B%E5%A5%B3%E5%BA%A6%E4%B8%8A%E3%81%8B%E3%82%99%E3%82%8B%E4%BB%95%E4%B8%8A%E3%81%8B%E3%82%99%E3%82%8A%E3%82%92%E3%81%93%E3%82%99%E7%B4%B9%E4%BB%8B%20_%20folk.png?alt=media&token=5c81d034-056c-4723-88c5-c4acc701053b"),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            width: 120,
                                            height: 160,
                                          ),
                                          Container(
                                            color: Colors.white,
                                            width: 120,
                                            height: 50, // 任意の高さに設定
                                            child: Padding(
                                              padding: EdgeInsets.all(4),
                                              child: Column(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: Text(
                                                      "bob",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Align(
                                                        alignment: Alignment
                                                            .bottomLeft,
                                                        child: Text(
                                                          "4位",
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      54,
                                                                      171,
                                                                      244),
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Icon(Icons.favorite,
                                                          color: Color.fromARGB(
                                                              255,
                                                              208,
                                                              208,
                                                              208))
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: StylistPostFirestore.posts
                            .where('customer_id', isEqualTo: myAccount.id)
                            // .orderBy('created_at', descending: true)
                            .snapshots(),
                        builder: (context, postSnapshot) {
                          if (!postSnapshot.hasData ||
                              postSnapshot.data!.docs.isEmpty) {
                            print(postSnapshot);
                            return Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Container(
                                child: Text(
                                  'まだお店に行ってません',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            );
                          }

                          // postSnapshot.data.docsをList<QueryDocumentSnapshot>型の変数に格納
                          List<QueryDocumentSnapshot> postDocs =
                              postSnapshot.data!.docs;

                          // 各ドキュメントのデータをList<Map<String, dynamic>>型の変数に格納
                          List<Map<String, dynamic>> postDataList = postDocs
                              .map((doc) => doc.data() as Map<String, dynamic>)
                              .toList();
                          List<String> shopIds = postDataList
                              .map((data) => data['shop_id'] as String)
                              .toList();
                          print(shopIds);
                          return StreamBuilder<List<Shop>>(
                              stream: ShopFirestore.getShops(shopIds),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text("エラー: ${snapshot.error}");
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator(); // ここを追加
                                }
                                List<Shop> shopList = [];
                                if (snapshot.hasData) {
                                  // ここを変更
                                  shopList = snapshot.data!;
                                }

                                shopList = snapshot.data!;
                                return ListView.builder(
                                  itemCount: postDataList.length,
                                  itemBuilder: (context, index) {
                                    print(shopList[index].logoImage);
                                    print('=========================');
                                    if (shopList.isEmpty) {
                                      return CircularProgressIndicator(); // ここを追加
                                    }
                                    Map<String, dynamic> postData =
                                        postDataList[index];
                                    print(postData);
                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          child: InkWell(
                                            onTap: (() {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ShopPage(
                                                          shopId:
                                                              shopList[index]
                                                                  .id,
                                                        )),
                                              );
                                            }),
                                            child: Container(
                                              width: 360,
                                              child: Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                    child: Image.network(
                                                      shopList[index]
                                                          .logoImage, // ここを変更
                                                      width: 150,
                                                      height: 100,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 2,
                                                                horizontal: 6),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    20),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    20),
                                                          ),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              DateFormat('M月d日')
                                                                  .format(postData[
                                                                          'created_at']
                                                                      .toDate()), // Change this line
                                                              style: TextStyle(
                                                                fontSize: 19,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: AppColors
                                                                    .secondaryColor,
                                                              ),
                                                            ),
                                                            Text(
                                                              'に来店しました', // Change this line
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: AppColors
                                                                    .secondaryColor,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      Text(
                                                        postData[
                                                            'message_for_customer'], // ここを変更
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 1,
                                                blurRadius: 5,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    );
                                  },
                                );
                              });
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _StickyTabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Color.fromARGB(255, 254, 254, 254), child: tabBar);
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}

class SlideImage extends StatefulWidget {
  final List<String> favoriteHairImages;
  final screenWidth;
  const SlideImage(
      {Key? key, required this.favoriteHairImages, required this.screenWidth})
      : super(key: key);

  @override
  State<SlideImage> createState() => _SlideImageState();
}

class _SlideImageState extends State<SlideImage> {
  @override
  int activeIndex = 0;
  Widget buildImage(beforepath, index) {
    if (beforepath.isEmpty) {
      return Container(); // 空のコンテナを返す
    }

    return Row(
      children: [
        Column(
          children: [
            Container(
              height: 200,
              width: widget.screenWidth / 1.6,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10), // 角を丸くする
                image: DecorationImage(
                  image: NetworkImage(beforepath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: widget.favoriteHairImages.length,
        //エフェクトはドキュメントを見た方がわかりやすい
        effect: JumpingDotEffect(
            dotHeight: 1,
            dotWidth: 1,
            activeDotColor: Color.fromARGB(255, 111, 190, 255),
            dotColor: Colors.black12),
      );
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        Align(
          alignment: Alignment.center,
          child: CarouselSlider.builder(
            itemCount: widget.favoriteHairImages.length,
            itemBuilder: (context, index, realIndex) {
              final imagePath = widget.favoriteHairImages[index];
              return buildImage(imagePath, index);
            },
            options: CarouselOptions(
              height: 220,
              initialPage: 0,
              viewportFraction: 0.64,
              onPageChanged: (index, reason) => setState(
                () {
                  activeIndex = index;
                },
              ),
            ),
          ),
        ),
        buildIndicator(),
      ]),
    );
  }
}

Stream<String>? getShopLogoImageStream(String shopId) {
  try {
    print(shopId);
    final aiu = FirebaseFirestore.instance
        .collection('Shop')
        .doc(shopId)
        .snapshots()
        .map((docSnapshot) => Shop.fromDocumentSnapshot(docSnapshot).logoImage);
    print("せいこう");
    return aiu;
  } catch (e) {
    print("しっぱい");
    return null;
  }
}
