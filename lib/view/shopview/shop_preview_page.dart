import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/model/shop/menu.dart';
import 'package:memorys/model/shop/shop.dart';
import 'package:memorys/utils/color.dart';
import 'package:memorys/utils/firestore/shops.dart';
import 'package:memorys/utils/firestore/users.dart';
import 'package:memorys/view/userPageView/style_detail_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/authentication.dart';

class ShopPreviewPage extends StatefulWidget {
  const ShopPreviewPage({Key? key}) : super(key: key);

  @override
  _ShopPreviewPageState createState() => _ShopPreviewPageState();
}

class _ShopPreviewPageState extends State<ShopPreviewPage> {
  Account myAccount = Authentication.myAccount!;
  void initState() {
    super.initState();
  }

  Future<List<Menu>> _fetchMenus() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Shop')
        .doc(myAccount.shopId)
        .collection('service')
        .get();

    return snapshot.docs.map((doc) => Menu.fromDocument(doc)).toList();
  }

  // 長いテキストをここに入れてください。

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: StreamBuilder<Shop>(
            stream: ShopFirestore.getShop(myAccount.shopId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError || !snapshot.hasData) {
                return Center(child: Text('データを取得できませんでした。'));
              } else {
                final Shop shop = snapshot.data!;
                return Column(
                  children: [
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                        bottom:
                            BorderSide(color: AppColors.primaryColor, width: 0),
                      )),
                      child: FutureBuilder(
                          future: _fetchMenus(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Menu>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Center(child: Text('エラーが発生しました'));
                            }
                            List<Menu> menus = snapshot.data!;

                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    height: 300,
                                    child: SlideImage(
                                      beforeimagePhoto: [
                                        shop.shop_front_image_0,
                                        shop.shop_front_image_1,
                                        shop.shop_front_image_2
                                      ],
                                      shopName: shop.name,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 38.0),
                                    child: InkWell(
                                      onTap: () async {
                                        const url =
                                            'https://beauty.hotpepper.jp/slnH000595471/style/L169427111.html';
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.favorite,
                                              color: AppColors.secondaryColor,
                                            ),
                                            SizedBox(width: 10.0),
                                            Text(
                                              '予約する',
                                              style: TextStyle(
                                                color: AppColors.secondaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: TextExpansion(
                                      shopintroduction: shop.shopIntroduction,
                                    ),
                                  ),
                                  Center(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 18.0),
                                      child: Container(
                                        color: Colors.white,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "スタイリスト",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 90,
                                                  child: FutureBuilder(
                                                      future: UserFirestore
                                                          .getImagePathsByIds(
                                                              shop.staff),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<
                                                                  List<String>>
                                                              snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        } else if (snapshot
                                                            .hasError) {
                                                          return Center(
                                                            child: Text(
                                                                'Error: ${snapshot.error}'),
                                                          );
                                                        } else {
                                                          List<String>
                                                              imagePaths =
                                                              snapshot.data!;
                                                          return ListView
                                                              .builder(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemCount:
                                                                imagePaths
                                                                    .length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              final List<String>
                                                                  imageStylistUrls =
                                                                  imagePaths;

                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            15.0,
                                                                        right:
                                                                            5.0,
                                                                        bottom:
                                                                            5.0,
                                                                        top:
                                                                            5.0),
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30.0),
                                                                    image:
                                                                        DecorationImage(
                                                                      image: NetworkImage(
                                                                          imageStylistUrls[
                                                                              index]),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                  width: 80,
                                                                  height: 80,
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        }
                                                      }),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          "メニュー",
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
                                      padding:
                                          const EdgeInsets.only(left: 14.0),
                                      child: SizedBox(
                                        height: 240,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: menus.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final menu = snapshot.data![index];
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
                                                                  .circular(15),
                                                            ),
                                                            image:
                                                                DecorationImage(
                                                              image: NetworkImage(
                                                                  menu.menu_image),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          width: 120,
                                                          height: 170,
                                                        ),
                                                      ),
                                                      Container(
                                                        color: Colors.white,
                                                        width: 120,
                                                        height: 70,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(2),
                                                          child: Column(
                                                            children: [
                                                              Align(
                                                                alignment: Alignment
                                                                    .bottomLeft,
                                                                child: Text(
                                                                  menu.name,
                                                                  maxLines: 2,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
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
                                                                        Alignment
                                                                            .bottomLeft,
                                                                    child: Text(
                                                                      '￥${menu.price}',
                                                                      style: TextStyle(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              54,
                                                                              171,
                                                                              244),
                                                                          fontSize:
                                                                              13,
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
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          width: 120,
                                                          height: 170,
                                                        ),
                                                      ),
                                                      Container(
                                                        color: Colors.white,
                                                        width: 120,
                                                        height: 70,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(2),
                                                          child: Column(
                                                            children: [
                                                              Align(
                                                                alignment: Alignment
                                                                    .bottomLeft,
                                                                child: Text(
                                                                  menu.name,
                                                                  maxLines: 2,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
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
                                                                        Alignment
                                                                            .bottomLeft,
                                                                    child: Text(
                                                                      '￥${menu.price}',
                                                                      style: TextStyle(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              54,
                                                                              171,
                                                                              244),
                                                                          fontSize:
                                                                              13,
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
                                                  );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            );
                          }),
                    )),
                  ],
                );
              }
            },
          )),
    );
  }
}

class TextExpansion extends StatefulWidget {
  final String shopintroduction;

  const TextExpansion({Key? key, required this.shopintroduction})
      : super(key: key);
  @override
  _TextExpansionState createState() => _TextExpansionState();
}

class _TextExpansionState extends State<TextExpansion> {
  bool _showFullText = false;
  bool _showMoreButton = false;

  @override
  Widget build(BuildContext context) {
    final String _text = widget.shopintroduction;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final textPainter = TextPainter(
              text: TextSpan(
                  text: _text,
                  style:
                      DefaultTextStyle.of(context).style.copyWith(height: 1)),
              textDirection: TextDirection.ltr,
              maxLines: 3,
            )..layout(maxWidth: constraints.maxWidth);

            if (!_showFullText &&
                !_showMoreButton &&
                textPainter.didExceedMaxLines) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _showMoreButton = true;
                });
              });
            }

            return Text(
              _text,
              maxLines: _showFullText ? 10 : 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(height: 1.5),
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
              style: TextStyle(fontSize: 11, color: AppColors.secondaryColor),
            ),
          ),
      ],
    );
  }
}

class SlideImage extends StatefulWidget {
  final List<String> beforeimagePhoto;
  final String shopName;

  const SlideImage(
      {Key? key, required this.beforeimagePhoto, required this.shopName})
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
  Widget buildImage(beforepath, index, screenWidth) => Stack(
        children: [
          Container(
            height: 295,
            width: screenWidth,
            color: Color.fromARGB(255, 204, 204, 204),
            child: Image.network(
              beforepath,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.25),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10.0,
            left: 10.0,
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Text(
                widget.shopName,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
        ],
      );

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: 3,
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
        CarouselSlider.builder(
          itemCount: 3,
          itemBuilder: (context, index, realIndex) {
            final beforepath = beforeimages[index];

            return buildImage(beforepath, index, screenWidth);
          },
          options: CarouselOptions(
            height: 295,
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
