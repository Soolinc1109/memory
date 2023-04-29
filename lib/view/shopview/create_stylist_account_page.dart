import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/model/shop/shop.dart';
import 'package:memorys/utils/firestore/shops.dart';
import 'package:memorys/utils/firestore/users.dart';
import 'package:memorys/view/stylistView/user_account_detail.dart';

class CreateStylistAccountPage extends StatefulWidget {
  final Shop shopInfo;

  CreateStylistAccountPage({
    required this.shopInfo,
  });

  @override
  _CreateStylistAccountPageState createState() =>
      _CreateStylistAccountPageState();
}

class _CreateStylistAccountPageState extends State<CreateStylistAccountPage> {
  final _formKey = GlobalKey<FormState>();
  String _searchKeyword = '';

  bool _isLoading = false;

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('スタイリスト追加/更新'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchKeyword = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Search",
                        hintText: "Search by name",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where('is_stylist', isEqualTo: false)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        List<String> accountIds =
                            snapshot.data!.docs.map((doc) => doc.id).toList();

                        return FutureBuilder<List<Account>>(
                          future: UserFirestore.getUsersMap(accountIds),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<Account> userList = snapshot.data!
                                  .where((user) => user.name
                                      .toLowerCase()
                                      .contains(_searchKeyword.toLowerCase()))
                                  .toList();
                              return ListView.builder(
                                itemCount: userList.length,
                                itemBuilder: (context, index) {
                                  Account userAccount = userList[index];
                                  return InkWell(
                                    onTap: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) =>
                                      //         AccountDetailsPage(
                                      //       account: userAccount,
                                      //     ),
                                      //   ),
                                      // );
                                    },
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(userAccount.imagepath),
                                      ),
                                      title: Text(userAccount.name),
                                      trailing: ElevatedButton(
                                        onPressed: () async {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('スタイリスト登録'),
                                                content: Text(
                                                    'このユーザーはあなたのお店のスタイリストであってますか？'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('閉じる'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text('ユーザー追加'),
                                                    onPressed: () async {
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        setState(() {
                                                          _isLoading = true;
                                                        });

                                                        userAccount.is_stylist =
                                                            true;
                                                        userAccount.shopId =
                                                            widget.shopInfo.id;
                                                        bool result =
                                                            await UserFirestore
                                                                .updateUser(
                                                                    userAccount);
                                                        bool success =
                                                            await ShopFirestore
                                                                .addStaffToShop(
                                                                    widget
                                                                        .shopInfo
                                                                        .id,
                                                                    userAccount
                                                                        .id);

                                                        if (success && result) {
                                                          Navigator.pop(
                                                              context, true);
                                                        } else {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title:
                                                                    Text('エラー'),
                                                                content: Text(
                                                                    'ユーザー情報の更新に失敗しました。'),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    child: Text(
                                                                        '閉じる'),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        }
                                                        setState(() {
                                                          _isLoading = false;
                                                        });
                                                      }
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Text('選択'),
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
