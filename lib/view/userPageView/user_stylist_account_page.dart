import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/model/shop/shop.dart';
import 'package:memorys/model/shop/stylistpost.dart';
import 'package:memorys/utils/authentication.dart';
import 'package:memorys/utils/color.dart';
import 'package:memorys/utils/firestore/shops.dart';
import 'package:memorys/view/shopview/stylist_shop_page.dart';
import 'package:memorys/view/stylistView/user_list_page.dart';
import 'package:memorys/view/userPageView/account/edit_account_page.dart';
import 'package:memorys/view/startup/login_page.dart';
import 'package:memorys/view/userPageView/calendar.dart';
import 'package:memorys/view/userPageView/create_user_post_page.dart';
import 'package:memorys/view/userPageView/photo_view_page.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
class UserStylistAccountPage extends StatefulWidget {
  bool? isFollwing;
  Account stylist;
  // final Account? userInfo;
  UserStylistAccountPage({Key? key, this.isFollwing, required this.stylist})
      : super(key: key);
  @override
  State<UserStylistAccountPage> createState() => _UserStylistAccountPageState();
}

class _UserStylistAccountPageState extends State<UserStylistAccountPage> {
  List<StylistPost> _posts = [];

  static final _firestoreInstance = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
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
                            account: widget.stylist,
                          )),
                );
                if (result == true) {
                  setState(() {});
                }
                // ここでタップ時の処理を記述します。
              },
            ),
            ListTile(
              title: Text('ユーザー検索'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserListView()),
                );
              },
            ),
            ListTile(
              title: Text('マイショップ'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StylistShopPage(
                            shopId: widget.stylist.shopId,
                          )),
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
          title: StreamBuilder<Shop>(
              stream: ShopFirestore.getShop(widget.stylist.shopId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return Center(child: Text('データを取得できませんでした。'));
                } else {
                  final Shop shop = snapshot.data!;
                  return Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StylistShopPage(
                                      shopId: widget.stylist.shopId,
                                    )),
                          );
                        },
                        child: CircleAvatar(
                          radius: 21,
                          foregroundImage: NetworkImage(shop.logoImage),
                        ),
                      ),
                    ],
                  );
                }
              }),
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
                      height: 120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 41,
                                    foregroundImage:
                                        NetworkImage(widget.stylist.imagepath),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          //ステイトフルウィジェットのクラスをステイトのクラスで使おうとするときにwidget.が必要！
                                          widget.stylist.name,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          widget.stylist.selfIntroduction,
                                          textAlign: TextAlign.start,
                                          maxLines: 3, // 3行まで表示（適切な行数に変更してください）
                                          overflow: TextOverflow
                                              .ellipsis, // もしテキストがはみ出す場合、末尾に '...' を表示
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
                          'スナップ',
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
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('userposts')
                          .where('post_account_id',
                              isEqualTo: widget.stylist.id)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Container(
                              child: Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      child: Text(
                                        "スナップを投稿しよう！",
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
                                        height: 160,
                                        child: Image(
                                          image: NetworkImage(
                                              "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/undraw_add_friends_re_3xte.png?alt=media&token=f1055f15-a980-4658-ac7c-77bfd76462c2"),
                                        )),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    Container(
                                      child: Text(
                                        "スナップを投稿することで\nお客さんがあなたの投稿を発見し\n指名してもらえやすくなります",
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
                                                builder: (context) =>
                                                    const CreatePostPage()),
                                          );
                                          if (result == true) {
                                            setState(() {});
                                          }
                                        },
                                        child: Container(
                                            height: 40,
                                            width: screenWidth / 2.3,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      15), // 角丸を追加
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  AppColors
                                                      .thirdColor, // グラデーションの開始色
                                                  AppColors
                                                      .secondaryColor, // グラデーションの終了色
                                                ],
                                              ),
                                            ),
                                            child: Center(
                                              child: Text('スナップを投稿',
                                                  style: TextStyle(
                                                    fontSize:
                                                        20, // フォントサイズを大きくする
                                                    fontWeight: FontWeight
                                                        .bold, // フォントを太くする
                                                    color: Colors
                                                        .white, // テキストの色を白にする
                                                  )),
                                            ))),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('エラー: ${snapshot.error}'));
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        final imageUrls = snapshot.data!.docs
                            .map((doc) => doc.get('image') as String)
                            .toList();

                        final textcontent = snapshot.data!.docs
                            .map((doc) => doc.get('content') as String)
                            .toList();

                        final createdAt = snapshot.data!.docs
                            .map((doc) => doc.get('created_time'))
                            .toList();

                        return GridView.builder(
                          itemCount: imageUrls.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 1,
                            crossAxisSpacing: 1,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  createPinchOutPageRoute(
                                    nextScreen: PhotoViewPage(
                                      imageUrls,
                                      textcontent,
                                      createdAt,
                                      index,
                                    ),
                                  ),
                                );
                              },
                              child: GridTile(
                                child: Image.network(
                                  imageUrls[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                        );
                      },
                    ),
                    Center(
                      //2
                      child: Column(
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
                                      builder: (context) => StylistShopPage(
                                            shopId: widget.stylist.shopId,
                                          )),
                                );
                              }),
                              child: Container(
                                width: 360,
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      child: Image.network(
                                        "https://imgbp.hotp.jp/CSP/IMG_SRC/51/97/B163645197/B163645197.jpg?impolicy=HPB_policy_default&w=419&h=314",
                                        width: 150,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 6),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20),
                                            ),
                                          ),
                                          child: Text(
                                            "4月23日に来店",
                                            style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.secondaryColor,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "所要時間：2時間",
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
                                        Text(
                                          "合計金額：￥9,050",
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                        Text(
                                          "スタイリスト：日見　圭吾",
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                          textAlign: TextAlign.start,
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
                                  color: Colors.grey.withOpacity(0.5),
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
                          Container(
                            padding: EdgeInsets.all(10),
                            child: InkWell(
                              onTap: (() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => StylistShopPage(
                                            shopId: widget.stylist.shopId,
                                          )),
                                );
                              }),
                              child: Container(
                                width: 360,
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      child: Image.network(
                                        "https://imgbp.hotp.jp/CSP/IMG_SRC/51/97/B163645197/B163645197.jpg?impolicy=HPB_policy_default&w=419&h=314",
                                        width: 150,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 6),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20),
                                            ),
                                          ),
                                          child: Text(
                                            "4月23日に来店",
                                            style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.secondaryColor,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "所要時間：2時間",
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
                                        Text(
                                          "合計金額：￥9,050",
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                        Text(
                                          "スタイリスト：日見　圭吾",
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                          textAlign: TextAlign.start,
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
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
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
              width: 220,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20), // 角を丸くする
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
