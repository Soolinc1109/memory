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

class StylistShopPage extends StatefulWidget {
  String shopId;
  StylistShopPage({Key? key, required this.shopId}) : super(key: key);

  @override
  _StylistShopPageState createState() => _StylistShopPageState();
}

class _StylistShopPageState extends State<StylistShopPage> {
  bool _isLoading = false;

  Account myAccount = Authentication.myAccount!;
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  Future<List<Menu>> _fetchMenus() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Shop')
        .doc(myAccount.shopId)
        .collection('service')
        .get();

    return snapshot.docs.map((doc) => Menu.fromDocument(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.shopId);
    return Container(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: StreamBuilder<Shop>(
            stream: ShopFirestore.getShop(widget.shopId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError || !snapshot.hasData) {
                return Center(child: Text('データを取得できませんでした。'));
              } else {
                final Shop shop = snapshot.data!;
                if (shop.shopFrontImages == null) {
                  return Container();
                }
                return FutureBuilder(
                    future: _fetchMenus(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Menu>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('エラーが発生しました'));
                      }
                      List<Menu> menus = snapshot.data!;

                      return Column(
                        children: [
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                  color: AppColors.primaryColor, width: 0),
                            )),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    height: 300,
                                    child: SlideImage(
                                      beforeimagePhoto: shop.shopFrontImages
                                          .whereType<String>()
                                          .toList(),
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
                                        String url = shop.snsUrl![0];
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
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          "メニュ",
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
                                        child: menus.length == 0
                                            ? Container(
                                                child: Text("メニューがありません"),
                                              )
                                            : ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: menus.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  final menu =
                                                      snapshot.data?[index];
                                                  print(
                                                      '=========================');

                                                  if (menu == null) {
                                                    return Container(
                                                      child: Text("data"),
                                                    );
                                                  }
                                                  print(menu.id);
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
                                                              child:
                                                                  ConstrainedBox(
                                                                constraints:
                                                                    BoxConstraints(
                                                                        maxWidth:
                                                                            120,
                                                                        maxHeight:
                                                                            170),
                                                                child:
                                                                    Container(
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
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            if (myAccount.menu_id ==
                                                                                null) {
                                                                              print("no Data");
                                                                            }
                                                                            print(myAccount.menu_id![0]);
                                                                            print(myAccount.id);
                                                                            print(menu.id);
                                                                            myAccount.menu_id?.contains(menu.id) ?? false
                                                                                ? showDialog(
                                                                                    context: context,
                                                                                    builder: (BuildContext context) {
                                                                                      print(myAccount.menu_id);
                                                                                      return AlertDialog(
                                                                                        title: Text('メニュー削除'),
                                                                                        content: Text('このメニューをあなたのメニューに削除しますか？'),
                                                                                        actions: <Widget>[
                                                                                          TextButton(
                                                                                            child: Text('閉じる'),
                                                                                            onPressed: () {
                                                                                              Navigator.of(context).pop();
                                                                                            },
                                                                                          ),
                                                                                          TextButton(
                                                                                              child: Text('メニュー削除'),
                                                                                              onPressed: _isLoading
                                                                                                  ? null
                                                                                                  : () async {
                                                                                                      setState(() {
                                                                                                        _isLoading = true;
                                                                                                      });

                                                                                                      if (myAccount.menu_id == null) {
                                                                                                        myAccount.menu_id = [menu.id];
                                                                                                      } else {
                                                                                                        myAccount.menu_id!.add(menu.id);
                                                                                                      }

                                                                                                      if (menu.stylist_ids == null) {
                                                                                                        menu.stylist_ids = [myAccount.id];
                                                                                                      } else {
                                                                                                        menu.stylist_ids!.add(myAccount.id);
                                                                                                      }
                                                                                                    }),
                                                                                        ],
                                                                                      );
                                                                                    },
                                                                                  )
                                                                                : showDialog(
                                                                                    context: context,
                                                                                    builder: (BuildContext context) {
                                                                                      print(myAccount.menu_id);
                                                                                      return AlertDialog(
                                                                                        title: Text('メニュー登録'),
                                                                                        content: Text('このメニューをあなたのメニューに追加しますか？'),
                                                                                        actions: <Widget>[
                                                                                          TextButton(
                                                                                            child: Text('閉じる'),
                                                                                            onPressed: () {
                                                                                              Navigator.of(context).pop();
                                                                                            },
                                                                                          ),
                                                                                          TextButton(
                                                                                              child: Text('メニュー追加'),
                                                                                              onPressed: _isLoading
                                                                                                  ? null
                                                                                                  : () async {
                                                                                                      setState(() {
                                                                                                        _isLoading = true;
                                                                                                      });

                                                                                                      if (myAccount.menu_id == null) {
                                                                                                        myAccount.menu_id = [menu.id];
                                                                                                      } else {
                                                                                                        myAccount.menu_id!.add(menu.id);
                                                                                                      }

                                                                                                      if (menu.stylist_ids == null) {
                                                                                                        menu.stylist_ids = [myAccount.id];
                                                                                                      } else {
                                                                                                        menu.stylist_ids!.add(myAccount.id);
                                                                                                      }

                                                                                                      final result = await UserFirestore.updateUser(myAccount);
                                                                                                      final result2 = await ShopFirestore.updateMenu(myAccount.shopId, menu.id, menu);

                                                                                                      if (result && result2) {
                                                                                                        Navigator.pop(context, true);
                                                                                                        _isLoading = false;
                                                                                                      } else {
                                                                                                        showDialog(
                                                                                                          context: context,
                                                                                                          builder: (BuildContext context) {
                                                                                                            return AlertDialog(
                                                                                                              title: Text('エラー'),
                                                                                                              content: Text('ユーザー情報の更新に失敗しました。'),
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
                                                                                                    }),
                                                                                        ],
                                                                                      );
                                                                                    },
                                                                                  );
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(2.0),
                                                                            child:
                                                                                Icon(
                                                                              myAccount.menu_id?.contains(menu.id) ?? false ? Icons.remove_circle_outline : Icons.add_box,
                                                                              color: Color.fromARGB(255, 208, 208, 208),
                                                                            ),
                                                                          ),
                                                                        )
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
                                                              child:
                                                                  ConstrainedBox(
                                                                constraints:
                                                                    BoxConstraints(
                                                                        maxWidth:
                                                                            120,
                                                                        maxHeight:
                                                                            170),
                                                                child:
                                                                    Container(
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
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            showDialog(
                                                                              context: context,
                                                                              builder: (BuildContext context) {
                                                                                return AlertDialog(
                                                                                  title: Text('メニュー登録'),
                                                                                  content: Text('このメニューをあなたのメニューに追加しますか？'),
                                                                                  actions: <Widget>[
                                                                                    TextButton(
                                                                                      child: Text('閉じる'),
                                                                                      onPressed: () {
                                                                                        Navigator.of(context).pop();
                                                                                      },
                                                                                    ),
                                                                                    TextButton(
                                                                                        child: Text('メニュー追加'),
                                                                                        onPressed: _isLoading
                                                                                            ? null
                                                                                            : () async {
                                                                                                setState(() {
                                                                                                  _isLoading = true;
                                                                                                });

                                                                                                if (myAccount.menu_id == null) {
                                                                                                  myAccount.menu_id = [menu.id];
                                                                                                } else {
                                                                                                  myAccount.menu_id!.add(menu.id);
                                                                                                }

                                                                                                if (menu.stylist_ids == null) {
                                                                                                  menu.stylist_ids = [myAccount.id];
                                                                                                } else {
                                                                                                  menu.stylist_ids!.add(myAccount.id);
                                                                                                }

                                                                                                final result = await UserFirestore.updateUser(myAccount);
                                                                                                final result2 = await ShopFirestore.updateMenu(myAccount.shopId, menu.id, menu);

                                                                                                if (result && result2) {
                                                                                                  Navigator.pop(context, true);
                                                                                                  _isLoading = false;
                                                                                                } else {
                                                                                                  showDialog(
                                                                                                    context: context,
                                                                                                    builder: (BuildContext context) {
                                                                                                      return AlertDialog(
                                                                                                        title: Text('エラー'),
                                                                                                        content: Text('ユーザー情報の更新に失敗しました。'),
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
                                                                                              }),
                                                                                  ],
                                                                                );
                                                                              },
                                                                            );
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(2.0),
                                                                            child:
                                                                                Icon(
                                                                              myAccount.menu_id?.contains(menu.id) ?? false ? Icons.remove_circle_outline : Icons.add_box,
                                                                              color: Color.fromARGB(255, 208, 208, 208),
                                                                            ),
                                                                          ),
                                                                        )
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
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          )),
                        ],
                      );
                    });
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
