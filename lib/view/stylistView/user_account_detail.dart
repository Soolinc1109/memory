import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/model/shop/carte.dart';
import 'package:memorys/model/shop/stylistpost.dart';
import 'package:memorys/utils/authentication.dart';
import 'package:memorys/utils/firestore/posts.dart';
import 'package:memorys/utils/firestore/shops.dart';
import 'package:memorys/utils/firestore/stylistposts.dart';
import 'package:memorys/utils/firestore/users.dart';
import 'package:memorys/view/userPageView/before_after.dart';
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
class AccountDetailsPage extends StatefulWidget {
  bool? isFollwing;
  // final Account? userInfo;
  final String? customerId;
  final Carte userCarte;
  AccountDetailsPage(
      {Key? key, this.isFollwing, this.customerId, required this.userCarte})
      : super(key: key);
  @override
  State<AccountDetailsPage> createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends State<AccountDetailsPage> {
  String _searchKeyword = '';

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
    return Scaffold(
      key: _scaffoldKey,
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
                                    foregroundImage: NetworkImage(
                                        widget.userCarte.profile_image),
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
                                          widget.userCarte.customer_name,
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
                                          widget
                                              .userCarte.customer_katakana_name
                                              .toString(),
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
                          'Memory',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'カルテ情報',
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
                    widget.customerId == ''
                        ? Container(
                            child: Column(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '顧客アカウントを紐づける',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        _searchKeyword = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: "Search",
                                      hintText: "Search by name",
                                      prefixIcon: Icon(Icons.search),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25.0)),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .where('is_stylist', isEqualTo: false)
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'));
                                      }

                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }

                                      List<String> accountIds = snapshot
                                          .data!.docs
                                          .map((doc) => doc.id)
                                          .toList();

                                      return FutureBuilder<List<Account>>(
                                        future: UserFirestore.getUsersMap(
                                            accountIds),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            List<Account> userList = snapshot
                                                .data!
                                                .where((user) => user.name
                                                    .toLowerCase()
                                                    .contains(_searchKeyword
                                                        .toLowerCase()))
                                                .toList();
                                            return ListView.builder(
                                              itemCount: userList.length,
                                              itemBuilder: (context, index) {
                                                Account userAccount =
                                                    userList[index];
                                                return ListTile(
                                                  leading: CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(userAccount
                                                            .imagepath),
                                                  ),
                                                  title: Text(userAccount.name),
                                                  trailing: ElevatedButton(
                                                    onPressed: () async {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: Text('連携'),
                                                            content: Text(
                                                                'お客さん連携しますか？'),
                                                            actions: <Widget>[
                                                              Row(
                                                                children: [
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
                                                                        '登録'),
                                                                    onPressed:
                                                                        () async {
                                                                      var updatecarte = await PostFirestore.updateCarteCustomerId(
                                                                          widget
                                                                              .userCarte
                                                                              .id,
                                                                          userAccount
                                                                              .id);

                                                                      var updateShopSubInfo = await ShopFirestore.updateCustomerInformation(
                                                                          myAccount
                                                                              .shopId,
                                                                          widget
                                                                              .userCarte
                                                                              .id,
                                                                          customerId: widget
                                                                              .userCarte
                                                                              .customer_id);

                                                                      if (updatecarte ==
                                                                              true &&
                                                                          updateShopSubInfo ==
                                                                              true) {
                                                                        Navigator.pop(
                                                                            context,
                                                                            true);
                                                                        Navigator.pop(
                                                                            context,
                                                                            true);
                                                                      } else {
                                                                        showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return AlertDialog(
                                                                              title: Text('エラー'),
                                                                              content: Text('ユーザー連携に失敗しました。'),
                                                                              actions: <Widget>[
                                                                                TextButton(
                                                                                  child: Text('閉じる'),
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        );
                                                                      }
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Text('決定'),
                                                  ),
                                                );
                                              },
                                            );
                                          } else if (snapshot.hasError) {
                                            return Center(
                                                child: Text(
                                                    'Error: ${snapshot.error}'));
                                          } else {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            child: FutureBuilder<Account?>(
                                future:
                                    UserFirestore.getUser(widget.customerId!),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  }

                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }
                                  Account account = snapshot.data!;
                                  List<String>? favoriteimage = [
                                    account.favorite_image_0!,
                                    account.favorite_image_1!,
                                    account.favorite_image_2!,
                                    account.favorite_image_3!,
                                    account.favorite_image_4!,
                                  ];

                                  return Center(
                                      child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                "ユーザーがなりたい髪型",
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
                                        SlideImage(
                                            favoriteHairImages: favoriteimage),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                "あなたのmemory",
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
                                        Container(
                                          height: 100,
                                          width: 350,
                                          child: StreamBuilder<QuerySnapshot>(
                                              stream: _isFirstBuild
                                                  ? StylistPostFirestore.posts
                                                      .where('customer_id',
                                                          isEqualTo: account.id)
                                                      // .orderBy('created_at', descending: true)
                                                      .snapshots()
                                                  : null,
                                              builder: (context, postSnapshot) {
                                                if (postSnapshot.hasData &&
                                                    !postSnapshot
                                                        .data!.docs.isEmpty) {
                                                  List<String> postAccountIds =
                                                      [];
                                                  postSnapshot.data!.docs
                                                      .forEach((doc) {
                                                    Map<String, dynamic> data =
                                                        doc.data() as Map<
                                                            String, dynamic>;
                                                    if (!postAccountIds
                                                        .contains(data[
                                                            'post_account_id'])) {
                                                      postAccountIds.add(data[
                                                          'post_account_id']);
                                                    }
                                                  });
                                                  return ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: postSnapshot
                                                          .data!.docs.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        Map<String, dynamic>
                                                            data = postSnapshot
                                                                    .data!
                                                                    .docs[index]
                                                                    .data()
                                                                as Map<String,
                                                                    dynamic>;
                                                        StylistPost stylistpost = StylistPost(
                                                            carte_id: data[
                                                                'carte_id'],
                                                            shop_id:
                                                                data['shop_id'],
                                                            customer_id: data[
                                                                'customer_id'],
                                                            poster_image_url:
                                                                account
                                                                    .imagepath,
                                                            before_image: data[
                                                                'before_image'],
                                                            message_for_customer:
                                                                data[
                                                                    'message_for_customer'],
                                                            after_image: data[
                                                                'after_image'],
                                                            postAccountId: data[
                                                                'post_account_id'],
                                                            createdTime: data[
                                                                'created_at']);
                                                        final beforeimageUrl =
                                                            stylistpost
                                                                .before_image;

                                                        final afterimageUrl =
                                                            stylistpost
                                                                .after_image;

                                                        return beforeimageUrl !=
                                                                null
                                                            ? InkWell(
                                                                onTap: () {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            BeforeAfterDetail(
                                                                              beforeimage: stylistpost.before_image,
                                                                              afterimage: stylistpost.after_image,
                                                                              stylistpost: stylistpost,
                                                                            )),
                                                                  );
                                                                },
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 4.0,
                                                                      right:
                                                                          5.0,
                                                                      bottom:
                                                                          5.0,
                                                                      top: 5.0),
                                                                  child: Column(
                                                                    children: [
                                                                      ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.0),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              80,
                                                                          height:
                                                                              80,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              AspectRatio(
                                                                                aspectRatio: 0.5,
                                                                                child: Image.network(
                                                                                  beforeimageUrl[index],
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                              ),
                                                                              AspectRatio(
                                                                                aspectRatio: 0.5,
                                                                                child: Image.network(
                                                                                  afterimageUrl![index],
                                                                                  fit: BoxFit.cover,
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
                                                      });
                                                } else {
                                                  return Container(
                                                    child: Text('まだカルテがありません'),
                                                  );
                                                }
                                              }),
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
                                                "ミディアムボブ",
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
                                                left: 18.0),
                                            child: SizedBox(
                                              height: 210,
                                              child: ListView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    15),
                                                          ),
                                                          image:
                                                              DecorationImage(
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
                                                          padding:
                                                              EdgeInsets.all(4),
                                                          child: Column(
                                                            children: [
                                                              Align(
                                                                alignment: Alignment
                                                                    .bottomLeft,
                                                                child: Text(
                                                                  "bob",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14,
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
                                                                        Alignment
                                                                            .bottomLeft,
                                                                    child: Text(
                                                                      "1位",
                                                                      style: TextStyle(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              54,
                                                                              171,
                                                                              244),
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.bold),
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
                                                  ),
                                                  Column(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
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
                                                          padding:
                                                              EdgeInsets.all(4),
                                                          child: Column(
                                                            children: [
                                                              Align(
                                                                alignment: Alignment
                                                                    .bottomLeft,
                                                                child: Text(
                                                                  "bob",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14,
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
                                                                        Alignment
                                                                            .bottomLeft,
                                                                    child: Text(
                                                                      "2位",
                                                                      style: TextStyle(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              54,
                                                                              171,
                                                                              244),
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.bold),
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
                                                  ),
                                                  Column(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
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
                                                          padding:
                                                              EdgeInsets.all(4),
                                                          child: Column(
                                                            children: [
                                                              Align(
                                                                alignment: Alignment
                                                                    .bottomLeft,
                                                                child: Text(
                                                                  "bob",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14,
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
                                                                        Alignment
                                                                            .bottomLeft,
                                                                    child: Text(
                                                                      "3位",
                                                                      style: TextStyle(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              54,
                                                                              171,
                                                                              244),
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.bold),
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
                                                  ),
                                                  Column(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
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
                                                          padding:
                                                              EdgeInsets.all(4),
                                                          child: Column(
                                                            children: [
                                                              Align(
                                                                alignment: Alignment
                                                                    .bottomLeft,
                                                                child: Text(
                                                                  "bob",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14,
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
                                                                        Alignment
                                                                            .bottomLeft,
                                                                    child: Text(
                                                                      "4位",
                                                                      style: TextStyle(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              54,
                                                                              171,
                                                                              244),
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.bold),
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
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
                                }),
                          ),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: StylistPostFirestore.posts
                              .where('post_account_id', isEqualTo: myAccount.id)
                              .where('carte_id', isEqualTo: widget.userCarte.id)
                              // .orderBy('created_at', descending: true)
                              .snapshots(),
                          builder: (context, postSnapshot) {
                            if (!postSnapshot.hasData ||
                                postSnapshot.data!.docs.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Container(
                                  child: Text(
                                    'まだカルテがありません',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                              );
                            }
                            List<String> postAccountIds = [];
                            postSnapshot.data!.docs.forEach((doc) {
                              Map<String, dynamic> data =
                                  doc.data() as Map<String, dynamic>;
                              if (!postAccountIds
                                  .contains(data['post_account_id'])) {
                                postAccountIds.add(data['post_account_id']);
                              }
                            });
                            return FutureBuilder<Map<String, Account>?>(
                                future: UserFirestore.getPostUserMap(
                                    postAccountIds),
                                builder: (context, userSnapshot) {
                                  print(userSnapshot);
                                  if (!userSnapshot.hasData) {
                                    return Container();
                                  }
                                  if (userSnapshot.connectionState ==
                                      ConnectionState.done) {
                                    // 既存のコード
                                  } else {
                                    return Container();
                                  }
                                  return ListView.builder(
                                      itemCount: postSnapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        Map<String, dynamic> data = postSnapshot
                                            .data!.docs[index]
                                            .data() as Map<String, dynamic>;
                                        StylistPost stylistpost = StylistPost(
                                            carte_id: data['carte_id'],
                                            shop_id: data['shop_id'],
                                            poster_image_url:
                                                myAccount.imagepath,
                                            customer_id: data['customer_id'],
                                            before_image: data['before_image'],
                                            message_for_customer:
                                                data['message_for_customer'],
                                            after_image: data['after_image'],
                                            postAccountId:
                                                data['post_account_id'],
                                            createdTime: data['created_at']);
                                        Account postAccount = userSnapshot
                                            .data![stylistpost.postAccountId]!;
                                        return postAccount == null
                                            ? Container(
                                                child: Text('t'),
                                              )
                                            : Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 0,
                                                    vertical: 15),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    InkWell(
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
                                                      child: SlideImage2(
                                                        beforeimagePhoto:
                                                            stylistpost
                                                                .before_image,
                                                        afterimagePhoto:
                                                            stylistpost
                                                                .after_image,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: CircleAvatar(
                                                              radius: 29,
                                                              foregroundImage:
                                                                  NetworkImage(
                                                                      postAccount
                                                                          .imagepath),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8.0),
                                                            child: Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                width: 250,
                                                                child: Text(
                                                                    stylistpost
                                                                        .message_for_customer)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                      });
                                });
                          }),
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

class SlideImage2 extends StatefulWidget {
  final List<dynamic>? beforeimagePhoto;
  final List<dynamic>? afterimagePhoto;
  const SlideImage2(
      {Key? key, required this.beforeimagePhoto, required this.afterimagePhoto})
      : super(key: key);

  @override
  State<SlideImage2> createState() => _SlideImage2State();
}

class _SlideImage2State extends State<SlideImage2> {
  List beforeimages = [];
  List afterimages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    beforeimages = widget.beforeimagePhoto!;
    afterimages = widget.afterimagePhoto!;
  }

  int activeIndex = 0;
  Widget buildImage(beforepath, afterpath, index, screenWidth) => Row(
        children: [
          Column(
            children: [
              Container(
                height: 230,
                width: screenWidth / 2,
                color: Colors.grey,
                child: Image.network(
                  beforepath,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                height: 230,
                width: screenWidth / 2,
                color: Colors.grey,
                child: Image.network(
                  afterpath,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ],
      );

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: 3,
        //エフェクトはドキュメントを見た方がわかりやすい
        effect: JumpingDotEffect(
            dotHeight: 1,
            dotWidth: 1,
            activeDotColor: Colors.green,
            dotColor: Colors.black12),
      );

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Column(children: [
        CarouselSlider.builder(
          itemCount: 3,
          itemBuilder: (context, index, realIndex) {
            final beforepath = beforeimages[index];
            final afterpath = afterimages[index];

            return buildImage(beforepath, afterpath, index, screenWidth);
          },
          options: CarouselOptions(
            height: 230,
            initialPage: 0,
            viewportFraction: 1,
            // enlargeCenterPage: true,
            onPageChanged: (index, reason) => setState(
              () {
                activeIndex = index;
              },
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        buildIndicator(),
      ]),
    );
  }
}
