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
import 'package:memorys/view/userPageView/before_after.dart';
import 'package:memorys/view/userPageView/user_stylist_account_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedValue = 1;

  bool _isFirstBuild = true;
  Account myAccount = Authentication.myAccount!;
  void initState() {
    super.initState();
  }

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
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
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
          Container(
            height: 100,
            width: 350,
            child: StreamBuilder<QuerySnapshot>(
                stream: _isFirstBuild
                    ? StylistPostFirestore.posts
                        .where('customer_id', isEqualTo: myAccount.id)
                        // .orderBy('created_at', descending: true)
                        .snapshots()
                    : null,
                builder: (context, postSnapshot) {
                  if (postSnapshot.hasData &&
                      !postSnapshot.data!.docs.isEmpty) {
                    List<String> postAccountIds = [];
                    postSnapshot.data!.docs.forEach((doc) {
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;
                      if (!postAccountIds.contains(data['post_account_id'])) {
                        postAccountIds.add(data['post_account_id']);
                      }
                    });
                    Map<String, dynamic> data = postSnapshot.data!.docs[0]
                        .data() as Map<String, dynamic>;

                    var visitTime = data['created_at'];

                    DateTime visitDateTime = visitTime.toDate();

                    final month = DateFormat('M月').format(visitDateTime);
                    final day = DateFormat('d').format(visitDateTime);
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: postSnapshot.data!.docs.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 4.0,
                                  right: 5.0,
                                  bottom: 15.0,
                                  top: 5.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(7.0),
                                child: Container(
                                  width: 80,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 25,
                                        color: Color.fromARGB(255, 171, 223,
                                            173), // Set the color of the upper container here
                                        child: Center(
                                            child: Text(
                                          month,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Color.fromARGB(
                                                  255, 89, 162, 92)),
                                        )),
                                      ),
                                      Expanded(
                                        child: Container(
                                          color: Color.fromARGB(255, 221, 238,
                                              200), // Set the color of the lower container here
                                          child: Center(
                                              child: Text(
                                            day,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                                color: Color.fromARGB(
                                                    255, 89, 162, 92)),
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            Map<String, dynamic> data1 =
                                postSnapshot.data!.docs[index - 1].data()
                                    as Map<String, dynamic>;

                            StylistPost stylistpost = StylistPost(
                                carte_id: data['carte_id'],
                                shop_id: data1['shop_id'],
                                customer_id: data1['customer_id'],
                                favorite_level: data1['favorite_level'],
                                poster_image_url: myAccount.imagepath,
                                before_image: data1['before_image'],
                                message_for_customer:
                                    data1['message_for_customer'],
                                after_image: data1['after_image'],
                                postAccountId: data1['post_account_id'],
                                createdTime: data1['created_at']);

                            final beforeimageUrl = stylistpost.before_image;

                            final afterimageUrl = stylistpost.after_image;

                            return beforeimageUrl != null
                                ? InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BeforeAfterDetail(
                                                  beforeimage:
                                                      stylistpost.before_image,
                                                  afterimage:
                                                      stylistpost.after_image,
                                                  stylistpost: stylistpost,
                                                )),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4.0,
                                          right: 5.0,
                                          bottom: 5.0,
                                          top: 5.0),
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(7.0),
                                            child: Container(
                                              width: 80,
                                              height: 80,
                                              child: Row(
                                                children: [
                                                  AspectRatio(
                                                    aspectRatio: 0.5,
                                                    child: Image.network(
                                                      beforeimageUrl[0],
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  AspectRatio(
                                                    aspectRatio: 0.5,
                                                    child: Image.network(
                                                      afterimageUrl![0],
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
                          }
                        });
                  } else {
                    return Container(
                      child: Text(''),
                    );
                  }
                }),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: StylistPostFirestore.posts
                    .where('customer_id', isEqualTo: myAccount.id)
                    // .orderBy('created_at', descending: true)
                    .snapshots(),
                builder: (context, postSnapshot) {
                  if (!postSnapshot.hasData ||
                      postSnapshot.data!.docs.isEmpty) {
                    print(postSnapshot);
                    return Column(
                      children: [
                        SizedBox(
                          height: 90,
                        ),
                        Container(
                          child: Text(
                            "まだカルテがありません",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        Container(
                            height: 180,
                            child: Image(
                              image: NetworkImage(
                                  "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/lonely.png?alt=media&token=642b03bd-a4d6-4d9d-8230-789928967af4"),
                            )),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          child: Text(
                            "美容室に行きあなたの写真を撮ってもらいましょう\nBeforeAfterがあなたの美容記録として残ります。",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  }
                  List<String> postAccountIds = [];
                  List docList = [];

                  postSnapshot.data!.docs.forEach((doc) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;

                    docList.add(doc.id);
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
                                  id: docList[index],
                                  carte_id: data['carte_id'],
                                  shop_id: data['shop_id'],
                                  is_favorite: data['is_favorite'],
                                  favorite_level: data['favorite_level'],
                                  poster_image_url: myAccount.imagepath,
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
                                              stylistPostInfo: stylistpost,
                                            ),
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
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  UserStylistAccountPage(
                                                                    stylist:
                                                                        postAccount,
                                                                  )),
                                                        );
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0),
                                                        child: CircleAvatar(
                                                          radius: 25,
                                                          foregroundImage:
                                                              CachedNetworkImageProvider(
                                                                  postAccount
                                                                      .imagepath),
                                                        ),
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
                    child: widget.stylistPostInfo.is_favorite
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.favorite,
                                  color: AppColors.thirdColor,
                                  size: 35,
                                ),
                                Text(
                                  widget.stylistPostInfo.favorite_level
                                      .toString(), // ここに表示したい数字を入力
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.favorite_outline,
                              color: Color.fromARGB(255, 249, 249, 249),
                              size: 35,
                            ),
                          ),
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
