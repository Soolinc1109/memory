import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/model/post.dart';
import 'package:memorys/utils/authentication.dart';
import 'package:memorys/utils/firestore/posts.dart';
import 'package:memorys/utils/firestore/users.dart';
import 'package:memorys/view/account/account_page.dart';
import 'package:memorys/view/time_line/create_stylist_post_page.dart';
import 'package:intl/intl.dart';
import 'package:memorys/view/time_line/create_user_post_page.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({Key? key}) : super(key: key);

  @override
  _PeoplePageState createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  Account myAccount = Authentication.myAccount!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '全員',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 2,
      ),
      body:
          //同じようなものを何回も使うときに使う
          StreamBuilder<QuerySnapshot>(
              stream: UserFirestore.users
                  .orderBy('created_time', descending: true)
                  .snapshots(),
              builder: (context, userSnapshot) {
                if (userSnapshot.hasData) {
                  List<String> userId = [];
                  userSnapshot.data!.docs.forEach((doc) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    userId.add(doc.id);
                    userId.remove(myAccount.id);
                  });
                  return FutureBuilder<List<Account>>(
                      future: UserFirestore.getUsersMap(userId),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.hasData &&
                            userSnapshot.connectionState ==
                                ConnectionState.done) {
                          return ListView.builder(
                              itemCount: userSnapshot.data!.length,
                              itemBuilder: (context, index) {
                                List<Account> data = userSnapshot.data!;
                                Account userAccount = data[index];

                                return InkWell(
                                  onTap: () async {
                                    print(userAccount.id);
                                    //↑タップされたユーザーのID
                                    //myfollowsにあるfollowing_idと上と同じIDだけGET
                                    //getできた場合はフォローできている（フォローできているかの判断）
                                    QuerySnapshot querySnapshot =
                                        //.get()やるだけでは取ってくるだけ→取ってきたデータを扱えるように変数に入れる必要がある
                                        await UserFirestore.users
                                            .doc(myAccount.id)
                                            .collection('my_follows')
                                            .where('following_id',
                                                isEqualTo: userAccount.id)
                                            .get();

                                    //.size　querysnapshotの数 0? 1?　↓
                                    //is_following true falseにする
                                    bool isFollwing =
                                        querySnapshot.size == 0 ? false : true;
                                    print(isFollwing);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AccountPage(
                                              isFollwing: isFollwing)),
                                      //一つ目が遷移先に定義したコンストラクタ名
                                      //二つ目がこのページから受け渡したいデータの変数名
                                    );
                                  },
                                  child: Container(
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
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                            radius: 22,
                                            foregroundImage: NetworkImage(
                                                userAccount.imagepath),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(userAccount.name,
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ],
                                                    ),
                                                    Text(DateFormat('M/d/yy')
                                                        .format(userAccount
                                                            .createdTime!
                                                            .toDate()))
                                                  ],
                                                ),
                                                Text(userAccount.userId),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: const AssetImage(
                                                          'images/DFCC3920-806A-4147-944B-A89B5606425C.png'),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePostPage()),
          );
        },
        child: Icon(Icons.chat_bubble_outline),
      ),
    );
  }
}
