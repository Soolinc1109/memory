import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/utils/firestore/users.dart';
import 'package:memorys/view/stylistView/create_stylist_post_page.dart';

class ShopCartePage extends StatefulWidget {
  @override
  _ShopCartePageState createState() => _ShopCartePageState();
}

class _ShopCartePageState extends State<ShopCartePage> {
  String _searchKeyword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: Column(
        children: [
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
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
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
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(userAccount.imagepath),
                            ),
                            title: Text(userAccount.name),
                            trailing: ElevatedButton(
                              onPressed: () async {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) =>
                                //           CreateStylistPostPage(
                                //             customer_id: userAccount.id,
                                //           )),
                                // );
                              },
                              child: Text('決定'),
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
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
    );
  }
}
