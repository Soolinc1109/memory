import 'package:adobe_xd/adobe_xd.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/model/post.dart';
import 'package:memorys/model/userpost.dart';
import 'package:memorys/utils/authentication.dart';
import 'package:memorys/utils/firestore/posts.dart';
import 'package:memorys/utils/firestore/shops.dart';
import 'package:memorys/utils/firestore/userpost.dart';
import 'package:memorys/utils/firestore/users.dart';
import 'package:memorys/view/time_line/post_page.dart';
import 'package:memorys/view/time_line/stylist_account_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class StylistsPage extends StatefulWidget {
  const StylistsPage({Key? key}) : super(key: key);

  @override
  _StylistsPageState createState() => _StylistsPageState();
}

class _StylistsPageState extends State<StylistsPage> {
  var staffs = ShopFirestore.shopList[0].staff;
  Account myAccount = Authentication.myAccount!;
  void initState() {
    super.initState();
    print('スタイリストページ');
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
                  stream: UserPostFirestore.userposts
                      .where('post_account_id',
                          whereIn: ShopFirestore.shopList[0].staff)
                      .snapshots(),
                  builder: (context, postSnapshot) {
                    if (postSnapshot.hasData) {
                      return FutureBuilder<Map<String, Account>?>(
                          future: UserFirestore.getPostUserMap(
                              ShopFirestore.shopList[0].staff),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.hasData &&
                                userSnapshot.connectionState ==
                                    ConnectionState.done) {
                              print('=========s================');
                              print(userSnapshot.data);
                              // List<String> postUserId = [];
                              // userSnapshot.data!.docs.forEach((doc) {
                              //   Map<String, dynamic> data =
                              //       doc.data() as Map<String, dynamic>;
                              //   postUserId.add(doc.id);
                              //   postUserId.remove(myAccount.id);
                              // });

                              return ListView.builder(
                                  itemCount: staffs.length,
                                  itemBuilder: (context, index) {
                                    print('=========================');
                                    print(userSnapshot.data);
                                    Map<String, dynamic> datas = userSnapshot
                                        .data! as Map<String, dynamic>;
                                    print(datas);

                                    Account userAccount =
                                        datas['saJX5vYRVDdEIbBsgAESky6QnW22'];
                                    Account userAccount2 =
                                        datas['IyvdbXP3pMgwZcbIJaRvrnWlIxq1'];

                                    Map<String, dynamic> data =
                                        postSnapshot.data!.docs[index].data()
                                            as Map<String, dynamic>;

                                    UserPost post = UserPost(
                                        id: postSnapshot.data!.docs[index].id,
                                        content: data['content'],
                                        Image: data['image'],
                                        postAccountId: data['post_account_id'],
                                        createdTime: data['created_time']);

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
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              StylistAccountPage(
                                                                userInfo:
                                                                    userAccount,
                                                              )),
                                                    );
                                                  },
                                                  child: CircleAvatar(
                                                    radius: 32,
                                                    foregroundImage:
                                                        NetworkImage(postAccount
                                                            .imagepath),
                                                  ),
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
                                                          Column(
                                                            children: [
                                                              Text(
                                                                postAccount
                                                                    .name,
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
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            height: 35,
                                            width: 300,
                                            child: Stack(
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xffffaddd),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            11.0),
                                                  ),
                                                ),
                                                Pinned.fromPins(
                                                  Pin(start: 10, end: 0),
                                                  Pin(size: 30.0, middle: 0.4),
                                                  child: Text(
                                                    '指名して予約',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'Oriya MN',
                                                      fontSize: 20,
                                                      color: const Color(
                                                          0xffffffff),
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
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            child: GridView.count(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              crossAxisCount: 3,
                                              children:
                                                  List.generate(6, (index) {
                                                return Container(
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height: 120,
                                                        width: 120,
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: post.Image ==
                                                                    null
                                                                ? NetworkImage(
                                                                    post.Image)
                                                                : NetworkImage(
                                                                    'https://static.wixstatic.com/media/2ff517_a30eb5bec7de45c0a5456aee6973cf7b~mv2.jpeg/v1/fill/w_976,h_651,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/main_hair-1024x683.jpeg'),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            } else {
                              print('object');
                              return Container();
                            }
                          });
                    } else {
                      return Container();
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> list = [
  _photoItem(
      "https://job.dmkt-sp.jp/images/pages/article/work_kyujin_beauty_190207_01.jpg"),
  _photoItem(
      "https://d2u7zfhzkfu65k.cloudfront.net/image-resize/a/hair/photographs/thumb-m/41/4143ce3d63707.jpg?w=240&q=80&e="),
  _photoItem(
      "https://imgbp.hotp.jp/magazine/media/item_images/images/148/087/627/original/fc5cad33-7139-4b06-a19b-aa276af096e8.jpg"),
  _photoItem("pic3"),
  _photoItem("pic4"),
  _photoItem("pic5"),
];
Widget _photoItem(String image) {
  return Container(
    child: Image.network(
      image,
      fit: BoxFit.cover,
    ),
  );
}
