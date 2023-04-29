import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/model/shop/stylistpost.dart';
import 'package:memorys/utils/authentication.dart';
import 'package:memorys/utils/color.dart';
import 'package:memorys/utils/firestore/stylistposts.dart';
import 'package:memorys/utils/firestore/users.dart';
import 'package:memorys/view/stylistView/resister_customer_page.dart';
import 'package:memorys/view/userPageView/before_after.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class StylistPostPage extends StatefulWidget {
  const StylistPostPage({Key? key}) : super(key: key);

  @override
  _StylistPostPageState createState() => _StylistPostPageState();
}

class _StylistPostPageState extends State<StylistPostPage> {
  Account myAccount = Authentication.myAccount!;
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: StylistPostFirestore.posts
                    .where('post_account_id', isEqualTo: myAccount.id)
                    // .orderBy('created_at', descending: true)
                    .snapshots(),
                builder: (context, postSnapshot) {
                  if (!postSnapshot.hasData ||
                      postSnapshot.data!.docs.isEmpty) {
                    print(postSnapshot);
                    return Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 100,
                          ),
                          Container(
                            child: Text(
                              "カルテを登録しよう！",
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
                                      builder: (context) =>
                                          ResisterCustomerPage()),
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
                                        BorderRadius.circular(15), // 角丸を追加
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
                                    child: Text('カルテを登録',
                                        style: TextStyle(
                                          fontSize: 20, // フォントサイズを大きくする
                                          fontWeight:
                                              FontWeight.bold, // フォントを太くする
                                          color: Colors.white, // テキストの色を白にする
                                        )),
                                  ))),
                        ],
                      ),
                    );
                  }
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
                              Map<String, dynamic> data =
                                  postSnapshot.data!.docs[index].data()
                                      as Map<String, dynamic>;
                              final stylistpost = StylistPost(
                                  carte_id: data['carte_id'],
                                  poster_image_url: myAccount.imagepath,
                                  shop_id: data['shop_id'],
                                  customer_id: data['customer_id'],
                                  before_image: data['before_image'],
                                  message_for_customer:
                                      data['message_for_customer'],
                                  after_image: data['after_image'],
                                  postAccountId: data['post_account_id'],
                                  createdTime: data['created_at']);
                              final postAccount = userSnapshot
                                  .data![stylistpost.postAccountId]!;

                              return postAccount == null
                                  ? Container(
                                      child: Text(''),
                                    )
                                  : Container(
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
                                            child: SlideImage(
                                                beforeimagePhoto:
                                                    stylistpost.before_image,
                                                afterimagePhoto:
                                                    stylistpost.after_image,
                                                stylistPostInfo: stylistpost),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: CircleAvatar(
                                                        radius: 25,
                                                        foregroundImage:
                                                            CachedNetworkImageProvider(
                                                                postAccount
                                                                    .imagepath),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 8.0),
                                                      child: Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          width: screenWidth /
                                                              1.666,
                                                          child: Text(stylistpost
                                                              .message_for_customer)),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      DateFormat('M月d日').format(
                                                          stylistpost
                                                              .createdTime!
                                                              .toDate()),
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                  ],
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
  final StylistPost stylistPostInfo;
  const SlideImage(
      {Key? key,
      required this.beforeimagePhoto,
      required this.afterimagePhoto,
      required this.stylistPostInfo})
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
    print(widget.stylistPostInfo.is_favorite);
  }

  int activeIndex = 0;
  Widget buildImage(beforepath, afterpath, index, screenWidth) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Column(
                children: [
                  Container(
                    height: 230,
                    width: screenWidth / 2.13,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6)), // 角丸の半径を指定（例: 15）
                      color: Colors.grey,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          beforepath,
                        ),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) => Icon(Icons.error),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6), // 角丸の半径を指定（例: 15）
                      child: CachedNetworkImage(
                        imageUrl: beforepath,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => SizedBox(
                          height: 20, // 変更する高さを指定（例: 20）
                          width: 20, // 変更する幅を指定（例: 20）
                          child: CircularProgressIndicator(
                            value: downloadProgress.progress,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.pink), // ピンク色に設定
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            'Before',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            width: screenWidth / 50,
          ),
          Column(
            children: [
              Stack(children: [
                Container(
                  height: 230,
                  width: screenWidth / 2.13,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6)),
                    color: Colors.grey,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        beforepath,
                      ),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) => Icon(Icons.error),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6), // 角丸の半径を指定（例: 15）
                    child: CachedNetworkImage(
                      imageUrl: afterpath,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => SizedBox(
                        height: 20, // 変更する高さを指定（例: 20）
                        width: 20, // 変更する幅を指定（例: 20）
                        child: CircularProgressIndicator(
                          value: downloadProgress.progress,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.pink), // ピンク色に設定
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
                Positioned(
                  top: 0, // アイコンの上端からの位置を調整
                  right: 0, // アイコンの右端からの位置を調整
                  child: InkWell(
                    onTap: () {
                      int _count = 3;

                      void _incrementCounter() {
                        if (_count < 10) {
                          _count = _count + 1;
                        }
                      }

                      void _decrementCounter() {
                        if (_count > 0) {
                          _count = _count - 1;
                        }
                      }

                      bool is_loading = false;
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                title: Text('髪型をどれくらい気に入りましたか(10段階)'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '$_count',
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                    SizedBox(height: 20.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 38.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                height: 40.0,
                                                width: 40.0,
                                                child: FloatingActionButton(
                                                  onPressed: () {
                                                    setState(_decrementCounter);
                                                  },
                                                  tooltip: 'Decrement',
                                                  child: Icon(Icons.remove),
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 164, 177, 255),
                                                  elevation: 6.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 100.0,
                                          width: 100.0,
                                          child: FloatingActionButton(
                                            onPressed: () {
                                              setState(_incrementCounter);
                                            },
                                            tooltip: 'Increment',
                                            child: Icon(Icons.add),
                                            backgroundColor: Colors.pink,
                                            elevation: 6.0,
                                          ),
                                        ),
                                        Container(
                                          width: 35,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('閉じる'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () async {
                                      if (is_loading == true) {
                                        return;
                                      }

                                      final updatePost = StylistPost(
                                          carte_id:
                                              widget.stylistPostInfo.carte_id,
                                          favorite_level: _count,
                                          is_favorite: true,
                                          shop_id:
                                              widget.stylistPostInfo.shop_id,
                                          message_for_customer: widget
                                              .stylistPostInfo
                                              .message_for_customer,
                                          customer_id: widget
                                              .stylistPostInfo.customer_id,
                                          postAccountId:
                                              Authentication.myAccount!.id);
                                      var _result = await StylistPostFirestore
                                          .updateStylistPost(
                                              widget.stylistPostInfo.id,
                                              updatePost);

                                      if (_result) {
                                        Navigator.pop(context, true);
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                )
              ]),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        'After',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              )
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
            height: 270,
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
