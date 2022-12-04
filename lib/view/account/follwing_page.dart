import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/model/post.dart';
import 'package:memorys/utils/authentication.dart';
import 'package:memorys/utils/firestore/posts.dart';
import 'package:memorys/utils/firestore/users.dart';
import 'package:memorys/view/account/account_page.dart';
import 'package:memorys/view/time_line/post_page.dart';
import 'package:intl/intl.dart';

class FollowingPage extends StatefulWidget {
  const FollowingPage({Key? key}) : super(key: key);

  @override
  _FollowingPageState createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  Account myAccount = Authentication.myAccount!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'フォロー',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 2,
      ),
      body:
          //同じようなものを何回も使うときに使う
          StreamBuilder<QuerySnapshot>(
              stream: UserFirestore.users
                  .doc(myAccount.id)
                  .collection('my_follows')
                  .orderBy('created_time', descending: true)
                  .snapshots(),
              builder: (context, userSnapshot) {
                if (userSnapshot.hasData) {
                  print(myAccount.id);
                  print(userSnapshot.data!.docs.length);
                  List<String> follwingUserIds = [];
                  userSnapshot.data!.docs.forEach((doc) {
                    print(doc.data());
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    follwingUserIds.add(data['following_id']);
                  });
                  return FutureBuilder<List<Account>>(
                      future: UserFirestore.getUsersMap(follwingUserIds),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.hasData &&
                            userSnapshot.connectionState ==
                                ConnectionState.done) {
                          return ListView.builder(
                              itemCount: userSnapshot.data!.length,
                              itemBuilder: (context, index) {
                                List<Account> data = userSnapshot.data!;
                                Account userAccount = data[index];

                                print(userAccount);
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AccountPage(
                                              userInfo: userAccount)),
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
                                                userAccount.imagepath!),
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
                                                        Text(userAccount.name!,
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
                                                Text(userAccount.userId!),
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
            MaterialPageRoute(builder: (context) => const PostPage()),
          );
        },
        child: Icon(Icons.chat_bubble_outline),
      ),
    );
  }
}
