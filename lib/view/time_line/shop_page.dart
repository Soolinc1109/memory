import 'package:adobe_xd/adobe_xd.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/model/post.dart';
import 'package:memorys/model/shop.dart';
import 'package:memorys/utils/firestore/posts.dart';
import 'package:memorys/utils/firestore/shops.dart';
import 'package:memorys/utils/firestore/users.dart';
import 'package:memorys/view/time_line/post_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(45),
          child: AppBar(
            centerTitle: false,
            title: Text(
              "Memory's",
              style: TextStyle(
                fontFamily: 'ITF Devanagari Marathi',
                fontSize: 30,
                color: const Color(0xff000000),
                fontWeight: FontWeight.w300,
                height: 1.2,
              ),
              textHeightBehavior:
                  TextHeightBehavior(applyHeightToFirstAscent: false),
              softWrap: false,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PostPage()),
                  );
                },
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.favorite_border,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.comment_outlined,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(color: Colors.grey, width: 0),
              )),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CircleAvatar(
                          radius: 42,
                          foregroundImage:
                              NetworkImage(ShopFirestore.shopList[0].logoImage),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Earth',
                                        style: TextStyle(
                                          fontFamily: 'Oriya MN',
                                          fontSize: 25,
                                          color: const Color(0xff707070),
                                        ),
                                        softWrap: false,
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        height: 35,
                                        width: 120,
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xffffaddd),
                                                borderRadius:
                                                    BorderRadius.circular(11.0),
                                              ),
                                            ),
                                            Pinned.fromPins(
                                              Pin(start: 12, end: 0),
                                              Pin(size: 20.0, middle: 0.4),
                                              child: Text(
                                                '指名して予約',
                                                style: TextStyle(
                                                  fontFamily: 'Oriya MN',
                                                  fontSize: 16,
                                                  color:
                                                      const Color(0xffffffff),
                                                  shadows: [
                                                    Shadow(
                                                      color: const Color(
                                                          0x29000000),
                                                      blurRadius: 6,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SlideImage(
                    beforeimagePhoto: ShopFirestore.shopList[0].shopImage!,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            )),
            Expanded(
              child: Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 250,
                      color: const Color(0xfffff5fc),
                    ),
                    Pinned.fromPins(
                      Pin(size: 150.0, middle: 0.15),
                      Pin(size: 84.0, start: 18.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffffffff),
                          borderRadius: BorderRadius.circular(26.0),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x29000000),
                              offset: Offset(0, 1),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Pinned.fromPins(
                      Pin(size: 150.0, middle: 0.15),
                      Pin(size: 84.0, end: 200.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffffffff),
                          borderRadius: BorderRadius.circular(26.0),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x29000000),
                              offset: Offset(0, 1),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Pinned.fromPins(
                      Pin(size: 150.0, end: 32.0),
                      Pin(size: 84.0, start: 18.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffffffff),
                          borderRadius: BorderRadius.circular(26.0),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x29000000),
                              offset: Offset(0, 1),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Pinned.fromPins(
                      Pin(size: 150.0, end: 32.0),
                      Pin(size: 84.0, end: 200.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffffffff),
                          borderRadius: BorderRadius.circular(26.0),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x29000000),
                              offset: Offset(0, 1),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(0.68, -0.76),
                      child: SizedBox(
                        width: 124.0,
                        height: 25.0,
                        child: Text(
                          'スタイリスト',
                          style: TextStyle(
                            fontFamily: 'Oriya MN',
                            fontSize: 21,
                            color: const Color(0xff707070),
                          ),
                          softWrap: false,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(-0.62, -0.76),
                      child: SizedBox(
                        width: 124.0,
                        height: 25.0,
                        child: Text(
                          'ヘアカタログ',
                          style: TextStyle(
                            fontFamily: 'Oriya MN',
                            fontSize: 21,
                            color: const Color(0xff707070),
                          ),
                          softWrap: false,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(-0.5, -0.2),
                      child: SizedBox(
                        width: 63.0,
                        height: 25.0,
                        child: Text(
                          '口コミ',
                          style: TextStyle(
                            fontFamily: 'Oriya MN',
                            fontSize: 21,
                            color: const Color(0xff707070),
                          ),
                          softWrap: false,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(0.58, -0.2),
                      child: SizedBox(
                        width: 84.0,
                        height: 25.0,
                        child: Text(
                          'クーポン',
                          style: TextStyle(
                            fontFamily: 'Oriya MN',
                            fontSize: 21,
                            color: const Color(0xff707070),
                          ),
                          softWrap: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SlideImage extends StatefulWidget {
  final List<dynamic> beforeimagePhoto;

  const SlideImage({Key? key, required this.beforeimagePhoto})
      : super(key: key);

  @override
  State<SlideImage> createState() => _SlideImageState();
}

class _SlideImageState extends State<SlideImage> {
  List beforeimages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    beforeimages = widget.beforeimagePhoto;
  }

  int activeIndex = 0;
  Widget buildImage(beforepath, index) => Row(
        children: [
          Column(
            children: [
              Container(
                height: 230,
                width: 360,
                color: Colors.grey,
                child: Image.network(
                  beforepath,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 10,
          ),
        ],
      );

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: 3,
        //エフェクトはドキュメントを見た方がわかりやすい
        effect: JumpingDotEffect(
            dotHeight: 10,
            dotWidth: 10,
            activeDotColor: Colors.green,
            dotColor: Colors.black12),
      );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        CarouselSlider.builder(
          itemCount: 3,
          itemBuilder: (context, index, realIndex) {
            final beforepath = beforeimages[index];

            return buildImage(beforepath, index);
          },
          options: CarouselOptions(
            height: 250,
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
