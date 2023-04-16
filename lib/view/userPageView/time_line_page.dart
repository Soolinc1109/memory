import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/model/stylistpost.dart';
import 'package:memorys/utils/authentication.dart';
import 'package:memorys/utils/firestore/stylistposts.dart';
import 'package:memorys/utils/firestore/users.dart';
import 'package:memorys/view/userPageView/before_after.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
                padding: const EdgeInsets.only(left: 35.0),
                child: Text(
                  "あなたのmemory",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 40,
                width: 350,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    //省略
                  ],
                ),
              ),
            ],
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
                                          Row(
                                            children: [
                                              Text(
                                                DateFormat('M月d日 kk:mm').format(
                                                    stylistpost.createdTime!
                                                        .toDate()),
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ],
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
                child: CachedNetworkImage(
                  imageUrl: beforepath,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      SizedBox(
                    height: 20, // 変更する高さを指定（例: 20）
                    width: 20, // 変更する幅を指定（例: 20）
                    child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.pink), // ピンク色に設定
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
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
                child: CachedNetworkImage(
                  imageUrl: afterpath,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      SizedBox(
                    height: 20, // 変更する高さを指定（例: 20）
                    width: 20, // 変更する幅を指定（例: 20）
                    child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.pink), // ピンク色に設定
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
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
