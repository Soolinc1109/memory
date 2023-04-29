import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/model/shop/menu.dart';
import 'package:memorys/model/shop/shop.dart';
import 'package:memorys/model/shop/stylistpost.dart';
import 'package:memorys/utils/authentication.dart';
import 'package:memorys/utils/color.dart';
import 'package:memorys/utils/firestore/shops.dart';
import 'package:memorys/utils/firestore/users.dart';
import 'package:memorys/view/shopview/create_menu_page.dart';
import 'package:memorys/view/shopview/create_shop_page.dart';
import 'package:memorys/view/shopview/create_stylist_account_page.dart';
import 'package:memorys/view/shopview/edit_shop_menu.dart';
import 'package:memorys/view/shopview/upload_shop_front_view_page.dart';
import 'package:memorys/view/stylistView/edit_shop_info_page.dart';
import 'package:memorys/view/userPageView/account/account_page.dart';
import 'package:memorys/view/shopview/shop_preview_page.dart';
import 'package:memorys/view/startup/login_page.dart';
import 'package:memorys/view/userPageView/style_detail_page.dart';
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
      home: ShopAccountPage(),
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
  Tab(
      icon: Icon(
    Icons.content_cut,
    color: Colors.black,
  )),
];

/// Sticky TabBarを実現するページ
class ShopAccountPage extends StatefulWidget {
  bool? isFollwing;
  // final Account? userInfo;
  ShopAccountPage({Key? key, this.isFollwing}) : super(key: key);
  @override
  State<ShopAccountPage> createState() => _ShopAccountPageState();
}

class _ShopAccountPageState extends State<ShopAccountPage> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _showFullText = false;
  bool _showMoreButton = false;
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

  Future<List<Menu>> _fetchMenus() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Shop')
        .doc(myAccount.shopId)
        .collection('service')
        .get();

    return snapshot.docs.map((doc) => Menu.fromDocument(doc)).toList();
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<Shop>(
        stream: ShopFirestore.getShop(myAccount.shopId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              body: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 180,
                    ),
                    Container(
                      child: Text(
                        "お店の情報を登録しよう！",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                        height: 200,
                        child: Image(
                          image: NetworkImage(
                              "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/undraw_add_friends_re_3xte.png?alt=media&token=f1055f15-a980-4658-ac7c-77bfd76462c2"),
                        )),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      child: Text(
                        "お店の情報を登録することで\n日々の来店数や、来客者の情報が視覚的に\n把握できるようになります",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                        onTap: () async {
                          var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CreateShopPage()),
                          );
                          if (result == true) {
                            setState(() {});
                          }
                        },
                        child: Container(
                            height: 40,
                            width: screenWidth / 2.3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15), // 角丸を追加
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.thirdColor, // グラデーションの開始色
                                  AppColors.secondaryColor, // グラデーションの終了色
                                ],
                              ),
                            ),
                            child: Center(
                              child: Text('お店を登録',
                                  style: TextStyle(
                                    fontSize: 20, // フォントサイズを大きくする
                                    fontWeight: FontWeight.bold, // フォントを太くする
                                    color: Colors.white, // テキストの色を白にする
                                  )),
                            ))),
                  ],
                ),
              ),
            );
          }
          if (snapshot.hasError) {
            return Text("エラー: ${snapshot.error}");
          }
          Shop shop = snapshot.data!;
          final String _text = shop.shopIntroduction;
          List<String>? favoriteimage = [
            shop.shop_front_image_0,
            shop.shop_front_image_1,
            shop.shop_front_image_2,
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
                    title: Text('お店情報の編集'),
                    onTap: () async {
                      var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditShopInfoPage(
                                  shopInfo: shop,
                                )),
                      );
                      if (result == true) {
                        setState(() {});
                      }
                      // ここでタップ時の処理を記述します。
                    },
                  ),
                  ListTile(
                    title: Text('オーナー情報'),
                    onTap: () async {
                      var result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AccountPage()),
                      );
                      if (result == true) {
                        setState(() {});
                      }
                      // ここでタップ時の処理を記述します。
                    },
                  ),
                  ListTile(
                    title: Text('ショッププレビュー'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShopPreviewPage()),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('メニュー追加'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateMenuPage()),
                      );
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
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      }
                    },
                  )
                ],
              ),
            ),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(30),
              child: AppBar(
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.black, size: 30),
                backgroundColor: Colors.white,
              ),
            ),
            body: DefaultTabController(
              length: _tabs.length, // This is the number of tabs.
              child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  print(_text);
                  return <Widget>[
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Container(
                            color: Colors.white,
                            padding:
                                EdgeInsets.only(right: 15, left: 15, top: 20),
                            height: 250,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 90,
                                        child: Row(
                                          children: [
                                            shop.logoImage == ''
                                                ? InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                EditShopInfoPage(
                                                                  shopInfo:
                                                                      shop,
                                                                )),
                                                      );
                                                    },
                                                    child: CircleAvatar(
                                                      radius: 36,
                                                      backgroundColor:
                                                          AppColors.thirdColor,
                                                    ),
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                EditShopInfoPage(
                                                                  shopInfo:
                                                                      shop,
                                                                )),
                                                      );
                                                    },
                                                    child: CircleAvatar(
                                                      radius: 36,
                                                      foregroundImage:
                                                          NetworkImage(
                                                              shop.logoImage),
                                                    ),
                                                  ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Container(
                                              width: 220,
                                              child: Text(
                                                  //ステイトフルウィジェットのクラスをステイトのクラスで使おうとするときにwidget.が必要！
                                                  shop.name,
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  maxLines: 3, // ここで最大行数を指定します。
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ],
                                        ),
                                      ),
                                      _text == ""
                                          ? InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditShopInfoPage(
                                                            shopInfo: shop,
                                                          )),
                                                );
                                              },
                                              child: Center(
                                                  child: Container(
                                                height: 100,
                                                width: screenWidth / 1.4,
                                                padding: EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          AppColors.thirdColor,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Center(
                                                    child: Text(
                                                  'お店の情報を登録する',
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.thirdColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                )),
                                              )))
                                          : LayoutBuilder(
                                              builder: (BuildContext context,
                                                  BoxConstraints constraints) {
                                                final textPainter = TextPainter(
                                                    text: TextSpan(
                                                      text: _text,
                                                      style: DefaultTextStyle
                                                              .of(context)
                                                          .style
                                                          .copyWith(height: 1),
                                                    ),
                                                    textDirection:
                                                        TextDirection.ltr,
                                                    maxLines: 2)
                                                  ..layout(
                                                    maxWidth:
                                                        constraints.maxWidth,
                                                  );

                                                if (!_showFullText &&
                                                    !_showMoreButton &&
                                                    textPainter
                                                        .didExceedMaxLines) {
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    setState(() {
                                                      _showMoreButton = true;
                                                    });
                                                  });
                                                }

                                                return Text(
                                                  _text,
                                                  maxLines:
                                                      _showFullText ? 6 : 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(height: 1),
                                                );
                                              },
                                            ),
                                      if (_showMoreButton)
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _showFullText = !_showFullText;
                                            });
                                          },
                                          child: Text(
                                            _showFullText ? '閉じる' : 'もっと見る',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.secondaryColor,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
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
                                'スタイリスト',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                'メニュー',
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
                          FutureBuilder(
                              future: _fetchMenus(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<Menu>> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                                if (snapshot.hasError) {
                                  return Center(child: Text('エラーが発生しました'));
                                }
                                List<Menu> menus = snapshot.data!;
                                return SingleChildScrollView(
                                  child: Center(
                                      child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 15),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                "トップフロントビュー",
                                                style: TextStyle(
                                                  fontSize:
                                                      17, // 文字サイズを大きくする (例: 24)
                                                  fontWeight: FontWeight
                                                      .bold, // 文字を太くする
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
                                                        UploadShopFrontViewPage(
                                                          shopaccount: shop,
                                                        )),
                                              );
                                              if (result == true) {
                                                setState(() {});
                                              }
                                              // ここでタップ時の処理を記述します。
                                            },
                                            child: SlideImage(
                                                favoriteHairImages:
                                                    favoriteimage)),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(
                                                "メニュー",
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
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
                                            padding: const EdgeInsets.only(
                                                left: 14.0),
                                            child: SizedBox(
                                              height: 240,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: menus.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  final menu =
                                                      snapshot.data![index];
                                                  return index == 0
                                                      ? Column(
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const StyleDetail()),
                                                                );
                                                              },
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            15),
                                                                  ),
                                                                  image:
                                                                      DecorationImage(
                                                                    image: NetworkImage(
                                                                        menu.menu_image),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                                width: 120,
                                                                height: 170,
                                                              ),
                                                            ),
                                                            Container(
                                                              color:
                                                                  Colors.white,
                                                              width: 120,
                                                              height: 70,
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(2),
                                                                child: Column(
                                                                  children: [
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomLeft,
                                                                      child:
                                                                          Text(
                                                                        menu.name,
                                                                        maxLines:
                                                                            2,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              11,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Align(
                                                                          alignment:
                                                                              Alignment.bottomLeft,
                                                                          child:
                                                                              Text(
                                                                            '￥${menu.price}',
                                                                            style: TextStyle(
                                                                                color: Color.fromARGB(255, 54, 171, 244),
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ),
                                                                        Icon(
                                                                            Icons
                                                                                .favorite,
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
                                                        )
                                                      : Column(
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const StyleDetail()),
                                                                );
                                                              },
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                    image: NetworkImage(
                                                                        menu.menu_image),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                                width: 120,
                                                                height: 170,
                                                              ),
                                                            ),
                                                            Container(
                                                              color:
                                                                  Colors.white,
                                                              width: 120,
                                                              height: 70,
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(2),
                                                                child: Column(
                                                                  children: [
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomLeft,
                                                                      child:
                                                                          Text(
                                                                        menu.name,
                                                                        maxLines:
                                                                            2,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              11,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Align(
                                                                          alignment:
                                                                              Alignment.bottomLeft,
                                                                          child:
                                                                              Text(
                                                                            '￥${menu.price}',
                                                                            style: TextStyle(
                                                                                color: Color.fromARGB(255, 54, 171, 244),
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ),
                                                                        Icon(
                                                                            Icons
                                                                                .favorite,
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
                                                        );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                                );
                              }),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                // .where('is_stylist', isEqualTo: true)
                                .where('shop_id', isEqualTo: shop.id)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              var sty = (snapshot.data?.docs) ?? [];

                              print(sty);
                              print(shop.id);
                              if (!snapshot.hasData) {
                                return Scaffold(
                                  body: Column(
                                    children: [
                                      SizedBox(
                                        height: 200,
                                      ),
                                      Center(child: Text('スタイリストを追加しよう')),
                                    ],
                                  ),
                                  floatingActionButtonLocation:
                                      FloatingActionButtonLocation.endDocked,
                                  floatingActionButton: FloatingActionButton(
                                    onPressed: () async {
                                      var result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CreateStylistAccountPage(
                                                  shopInfo: shop,
                                                )),
                                      );
                                      if (result == true) {
                                        setState(() {});
                                      }
                                    },
                                    backgroundColor: AppColors.thirdColor,
                                    child: Icon(Icons.add),
                                  ),
                                );
                              }
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }

                              List<Account> stylists = snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                    document.data()! as Map<String, dynamic>;

                                return Account(
                                  id: document.id,
                                  name: data['name'],
                                  userId: data['user_id'],
                                  shopId: data['shop_id'],
                                  selfIntroduction: data['self_introduction'],
                                  imagepath: data['image_path'],
                                  createdTime: data['created_time'],
                                  updatedTime: data['updated_time'],
                                  is_stylist: data['is_stylist'],
                                  is_owner: data['is_owner'],
                                  favorite_image_0: data['favorite_image_0'],
                                  favorite_image_1: data['favorite_image_1'],
                                  favorite_image_2: data['favorite_image_2'],
                                  favorite_image_3: data['favorite_image_3'],
                                  favorite_image_4: data['favorite_image_4'],
                                );
                              }).toList();

                              return ListView.builder(
                                itemCount: stylists.length,
                                itemBuilder: (context, index) {
                                  Account stylist = stylists[index];

                                  return Container(
                                    padding: EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          child: Image.network(
                                            stylist.imagepath,
                                            width: 100,
                                            height: 130,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 2,
                                                      horizontal: 6),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(20),
                                                      bottomRight:
                                                          Radius.circular(20),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    stylist.name,
                                                    style: TextStyle(
                                                      fontSize: 19,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors
                                                          .thirdColor, // あなたのAppColors.secondaryColorに変更してください
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  "得意なスタイル：パーマ",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                                Text(
                                                  "施術内容：カット＆トリートメント",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                                // ...
                                                Text(
                                                  "指名料：￥1,000",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                                Text(
                                                  "スタイリスト：${stylist.name}",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ],
                                            ),
                                            Container(
                                              height: 90,
                                              child: InkWell(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text('スタイリスト削除'),
                                                        content: Text(
                                                            'このユーザーをあなたのお店のスタイリストから削除しますか？'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: Text('閉じる'),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                          TextButton(
                                                            child: Text('削除'),
                                                            onPressed:
                                                                () async {
                                                              setState(() {
                                                                _isLoading =
                                                                    true;
                                                              });

                                                              stylist.is_stylist =
                                                                  false;
                                                              stylist.shopId =
                                                                  '';
                                                              bool result =
                                                                  await UserFirestore
                                                                      .updateUser(
                                                                          stylist);
                                                              bool success =
                                                                  await ShopFirestore
                                                                      .removeStaffFromShop(
                                                                          shop
                                                                              .id,
                                                                          stylist
                                                                              .id);

                                                              if (success &&
                                                                  result) {
                                                                Navigator.pop(
                                                                    context,
                                                                    true);
                                                              } else {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      title: Text(
                                                                          'エラー'),
                                                                      content: Text(
                                                                          'ユーザー情報の更新に失敗しました。'),
                                                                      actions: <
                                                                          Widget>[
                                                                        TextButton(
                                                                          child:
                                                                              Text('閉じる'),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              }
                                                              setState(() {
                                                                _isLoading =
                                                                    false;
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5.0, left: 15),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Icon(Icons.more_vert),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Shop')
                                .doc(shop.id)
                                .collection('service')
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Scaffold(
                                  body: Column(
                                    children: [
                                      SizedBox(
                                        height: 200,
                                      ),
                                      Center(child: Text('スタイリストを追加しよう')),
                                    ],
                                  ),
                                  floatingActionButtonLocation:
                                      FloatingActionButtonLocation.endDocked,
                                  floatingActionButton: FloatingActionButton(
                                    onPressed: () async {
                                      var result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CreateStylistAccountPage(
                                                  shopInfo: shop,
                                                )),
                                      );
                                      if (result == true) {
                                        setState(() {});
                                      }
                                    },
                                    backgroundColor: AppColors.thirdColor,
                                    child: Icon(Icons.add),
                                  ),
                                );
                              }
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }

                              List<Menu> menus = [];

                              snapshot.data!.docs.forEach((doc) {
                                Map<String, dynamic> data =
                                    doc.data() as Map<String, dynamic>;

                                Menu menu = Menu(
                                  id: doc.id,
                                  description: data['description'] ?? '',
                                  duration: data['duration'] ?? 0,
                                  price: data['price'] ?? 0,
                                  menu_image: data['menu_image'] ?? '',
                                  name: data['name'] ?? '',
                                  stylist_ids: data['stylist_ids'] != null
                                      ? List<String>.from(data['stylist_ids'])
                                      : null,
                                );

                                menus.add(menu);
                              });

                              return ListView.builder(
                                itemCount: menus.length,
                                itemBuilder: (context, index) {
                                  Menu menu = menus[index];

                                  return Container(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              child: Image.network(
                                                menu.menu_image,
                                                width: 100,
                                                height: 130,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    // Expandedウィジェットを追加して、子ウィジェットに柔軟性を与える
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 2,
                                                                  horizontal:
                                                                      6),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(20),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                          ),
                                                          child: Text(
                                                            menu.name,
                                                            maxLines:
                                                                null, // 折り返しを有効にするために、nullに設定
                                                            softWrap:
                                                                true, // 折り返しを有効にするために、trueに設定
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppColors
                                                                  .thirdColor, // あなたのAppColors.secondaryColorに変更してください
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Text(
                                                          "値段：${menu.price}円",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                          ),
                                                          textAlign:
                                                              TextAlign.start,
                                                        ),
                                                        Text(
                                                          "施術時間：${menu.price}円",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                          ),
                                                          textAlign:
                                                              TextAlign.start,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 90,
                                                    child: InkWell(
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'メニュー情報の編集'),
                                                              content: Text(
                                                                  'このメニューを編集しますか？'),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  child: Text(
                                                                      '閉じる'),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                                TextButton(
                                                                  child: Text(
                                                                      '編集'),
                                                                  onPressed:
                                                                      () async {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              EditShopMenuPage(
                                                                                menu: menu,
                                                                              )),
                                                                    );
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 5.0,
                                                                left: 15),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Icon(Icons
                                                                .more_vert),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: double.infinity,
                                            child: Text(
                                              menu.description,
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateStylistAccountPage(
                            shopInfo: shop,
                          )),
                );
                if (result == true) {
                  setState(() {});
                }
              },
              backgroundColor: AppColors.thirdColor,
              child: Icon(Icons.add),
            ),
          );
        });
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
  const SlideImage({Key? key, required this.favoriteHairImages})
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
              width: 235,
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
            activeDotColor: AppColors.thirdColor,
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
