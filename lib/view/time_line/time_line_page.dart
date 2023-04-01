import 'package:adobe_xd/adobe_xd.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/model/post.dart';
import 'package:memorys/utils/firestore/posts.dart';
import 'package:memorys/utils/firestore/users.dart';
import 'package:memorys/view/time_line/before_after.dart';
import 'package:memorys/view/time_line/post_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Column(
        children: [
          Expanded(
            child: Container(
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
                        if (!postAccountIds.contains(data['post_account_id'])) {
                          postAccountIds.add(data['post_account_id']);
                        }
                      });
                      return FutureBuilder<Map<String, Account>?>(
                          future: UserFirestore.getPostUserMap(postAccountIds),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.hasData &&
                                userSnapshot.connectionState ==
                                    ConnectionState.done) {
                              return ListView.builder(
                                  itemCount: postSnapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> data =
                                        postSnapshot.data!.docs[index].data()
                                            as Map<String, dynamic>;
                                    Post post = Post(
                                        id: postSnapshot.data!.docs[index].id,
                                        content: data['content'],
                                        beforeImage: data['beforeImage'],
                                        afterImage: data['afterImage'],
                                        postAccountId: data['post_account_id'],
                                        createdTime: data['created_time']);
                                    print(post.beforeImage);
                                    Account postAccount =
                                        userSnapshot.data![post.postAccountId]!;

                                    return Container(
                                      decoration: BoxDecoration(
                                          border: index == 0
                                              ? Border(
                                                  top: BorderSide(
                                                      color: Colors.grey,
                                                      width: 0),
                                                  bottom: BorderSide(
                                                      color: Colors.grey,
                                                      width: 0),
                                                )
                                              : Border(
                                                  bottom: BorderSide(
                                                      color: Colors.grey,
                                                      width: 0),
                                                )),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 15),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: CircleAvatar(
                                                  radius: 32,
                                                  foregroundImage: AssetImage(
                                                      'images/ushizima.jpg'),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                '牛島 彩貴',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Oriya MN',
                                                                  fontSize: 25,
                                                                  color: const Color(
                                                                      0xff707070),
                                                                ),
                                                                softWrap: false,
                                                              )
                                                            ],
                                                          ),
                                                          Column(
                                                            children: [
                                                              Text(DateFormat(
                                                                      'M/d/yy')
                                                                  .format(post
                                                                      .createdTime!
                                                                      .toDate())),
                                                              Container(
                                                                height: 35,
                                                                width: 120,
                                                                child: Stack(
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: const Color(
                                                                            0xffffaddd),
                                                                        borderRadius:
                                                                            BorderRadius.circular(11.0),
                                                                      ),
                                                                    ),
                                                                    Pinned
                                                                        .fromPins(
                                                                      Pin(
                                                                          start:
                                                                              12,
                                                                          end:
                                                                              0),
                                                                      Pin(
                                                                          size:
                                                                              20.0,
                                                                          middle:
                                                                              0.4),
                                                                      child:
                                                                          Text(
                                                                        '指名して予約',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'Oriya MN',
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              const Color(0xffffffff),
                                                                          shadows: [
                                                                            Shadow(
                                                                              color: const Color(0x29000000),
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
                                                      // Container(
                                                      //   decoration: BoxDecoration(
                                                      //     image: DecorationImage(
                                                      //       image: const AssetImage(
                                                      //           'images/DFCC3920-806A-4147-944B-A89B5606425C.png'),
                                                      //       fit: BoxFit.cover,
                                                      //     ),
                                                      //   ),
                                                      // )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
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
                                                  post.beforeImage!,
                                              afterimagePhoto: post.afterImage!,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            height: 23,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Stack(
                                                children: <Widget>[
                                                  Pinned.fromPins(
                                                    Pin(size: 22, start: 0.0),
                                                    Pin(start: 0.0, end: 0.0),
                                                    child: SvgPicture.string(
                                                      '<svg viewBox="14.0 701.0 29.3 28.1" ><path transform="translate(10.63, 697.06)" d="M 24.75 3.9375 C 24.75 3.9375 24.75 3.9375 24.75 3.9375 C 24.75 3.9375 24.75 3.9375 24.75 3.9375 C 24.72890663146973 3.9375 24.70078086853027 3.9375 24.6796875 3.9375 C 21.88828086853027 3.9375 19.42031288146973 5.4140625 18 7.59375 C 16.57968711853027 5.4140625 14.11171913146973 3.9375 11.3203125 3.9375 C 11.29921913146973 3.9375 11.27109336853027 3.9375 11.25 3.9375 C 11.25 3.9375 11.25 3.9375 11.25 3.9375 C 11.25 3.9375 11.25 3.9375 11.25 3.9375 C 6.897656440734863 3.979687452316284 3.375 7.516406059265137 3.375 11.8828125 C 3.375 14.484375 4.514062404632568 18.17578125 6.735937595367432 21.21328163146973 C 10.96875 27 18 32.0625 18 32.0625 C 18 32.0625 25.03125 27 29.26406288146973 21.21328163146973 C 31.48593711853027 18.17578125 32.625 14.484375 32.625 11.8828125 C 32.625 7.516406059265137 29.10234451293945 3.979687452316284 24.75 3.9375 Z M 27.67499923706055 20.05312538146973 C 24.6796875 24.15234375 20.11640548706055 27.93515586853027 18 29.58749961853027 C 15.88359355926514 27.93515586853027 11.3203125 24.14531326293945 8.324999809265137 20.04609298706055 C 6.264843940734863 17.23359298706055 5.34375 13.921875 5.34375 11.8828125 C 5.34375 10.29374980926514 5.962500095367432 8.803125381469727 7.073437690734863 7.678124904632568 C 8.19140625 6.553124904632568 9.675000190734863 5.927343368530273 11.26406288146973 5.913281440734863 C 11.26406288146973 5.913281440734863 11.26406288146973 5.913281440734863 11.27109432220459 5.913281440734863 C 11.28515720367432 5.913281440734863 11.29921913146973 5.913281440734863 11.31328201293945 5.913281440734863 L 11.32734489440918 5.913281440734863 C 12.33281326293945 5.913281440734863 13.33125114440918 6.173437595367432 14.21718883514404 6.672656536102295 C 15.07500171661377 7.157812595367432 15.82031345367432 7.846875190734863 16.35468864440918 8.676563262939453 C 16.72031402587891 9.23203182220459 17.33906364440918 9.56953239440918 18.00703239440918 9.56953239440918 C 18.67500114440918 9.56953239440918 19.29375076293945 9.232032775878906 19.65937614440918 8.676563262939453 C 20.20078277587891 7.846875667572021 20.93906402587891 7.15781307220459 21.79687690734863 6.672657012939453 C 22.68281364440918 6.17343807220459 23.68125152587891 5.913281917572021 24.68671989440918 5.913281917572021 L 24.70078277587891 5.913281917572021 C 24.71484565734863 5.913281917572021 24.72890853881836 5.913281917572021 24.74296951293945 5.913281917572021 C 24.74296951293945 5.913281917572021 24.74296951293945 5.913281917572021 24.75 5.913281917572021 C 26.33203125 5.92734432220459 27.82265663146973 6.553125858306885 28.94062423706055 7.678125381469727 C 30.05859375 8.803125381469727 30.67031097412109 10.30078125 30.67031097412109 11.8828125 C 30.65625 13.921875 29.73515701293945 17.23359298706055 27.67499923706055 20.05312538146973 Z" fill="#000000" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                                      allowDrawingOutsideViewBox:
                                                          true,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  Pinned.fromPins(
                                                    Pin(size: 22, start: 40.0),
                                                    Pin(start: 0.0, end: 2.6),
                                                    child: SvgPicture.string(
                                                      '<svg viewBox="59.0 701.0 29.1 25.5" ><path transform="translate(59.0, 698.75)" d="M 14.57100582122803 2.25 C 6.522801876068115 2.25 0 7.549065113067627 0 14.088942527771 C 0 16.91207504272461 1.218045115470886 19.49615287780762 3.244325637817383 21.52812576293945 C 2.532850742340088 24.39679145812988 0.1536785811185837 26.9524097442627 0.1252195835113525 26.98086929321289 C 0 27.11178207397461 -0.03415080532431602 27.30529975891113 0.03984259068965912 27.47605323791504 C 0.113835982978344 27.64680862426758 0.2732063829898834 27.7492618560791 0.4553439319133759 27.7492618560791 C 4.229006767272949 27.7492618560791 7.057831287384033 25.93927001953125 8.458013534545898 24.82367515563965 C 10.31923198699951 25.52376747131348 12.38535499572754 25.92788505554199 14.57100582122803 25.92788505554199 C 22.61921119689941 25.92788505554199 29.14201164245605 20.62882041931152 29.14201164245605 14.088942527771 C 29.14201164245605 7.549064159393311 22.61921119689941 2.25 14.57100582122803 2.25 Z" fill="none" stroke="#000000" stroke-width="2" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                                      allowDrawingOutsideViewBox:
                                                          true,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  Pinned.fromPins(
                                                    Pin(size: 22, start: 80.0),
                                                    Pin(start: 0.0, end: 2.6),
                                                    child: SvgPicture.string(
                                                      '<svg viewBox="103.9 701.0 29.1 25.5" ><path transform="translate(103.89, 698.75)" d="M 28.66903686523438 11.23369598388672 L 18.65125846862793 2.583027839660645 C 17.77437973022461 1.825735211372375 16.39235687255859 2.440505504608154 16.39235687255859 3.616884708404541 L 16.39235687255859 8.173334121704102 C 7.249690532684326 8.278005599975586 0 10.11036396026611 0 18.77474975585938 C 0 22.27184295654297 2.252867698669434 25.7363224029541 4.743139743804932 27.54762077331543 C 5.52023983001709 28.11287117004395 6.627748489379883 27.4034481048584 6.34122371673584 26.48718070983887 C 3.760338306427002 18.23334503173828 7.565357208251953 16.0421199798584 16.39235687255859 15.91513538360596 L 16.39235687255859 20.91907501220703 C 16.39235687255859 22.09727478027344 17.77546119689941 22.70931243896484 18.65125846862793 21.95293235778809 L 28.66903686523438 13.30140972137451 C 29.2991771697998 12.75716018676758 29.30002975463867 11.77868461608887 28.66903686523438 11.23369598388672 Z" fill="none" stroke="#000000" stroke-width="2" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                                      allowDrawingOutsideViewBox:
                                                          true,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: SizedBox(
                                                      width: 22,
                                                      height: 19.0,
                                                      child: SvgPicture.string(
                                                        '<svg viewBox="391.8 701.0 18.1 18.8" ><path transform="translate(-476.59, -3.1)" d="M 868.410400390625 704.103759765625 L 886.5033569335938 704.103759765625 L 886.5033569335938 722.9112548828125 L 877.46728515625 716.0320434570312 L 868.410400390625 722.9112548828125 L 868.410400390625 704.103759765625 Z" fill="none" stroke="#000000" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /></svg>',
                                                        allowDrawingOutsideViewBox:
                                                            true,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
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
                                                    radius: 22,
                                                    foregroundImage: AssetImage(
                                                        'images/ushizima.jpg'),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  child: Expanded(
                                                    child: Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        width: 250,
                                                        child:
                                                            Text(post.content)),
                                                  ),
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
  final List<dynamic> beforeimagePhoto;
  final List<dynamic> afterimagePhoto;
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
    beforeimages = widget.beforeimagePhoto;
    afterimages = widget.afterimagePhoto;
  }

  int activeIndex = 0;
  Widget buildImage(beforepath, afterpath, index) => Row(
        children: [
          Column(
            children: [
              Text('before'),
              Container(
                height: 230,
                width: 180,
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
          Column(
            children: [
              Text('after'),
              Container(
                height: 230,
                width: 180,
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
            final afterpath = afterimages[index];

            return buildImage(beforepath, afterpath, index);
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
        Container(child: Text('front')),
        SizedBox(
          height: 5,
        ),
        buildIndicator(),
      ]),
    );
  }
}
