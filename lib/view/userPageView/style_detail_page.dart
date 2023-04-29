import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/utils/color.dart';
import 'package:memorys/utils/firestore/posts.dart';
import 'package:memorys/utils/firestore/users.dart';
import 'package:memorys/view/stylistView/stylists_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class StyleDetail extends StatefulWidget {
  const StyleDetail({Key? key}) : super(key: key);

  @override
  _StyleDetailState createState() => _StyleDetailState();
}

class _StyleDetailState extends State<StyleDetail> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 251, 249),
        body: SingleChildScrollView(
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
                              postAccountIds.add(data['post_account_id']);
                            }
                          });
                          return FutureBuilder<Map<String, Account>?>(
                              future:
                                  UserFirestore.getPostUserMap(postAccountIds),
                              builder: (context, userSnapshot) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Container(
                                        child: SlideImage(beforeimagePhoto: []),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        } else {
                          return Container();
                        }
                      }),
                ),
                Container(
                  color: Color.fromARGB(255, 255, 255, 255),
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, left: 16.0, bottom: 10),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Confidence -Men\'s HAIR 渋谷店',
                            style: TextStyle(
                              fontSize: 20,
                              color: AppColors.thirdColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '【ソフトツイストパーマ】 サーフアップパング ショートヘア',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Text(
                                '￥14,500',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '税込',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/%E3%80%90%E3%82%B7%E3%83%A7%E3%83%BC%E3%83%88%E7%B7%A8%E3%80%91%E6%AF%9B%E9%87%8F%E3%81%8B%E3%82%99%E5%A4%9A%E3%81%84%E3%81%BB%E3%82%9A%E3%81%A3%E3%81%A1%E3%82%83%E3%82%8A%E3%81%95%E3%82%93%E3%81%93%E3%81%9D%E4%BC%BC%E5%90%88%E3%81%86%E2%99%AA%E5%A4%8F%E3%82%89%E3%81%97%E3%81%84%E9%AB%AA%E5%9E%8B5%E3%81%A4%20_%204MEEE.jpeg?alt=media&token=a20fce81-bef0-44d2-80f6-03b01b6c2a41',
                          width: 80.0,
                          height: 80.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'スタイリスト',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                '牛島　優香',
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: AppColors.thirdColor,
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Text(
                          '予約',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'サロン情報',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 8),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                              ),
                              child: Image.network(
                                'https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/ph_main4.jpg?alt=media&token=66edf9cd-b15b-404f-a548-657ec655640f',
                                width: 120.0,
                                height: 80.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              height: 80.0,
                              child: Row(
                                children: [
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 14.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Confidence -Men\'s HAIR 渋谷店',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          SizedBox(height: 5.0),
                                          Row(
                                            children: [
                                              Text(
                                                'このサロンについて',
                                                style:
                                                    TextStyle(fontSize: 13.0),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                size: 14.0,
                                                color: Colors.black,
                                              ),
                                            ],
                                          ),
                                        ],
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
                                            const StylistsPage()),
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
                                        alignment: Alignment.bottomLeft,
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
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              "￥7,880",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 54, 171, 244),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
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
                                        alignment: Alignment.bottomLeft,
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
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              "￥7,880",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 54, 171, 244),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
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
                                        alignment: Alignment.bottomLeft,
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
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              "￥7,880",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 54, 171, 244),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
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
                                        alignment: Alignment.bottomLeft,
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
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              "￥7,880",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 54, 171, 244),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
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
                  height: 30,
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
                        "このサロンを見ている人におすすめ",
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
                                        alignment: Alignment.bottomLeft,
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
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              "￥7,880",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 54, 171, 244),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
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
                                        alignment: Alignment.bottomLeft,
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
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              "￥7,880",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 54, 171, 244),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
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
                                            alignment: Alignment.bottomLeft,
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Text(
                                                  "￥7,880",
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 54, 171, 244),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                        alignment: Alignment.bottomLeft,
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
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              "￥7,880",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 54, 171, 244),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
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
                )
              ],
            ),
          ),
        ));
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
  final CarouselController _carouselController = CarouselController();

  Widget buildImage(beforepath, index, screenWidth) => Row(
        children: [
          Column(
            children: [
              Container(
                height: 500,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.grey,
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
            dotHeight: 0,
            dotWidth: 0,
            activeDotColor: Color.fromARGB(255, 111, 190, 255),
            dotColor: Colors.black12),
      );

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Column(children: [
        Align(
          alignment: Alignment.center, // これを追加
          child: Stack(
            children: [
              CarouselSlider.builder(
                carouselController: _carouselController,
                itemCount: 5,
                itemBuilder: (context, index, realIndex) {
                  var beforeimagePhoto = [
                    "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/%E5%A4%A7%E4%BA%BA%E5%8F%AF%E6%84%9B%E3%81%84%E3%83%9F%E3%83%86%E3%82%99%E3%82%A3%E2%99%A1%EF%BD%9Cto_na%20%E8%A1%A8%E5%8F%82%E9%81%93%EF%BC%88%E3%83%88%E3%82%A5%E3%83%BC%E3%83%8A%E3%82%AA%E3%83%A2%E3%83%86%E3%82%B5%E3%83%B3%E3%83%88%E3%82%99%E3%82%A6%EF%BC%89%E6%AB%BB%E6%9C%A8%E8%A3%95%E7%B4%80%E3%81%AE%E9%AB%AA%E5%9E%8B%E3%83%BB%E3%83%98%E3%82%A2%E3%82%B9%E3%82%BF%E3%82%A4%E3%83%AB%E3%83%BB%E3%83%98%E3%82%A2%E3%82%AB%E3%82%BF%E3%83%AD%E3%82%AF%E3%82%99%E6%83%85%E5%A0%B1%EF%BD%9CYahoo!%20BEAUTY%EF%BC%88%E3%83%A4%E3%83%95%E3%83%BC%E3%83%92%E3%82%99%E3%83%A5%E3%83%BC%E3%83%86%E3%82%A3%E3%83%BC%EF%BC%89.webp?alt=media&token=b33ecb9b-9d40-4741-9d06-8cf964639b6e",
                    "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/%E5%8F%AF%E6%84%9B%E3%81%84%E3%81%AE%E3%81%AB%E5%A4%A7%E4%BA%BA%E3%81%A3%E3%81%BB%E3%82%9A%E3%81%84%E3%80%82%E3%83%9F%E3%83%86%E3%82%99%E3%82%A3%E3%82%A2%E3%83%A0%E3%83%98%E3%82%A2%E3%81%AE%E9%AB%AA%E5%9E%8B%E3%81%A6%E3%82%99%E5%8F%B6%E3%81%88%E3%82%8B%E5%A5%B3%E5%BA%A6%E4%B8%8A%E3%81%8B%E3%82%99%E3%82%8B%E4%BB%95%E4%B8%8A%E3%81%8B%E3%82%99%E3%82%8A%E3%82%92%E3%81%93%E3%82%99%E7%B4%B9%E4%BB%8B%20_%20folk.png?alt=media&token=5c81d034-056c-4723-88c5-c4acc701053b",
                    "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/%E5%A4%A7%E4%BA%BA%E3%81%AB%E5%90%88%E3%81%86%E9%BB%92%E9%AB%AA%E3%83%9E%E3%83%83%E3%82%B7%E3%83%A5%E3%82%A6%E3%83%AB%E3%83%95%E7%89%B9%E9%9B%86%E3%80%82%E5%B0%8F%E9%A1%94%E8%A6%8B%E3%81%9B%E3%82%92%E5%8F%B6%E3%81%88%E3%82%8B%E7%94%98%E8%BE%9B%E3%83%98%E3%82%A2%E3%82%92%E3%83%AC%E3%83%B3%E3%82%AF%E3%82%99%E3%82%B9%E5%88%A5%E3%81%A6%E3%82%99%E3%81%93%E3%82%99%E7%B4%B9%E4%BB%8B%20_%20folk.png?alt=media&token=e546aaf4-e66a-46cf-bbbf-5c46f7345556",
                    "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/%E3%80%902023%E5%B9%B4%E6%98%A5%E3%80%91%E3%83%9F%E3%83%86%E3%82%99%E3%82%A3%E3%82%A2%E3%83%A0%20%E3%81%B2%E3%81%97%E5%BD%A2%E3%83%9B%E3%82%99%E3%83%95%E3%82%99%E3%81%AE%E9%AB%AA%E5%9E%8B%E3%83%BB%E3%83%98%E3%82%A2%E3%82%A2%E3%83%AC%E3%83%B3%E3%82%B7%E3%82%99%EF%BD%9C%E4%BA%BA%E6%B0%97%E9%A0%86%EF%BD%9C%E3%83%9B%E3%83%83%E3%83%88%E3%83%98%E3%82%9A%E3%83%83%E3%83%8F%E3%82%9A%E3%83%BC%E3%83%92%E3%82%99%E3%83%A5%E3%83%BC%E3%83%86%E3%82%A3%E3%83%BC%20%E3%83%98%E3%82%A2%E3%82%B9%E3%82%BF%E3%82%A4%E3%83%AB%E3%83%BB%E3%83%98%E3%82%A2%E3%82%AB%E3%82%BF%E3%83%AD%E3%82%AF%E3%82%99.jpeg?alt=media&token=d4f6c27e-6bdb-4095-882b-f5bfe91713ca",
                    "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/%E3%80%8C%E7%9B%AE%E6%A8%99%E3%81%AF%E5%AE%89%E9%81%94%E7%A5%90%E5%AE%9F%E3%80%8D%E4%BA%BA%E6%B0%97%E3%82%A2%E3%83%8A%E3%80%90%E5%BC%98%E4%B8%AD%E7%B6%BE%E9%A6%99%E3%80%91%E3%81%AE%E7%BE%8E%E5%AE%B9%E3%82%B9%E3%82%A4%E3%83%83%E3%83%81%E3%81%A8%E3%81%AF%EF%BC%9F%E3%80%90%E3%83%92%E3%82%99%E3%83%A5%E3%83%BC%E3%83%86%E3%82%A3%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9%E3%80%91%EF%BD%9C%E7%BE%8E%E5%AE%B9%E3%83%A1%E3%83%86%E3%82%99%E3%82%A3%E3%82%A2VOCE%EF%BC%88%E3%82%A6%E3%82%99%E3%82%A9%E3%83%BC%E3%83%81%E3%82%A7%EF%BC%89.jpeg?alt=media&token=5a321559-20af-415b-948e-48c6b7fa45d5",
                  ];
                  final beforepath = beforeimagePhoto[index];
                  return buildImage(beforepath, index, screenWidth);
                },
                options: CarouselOptions(
                  height: 500,
                  initialPage: 0,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) => setState(
                    () {
                      activeIndex = index;
                    },
                  ),
                ),
              ),
              Positioned(
                left: 10.0,
                top: 250, // 中央に配置するため、画像の高さの半分からアイコンの半分を引く
                child: IconButton(
                  onPressed: () {
                    _carouselController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.linear,
                    );
                  },
                  icon: Icon(Icons.arrow_back_ios),
                  color: Color.fromARGB(255, 54, 171, 244),
                ),
              ),
              Positioned(
                right: 10.0,
                top: 250, // 中央に配置するため、画像の高さの半分からアイコンの半分を引く
                child: IconButton(
                  onPressed: () {
                    _carouselController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.linear,
                    );
                  },
                  icon: Icon(Icons.arrow_forward_ios),
                  color: Color.fromARGB(255, 54, 171, 244),
                ),
              ),
            ],
          ),
        ),
        buildIndicator(),
      ]),
    );
  }
}
