import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/utils/firestore/posts.dart';
import 'package:memorys/utils/firestore/users.dart';
import 'package:memorys/view/userPageView/calendar.dart';
import 'package:memorys/view/userPageView/style_detail_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TimeLinePage extends StatefulWidget {
  const TimeLinePage({Key? key}) : super(key: key);

  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

const _tabs = <Widget>[
  Tab(
    child: Text(
      'フィルター',
      style: TextStyle(
        color: Colors.black,
      ),
    ),
  ),
  Tab(
    child: Text(
      'カット1',
      style: TextStyle(
        color: Colors.black,
      ),
    ),
  ),
  Tab(
    child: Text(
      'カット2',
      style: TextStyle(
        color: Colors.black,
      ),
    ),
  ),
];

class _TimeLinePageState extends State<TimeLinePage> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(35),
          child: AppBar(
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black, size: 30),
            backgroundColor: Color.fromARGB(255, 237, 237, 237),
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Memory",
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        body: DefaultTabController(
          length: _tabs.length, // This is the number of tabs.
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        color: Color.fromARGB(255, 237, 237, 237),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Container(
                            height: 40,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10), // Container内部の余白
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(top: 5.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: '全てのスタイルの中から探す',
                                  hintStyle: TextStyle(fontSize: 13.0),
                                  border: InputBorder.none,
                                  icon: Icon(Icons.search,
                                      color: Color.fromARGB(
                                          255, 54, 171, 244)), // iconの色を赤に変更
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 70.0,
                  backgroundColor:
                      Color.fromARGB(255, 237, 237, 237), // 背景色を青に設定
                  flexibleSpace: FlexibleSpaceBar(
                    background: TabBar(
                      tabs: <Widget>[
                        Tab(
                          child: Text(
                            'パーソナライズ',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'ボブ',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'ショート',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                      indicatorColor: Color.fromARGB(255, 54, 171, 244),
                    ),
                  ),
                )
              ];
            },
            body: Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: [
                          Container(
                            child: StreamBuilder<QuerySnapshot>(
                                stream: PostFirestore.posts
                                    .orderBy('created_time', descending: true)
                                    .snapshots(),
                                builder: (context, postSnapshot) {
                                  if (postSnapshot.hasData) {
                                    List<String> postAccountIds = [];
                                    postSnapshot.data!.docs.forEach((doc) {
                                      Map<String, dynamic> data =
                                          doc.data() as Map<String, dynamic>;
                                      if (!postAccountIds
                                          .contains(data['post_account_id'])) {
                                        postAccountIds
                                            .add(data['post_account_id']);
                                      }
                                    });
                                    return FutureBuilder<Map<String, Account>?>(
                                        future: UserFirestore.getPostUserMap(
                                            postAccountIds),
                                        builder: (context, userSnapshot) {
                                          return Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 15),
                                            child: Column(
                                              children: [
                                                SlideImage(
                                                    beforeimagePhoto: []),
                                              ],
                                            ),
                                          );
                                        });
                                  } else {
                                    return Container();
                                  }
                                }),
                          ),
                          Center(
                            child: SizedBox(
                              height: 130,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CalendarScreen()),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0,
                                          right: 5.0,
                                          bottom: 5.0,
                                          top: 5.0),
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/1.png?alt=media&token=3b41615f-73c2-4f4b-b230-212cb5652825"),
                                            radius: 40.0,
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            "セール",
                                            style: TextStyle(fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/2.png?alt=media&token=cd26a51c-1c8b-418e-9f08-65135f2e2dee"),
                                          radius: 40.0,
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          "クーポン",
                                          style: TextStyle(fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/3.png?alt=media&token=f00f30ab-5797-4577-9fd6-f1a14ca3508c"),
                                          radius: 40.0,
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          "アルバム",
                                          style: TextStyle(fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/4.png?alt=media&token=ab3083b9-55b9-4978-aaba-95dcc7ef2ab7"),
                                          radius: 40.0,
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          "セール",
                                          style: TextStyle(fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
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
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const StyleDetail()),
                                            );
                                          },
                                          child: Container(
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
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: Text(
                                                        "￥7,880",
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
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
                                                            255, 208, 208, 208))
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
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: Text(
                                                        "￥7,880",
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
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
                                                            255, 208, 208, 208))
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
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: Text(
                                                        "￥7,880",
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
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
                                                            255, 208, 208, 208))
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
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: Text(
                                                        "￥7,880",
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
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
                                                            255, 208, 208, 208))
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
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  "チェックしたカテゴリーのおすすめアイテム",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 165, 165, 165),
                                    fontSize: 12.0,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  "ウルフ",
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
                                                  "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/%E3%80%8C%E7%9B%AE%E6%A8%99%E3%81%AF%E5%AE%89%E9%81%94%E7%A5%90%E5%AE%9F%E3%80%8D%E4%BA%BA%E6%B0%97%E3%82%A2%E3%83%8A%E3%80%90%E5%BC%98%E4%B8%AD%E7%B6%BE%E9%A6%99%E3%80%91%E3%81%AE%E7%BE%8E%E5%AE%B9%E3%82%B9%E3%82%A4%E3%83%83%E3%83%81%E3%81%A8%E3%81%AF%EF%BC%9F%E3%80%90%E3%83%92%E3%82%99%E3%83%A5%E3%83%BC%E3%83%86%E3%82%A3%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9%E3%80%91%EF%BD%9C%E7%BE%8E%E5%AE%B9%E3%83%A1%E3%83%86%E3%82%99%E3%82%A3%E3%82%A2VOCE%EF%BC%88%E3%82%A6%E3%82%99%E3%82%A9%E3%83%BC%E3%83%81%E3%82%A7%EF%BC%89.jpeg?alt=media&token=5a321559-20af-415b-948e-48c6b7fa45d5"),
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
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: Text(
                                                        "￥7,880",
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
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
                                                            255, 208, 208, 208))
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
                                                  "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/%E3%80%902023%E5%B9%B4%E5%86%AC%E3%80%91%E3%81%A8%E3%82%99%E3%82%8C%E3%81%8B%E3%82%99%E5%A5%BD%E3%81%BF%EF%BC%9F%E3%83%9F%E3%83%86%E3%82%99%E3%82%A3%E3%82%A2%E3%83%A0%20%E3%82%A4%E3%83%B3%E3%83%8A%E3%83%BC%E3%82%AB%E3%83%A9%E3%83%BC%E3%81%AE%E3%83%98%E3%82%A2%E3%82%B9%E3%82%BF%E3%82%A4%E3%83%AB%E3%83%BB%E9%AB%AA%E5%9E%8B%E3%83%BB%E3%83%98%E3%82%A2%E3%82%A2%E3%83%AC%E3%83%B3%E3%82%B7%E3%82%99%E4%B8%80%E8%A6%A7%EF%BD%9CBIGLOBE%20Beauty.jpeg?alt=media&token=00a4e678-4e9c-411b-96ae-a158a0352363"),
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
                                                    "wolf",
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
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: Text(
                                                        "￥7,880",
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
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
                                                            255, 208, 208, 208))
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
                                        Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/%E3%80%902023%E5%B9%B4%E6%98%A5%E3%80%91%E3%83%9F%E3%83%86%E3%82%99%E3%82%A3%E3%82%A2%E3%83%A0%20%E3%81%B2%E3%81%97%E5%BD%A2%E3%83%9B%E3%82%99%E3%83%95%E3%82%99%E3%81%AE%E9%AB%AA%E5%9E%8B%E3%83%BB%E3%83%98%E3%82%A2%E3%82%A2%E3%83%AC%E3%83%B3%E3%82%B7%E3%82%99%EF%BD%9C%E4%BA%BA%E6%B0%97%E9%A0%86%EF%BD%9C%E3%83%9B%E3%83%83%E3%83%88%E3%83%98%E3%82%9A%E3%83%83%E3%83%8F%E3%82%9A%E3%83%BC%E3%83%92%E3%82%99%E3%83%A5%E3%83%BC%E3%83%86%E3%82%A3%E3%83%BC%20%E3%83%98%E3%82%A2%E3%82%B9%E3%82%BF%E3%82%A4%E3%83%AB%E3%83%BB%E3%83%98%E3%82%A2%E3%82%AB%E3%82%BF%E3%83%AD%E3%82%AF%E3%82%99.jpeg?alt=media&token=d4f6c27e-6bdb-4095-882b-f5bfe91713ca"),
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
                                                            "￥7,880",
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
                                                            color:
                                                                Color.fromARGB(
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
                                    Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/_.jpeg?alt=media&token=c421de7d-779d-40f9-af85-aef0af6193d3"),
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
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: Text(
                                                        "￥7,880",
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
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
                                                            255, 208, 208, 208))
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
                          SizedBox(
                            height: 25,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(),
                  Center(),
                ],
              ),
            ),
          ),
        ));
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
  final List<String> beforeimagePhoto;
  const SlideImage({Key? key, required this.beforeimagePhoto})
      : super(key: key);

  @override
  State<SlideImage> createState() => _SlideImageState();
}

class _SlideImageState extends State<SlideImage> {
  @override
  int activeIndex = 0;
  Widget buildImage(beforepath, index) => Row(
        children: [
          Column(
            children: [
              Container(
                height: 200,
                width: 290,
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

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: 5,
        //エフェクトはドキュメントを見た方がわかりやすい
        effect: JumpingDotEffect(
            dotHeight: 6,
            dotWidth: 6,
            activeDotColor: Color.fromARGB(255, 111, 190, 255),
            dotColor: Colors.black12),
      );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        Align(
          alignment: Alignment.center, // これを追加
          child: CarouselSlider.builder(
            itemCount: 5,
            itemBuilder: (context, index, realIndex) {
              var beforeimagePhoto = [
                "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/ph_main4.jpg?alt=media&token=66edf9cd-b15b-404f-a548-657ec655640f",
                "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/10386851_0_ac4e23daf04c6619eee6d484ab8cd3ef.jpg?alt=media&token=776f7b2b-8eed-4af1-b1b1-ad88ee3abd12",
                "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/ph_main4.jpg?alt=media&token=66edf9cd-b15b-404f-a548-657ec655640f",
                "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/B038842784.jpg?alt=media&token=4543970a-331a-46e3-b593-98d0a9f7495b",
                "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/B038842784.jpg?alt=media&token=4543970a-331a-46e3-b593-98d0a9f7495b",
              ];
              final beforepath = beforeimagePhoto[index];
              return buildImage(beforepath, index);
            },
            options: CarouselOptions(
              height: 220,
              initialPage: 0,
              viewportFraction: 0.8,
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
