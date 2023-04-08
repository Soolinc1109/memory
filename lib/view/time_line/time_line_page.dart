import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/model/stylistpost.dart';
import 'package:memorys/utils/authentication.dart';
import 'package:memorys/utils/firestore/stylistposts.dart';
import 'package:memorys/utils/firestore/users.dart';
import 'package:memorys/view/time_line/before_after.dart';
import 'package:memorys/view/time_line/create_user_post_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Account myAccount = Authentication.myAccount!;
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreatePostPage()),
              );
            },
            icon: Icon(
              Icons.add_circle_outline,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 35.0),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 90,
                width: 350,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 4.0, right: 5.0, bottom: 5.0, top: 5.0),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              width: 80,
                              height: 80,
                              child: Row(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1,
                                    child: Image.network(
                                      "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/2%3A13.png?alt=media&token=b121cee6-41ca-4e92-a40f-58828a805848",
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
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 4.0, right: 5.0, bottom: 5.0, top: 5.0),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              width: 80,
                              height: 80,
                              child: Row(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 0.5,
                                    child: Image.network(
                                      "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/%E3%80%8C%E7%9B%AE%E6%A8%99%E3%81%AF%E5%AE%89%E9%81%94%E7%A5%90%E5%AE%9F%E3%80%8D%E4%BA%BA%E6%B0%97%E3%82%A2%E3%83%8A%E3%80%90%E5%BC%98%E4%B8%AD%E7%B6%BE%E9%A6%99%E3%80%91%E3%81%AE%E7%BE%8E%E5%AE%B9%E3%82%B9%E3%82%A4%E3%83%83%E3%83%81%E3%81%A8%E3%81%AF%EF%BC%9F%E3%80%90%E3%83%92%E3%82%99%E3%83%A5%E3%83%BC%E3%83%86%E3%82%A3%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9%E3%80%91%EF%BD%9C%E7%BE%8E%E5%AE%B9%E3%83%A1%E3%83%86%E3%82%99%E3%82%A3%E3%82%A2VOCE%EF%BC%88%E3%82%A6%E3%82%99%E3%82%A9%E3%83%BC%E3%83%81%E3%82%A7%EF%BC%89.jpeg?alt=media&token=5a321559-20af-415b-948e-48c6b7fa45d5",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  AspectRatio(
                                    aspectRatio: 0.5,
                                    child: Image.network(
                                      "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/%E3%80%8C%E7%9B%AE%E6%A8%99%E3%81%AF%E5%AE%89%E9%81%94%E7%A5%90%E5%AE%9F%E3%80%8D%E4%BA%BA%E6%B0%97%E3%82%A2%E3%83%8A%E3%80%90%E5%BC%98%E4%B8%AD%E7%B6%BE%E9%A6%99%E3%80%91%E3%81%AE%E7%BE%8E%E5%AE%B9%E3%82%B9%E3%82%A4%E3%83%83%E3%83%81%E3%81%A8%E3%81%AF%EF%BC%9F%E3%80%90%E3%83%92%E3%82%99%E3%83%A5%E3%83%BC%E3%83%86%E3%82%A3%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9%E3%80%91%EF%BD%9C%E7%BE%8E%E5%AE%B9%E3%83%A1%E3%83%86%E3%82%99%E3%82%A3%E3%82%A2VOCE%EF%BC%88%E3%82%A6%E3%82%99%E3%82%A9%E3%83%BC%E3%83%81%E3%82%A7%EF%BC%89.jpeg?alt=media&token=5a321559-20af-415b-948e-48c6b7fa45d5",
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
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 4.0, right: 5.0, bottom: 5.0, top: 5.0),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              width: 80,
                              height: 80,
                              child: Row(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 0.5,
                                    child: Image.network(
                                      "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/%E3%80%8C%E7%9B%AE%E6%A8%99%E3%81%AF%E5%AE%89%E9%81%94%E7%A5%90%E5%AE%9F%E3%80%8D%E4%BA%BA%E6%B0%97%E3%82%A2%E3%83%8A%E3%80%90%E5%BC%98%E4%B8%AD%E7%B6%BE%E9%A6%99%E3%80%91%E3%81%AE%E7%BE%8E%E5%AE%B9%E3%82%B9%E3%82%A4%E3%83%83%E3%83%81%E3%81%A8%E3%81%AF%EF%BC%9F%E3%80%90%E3%83%92%E3%82%99%E3%83%A5%E3%83%BC%E3%83%86%E3%82%A3%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9%E3%80%91%EF%BD%9C%E7%BE%8E%E5%AE%B9%E3%83%A1%E3%83%86%E3%82%99%E3%82%A3%E3%82%A2VOCE%EF%BC%88%E3%82%A6%E3%82%99%E3%82%A9%E3%83%BC%E3%83%81%E3%82%A7%EF%BC%89.jpeg?alt=media&token=5a321559-20af-415b-948e-48c6b7fa45d5",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  AspectRatio(
                                    aspectRatio: 0.5,
                                    child: Image.network(
                                      "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/%E3%80%8C%E7%9B%AE%E6%A8%99%E3%81%AF%E5%AE%89%E9%81%94%E7%A5%90%E5%AE%9F%E3%80%8D%E4%BA%BA%E6%B0%97%E3%82%A2%E3%83%8A%E3%80%90%E5%BC%98%E4%B8%AD%E7%B6%BE%E9%A6%99%E3%80%91%E3%81%AE%E7%BE%8E%E5%AE%B9%E3%82%B9%E3%82%A4%E3%83%83%E3%83%81%E3%81%A8%E3%81%AF%EF%BC%9F%E3%80%90%E3%83%92%E3%82%99%E3%83%A5%E3%83%BC%E3%83%86%E3%82%A3%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9%E3%80%91%EF%BD%9C%E7%BE%8E%E5%AE%B9%E3%83%A1%E3%83%86%E3%82%99%E3%82%A3%E3%82%A2VOCE%EF%BC%88%E3%82%A6%E3%82%99%E3%82%A9%E3%83%BC%E3%83%81%E3%82%A7%EF%BC%89.jpeg?alt=media&token=5a321559-20af-415b-948e-48c6b7fa45d5",
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
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 4.0, right: 5.0, bottom: 5.0, top: 5.0),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              width: 80,
                              height: 80,
                              child: Row(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 0.5,
                                    child: Image.network(
                                      "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/%E3%80%8C%E7%9B%AE%E6%A8%99%E3%81%AF%E5%AE%89%E9%81%94%E7%A5%90%E5%AE%9F%E3%80%8D%E4%BA%BA%E6%B0%97%E3%82%A2%E3%83%8A%E3%80%90%E5%BC%98%E4%B8%AD%E7%B6%BE%E9%A6%99%E3%80%91%E3%81%AE%E7%BE%8E%E5%AE%B9%E3%82%B9%E3%82%A4%E3%83%83%E3%83%81%E3%81%A8%E3%81%AF%EF%BC%9F%E3%80%90%E3%83%92%E3%82%99%E3%83%A5%E3%83%BC%E3%83%86%E3%82%A3%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9%E3%80%91%EF%BD%9C%E7%BE%8E%E5%AE%B9%E3%83%A1%E3%83%86%E3%82%99%E3%82%A3%E3%82%A2VOCE%EF%BC%88%E3%82%A6%E3%82%99%E3%82%A9%E3%83%BC%E3%83%81%E3%82%A7%EF%BC%89.jpeg?alt=media&token=5a321559-20af-415b-948e-48c6b7fa45d5",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  AspectRatio(
                                    aspectRatio: 0.5,
                                    child: Image.network(
                                      "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/%E3%80%8C%E7%9B%AE%E6%A8%99%E3%81%AF%E5%AE%89%E9%81%94%E7%A5%90%E5%AE%9F%E3%80%8D%E4%BA%BA%E6%B0%97%E3%82%A2%E3%83%8A%E3%80%90%E5%BC%98%E4%B8%AD%E7%B6%BE%E9%A6%99%E3%80%91%E3%81%AE%E7%BE%8E%E5%AE%B9%E3%82%B9%E3%82%A4%E3%83%83%E3%83%81%E3%81%A8%E3%81%AF%EF%BC%9F%E3%80%90%E3%83%92%E3%82%99%E3%83%A5%E3%83%BC%E3%83%86%E3%82%A3%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9%E3%80%91%EF%BD%9C%E7%BE%8E%E5%AE%B9%E3%83%A1%E3%83%86%E3%82%99%E3%82%A3%E3%82%A2VOCE%EF%BC%88%E3%82%A6%E3%82%99%E3%82%A9%E3%83%BC%E3%83%81%E3%82%A7%EF%BC%89.jpeg?alt=media&token=5a321559-20af-415b-948e-48c6b7fa45d5",
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
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 4.0, right: 5.0, bottom: 5.0, top: 5.0),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              width: 80,
                              height: 80,
                              child: Row(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 0.5,
                                    child: Image.network(
                                      "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/%E3%80%8C%E7%9B%AE%E6%A8%99%E3%81%AF%E5%AE%89%E9%81%94%E7%A5%90%E5%AE%9F%E3%80%8D%E4%BA%BA%E6%B0%97%E3%82%A2%E3%83%8A%E3%80%90%E5%BC%98%E4%B8%AD%E7%B6%BE%E9%A6%99%E3%80%91%E3%81%AE%E7%BE%8E%E5%AE%B9%E3%82%B9%E3%82%A4%E3%83%83%E3%83%81%E3%81%A8%E3%81%AF%EF%BC%9F%E3%80%90%E3%83%92%E3%82%99%E3%83%A5%E3%83%BC%E3%83%86%E3%82%A3%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9%E3%80%91%EF%BD%9C%E7%BE%8E%E5%AE%B9%E3%83%A1%E3%83%86%E3%82%99%E3%82%A3%E3%82%A2VOCE%EF%BC%88%E3%82%A6%E3%82%99%E3%82%A9%E3%83%BC%E3%83%81%E3%82%A7%EF%BC%89.jpeg?alt=media&token=5a321559-20af-415b-948e-48c6b7fa45d5",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  AspectRatio(
                                    aspectRatio: 0.5,
                                    child: Image.network(
                                      "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/%E3%80%8C%E7%9B%AE%E6%A8%99%E3%81%AF%E5%AE%89%E9%81%94%E7%A5%90%E5%AE%9F%E3%80%8D%E4%BA%BA%E6%B0%97%E3%82%A2%E3%83%8A%E3%80%90%E5%BC%98%E4%B8%AD%E7%B6%BE%E9%A6%99%E3%80%91%E3%81%AE%E7%BE%8E%E5%AE%B9%E3%82%B9%E3%82%A4%E3%83%83%E3%83%81%E3%81%A8%E3%81%AF%EF%BC%9F%E3%80%90%E3%83%92%E3%82%99%E3%83%A5%E3%83%BC%E3%83%86%E3%82%A3%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9%E3%80%91%EF%BD%9C%E7%BE%8E%E5%AE%B9%E3%83%A1%E3%83%86%E3%82%99%E3%82%A3%E3%82%A2VOCE%EF%BC%88%E3%82%A6%E3%82%99%E3%82%A9%E3%83%BC%E3%83%81%E3%82%A7%EF%BC%89.jpeg?alt=media&token=5a321559-20af-415b-948e-48c6b7fa45d5",
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
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: StylistPostFirestore.posts
                    // .where('customer_id', isEqualTo: myAccount.id)
                    // .orderBy('created_at', descending: true)
                    .snapshots(),
                builder: (context, postSnapshot) {
                  if (postSnapshot.hasData) {
                    List<String> postAccountIds = [];
                    postSnapshot.data!.docs.forEach((doc) {
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;
                      if (!postAccountIds.contains(data['post_account_id'])) {
                        postAccountIds.add(data['post_account_id']);
                      }
                    });
                    return FutureBuilder<Map<String, Account>?>(
                        future: UserFirestore.getPostUserMap(postAccountIds),
                        builder: (context, userSnapshot) {
                          print(userSnapshot);
                          if (userSnapshot.hasData &&
                              userSnapshot.connectionState ==
                                  ConnectionState.done) {
                            return ListView.builder(
                                itemCount: postSnapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> data =
                                      postSnapshot.data!.docs[index].data()
                                          as Map<String, dynamic>;
                                  StylistPost stylistpost = StylistPost(
                                      poster_image_url: myAccount.imagepath,
                                      customer_id: data['customer_id'],
                                      before_image: data['before_image'],
                                      message_for_customer:
                                          data['message_for_customer'],
                                      after_image: data['after_image'],
                                      postAccountId: data['post_account_id'],
                                      createdTime: data['created_at']);
                                  Account postAccount = userSnapshot
                                      .data![stylistpost.postAccountId]!;
                                  print(stylistpost.before_image);
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 15),
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
                                                      BeforeAfterDetail()),
                                            );
                                          },
                                          child: SlideImage(
                                            beforeimagePhoto:
                                                stylistpost.before_image,
                                            afterimagePhoto:
                                                stylistpost.after_image,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: CircleAvatar(
                                                  radius: 29,
                                                  foregroundImage: NetworkImage(
                                                      postAccount.imagepath),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    width: 250,
                                                    child: Text(stylistpost
                                                        .message_for_customer)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          } else {
                            return Container();
                          }
                        });
                  } else {
                    return Container();
                  }
                }),
          ),
          SizedBox(
            height: 0,
          )
        ],
      ),
    );
  }
}

class SlideImage extends StatefulWidget {
  final List<dynamic>? beforeimagePhoto;
  final List<dynamic>? afterimagePhoto;
  const SlideImage(
      {Key? key, required this.beforeimagePhoto, required this.afterimagePhoto})
      : super(key: key);

  @override
  State<SlideImage> createState() => _SlideImageState();
}

class _SlideImageState extends State<SlideImage> {
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
