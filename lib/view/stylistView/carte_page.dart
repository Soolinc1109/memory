import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/model/shop/carte.dart';
import 'package:memorys/utils/authentication.dart';
import 'package:memorys/utils/color.dart';
import 'package:memorys/utils/firestore/cartes.dart';
import 'package:memorys/view/stylistView/resister_customer_page.dart';
import 'package:memorys/view/stylistView/create_stylist_post_page.dart';
import 'package:memorys/view/stylistView/user_account_detail.dart';

class CartePageListView extends StatefulWidget {
  @override
  _CartePageListViewState createState() => _CartePageListViewState();
}

class _CartePageListViewState extends State<CartePageListView> {
  Account myAccount = Authentication.myAccount!;
  String _searchKeyword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomPaint(
        painter: MyBackgroundPainter(),
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Text(
              'customer',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchKeyword = value;
                  });
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(134, 202, 220, 255),
                  labelText: "Search",
                  hintText: "Search by name",
                  labelStyle: TextStyle(color: Colors.white),
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: CarteFirestore.cartes
                        .where('shop_id', isEqualTo: myAccount.shopId)
                        // .orderBy('created_at', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      List<Carte> userList = [];

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      userList = snapshot.data!.docs
                          .map((doc) => Carte.fromFirestore(doc))
                          .where((user) => user.customer_name
                              .toLowerCase()
                              .contains(_searchKeyword.toLowerCase()))
                          .toList();

                      //カルテ情報に変えないといけない

                      //現状/
                      //streambuilder→自分のスタイリストポスト取得
                      //futurebuilder→取得したcustomer_idの中からカスタマー情報を取得

                      //変更後

                      //streambilder→自分のカルテ情報取得
                      //futurebuilder→サブタスクに入りdetail情報を取得しstylistpostとdetail情報(カルテ)両方を表示
                      return userList.length == 0
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 140,
                                ),
                                Container(
                                  child: Text(
                                    "まだお客様はいません",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                    height: 180,
                                    child: Image(
                                      image: NetworkImage(
                                          "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/lonely.png?alt=media&token=642b03bd-a4d6-4d9d-8230-789928967af4"),
                                    )),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  child: Text(
                                    "登録したスタイリストがお客さんの写真を撮り\nカルテを登録するとここに表示されます",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              itemCount: userList.length,
                              itemBuilder: (context, index) {
                                Carte userAccount = userList[index];
                                return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AccountDetailsPage(
                                            customerId: userAccount.customer_id,
                                            userCarte: userAccount,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              220, 255, 255, 255),
                                          borderRadius: BorderRadius.circular(
                                              10.0), // 角丸にする
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              spreadRadius: 1,
                                              blurRadius: 5,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Container(
                                          height: 80,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              userAccount.profile_image == ""
                                                  ? Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              width: 80,
                                                              height: 80,
                                                              color: AppColors
                                                                  .thirdColor,
                                                              child: Center(
                                                                  child: Text(
                                                                      'No Image')),
                                                            ),
                                                            Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              3.0),
                                                                      child:
                                                                          Text(
                                                                        userAccount
                                                                            .customer_name,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                19,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              3.0),
                                                                      child:
                                                                          Text(
                                                                        userAccount
                                                                            .customer_katakana_name,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              8.0),
                                                                      child:
                                                                          Text(
                                                                        "1回",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            color:
                                                                                AppColors.thirdColor,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              8.0),
                                                                      child:
                                                                          Text(
                                                                        "7.5点",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              AppColors.thirdColor,
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  : Row(
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(15),
                                                            ),
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  NetworkImage(
                                                                userAccount
                                                                    .profile_image,
                                                              ),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          width: 80,
                                                          height: 80,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(userAccount
                                                              .customer_name),
                                                        ),
                                                      ],
                                                    ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CreateStylistPostPage(
                                                                  carteId:
                                                                      userAccount
                                                                          .id,
                                                                  customer_id:
                                                                      userAccount
                                                                          .customer_id)),
                                                    );
                                                  },
                                                  child: Text('カルテ'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                              },
                            );
                      // } else if (snapshot.hasError) {
                      //   return Center(child: Text('Error: ${snapshot.error}'));
                      // } else {
                      //   return Center(child: CircularProgressIndicator());
                    })),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ResisterCustomerPage()),
          );
          if (result == true) {
            setState(() {});
          }
        },
        backgroundColor: AppColors.thirdColor,
        child: Icon(Icons.add),
      ),
    );
  }
}

class MyBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 画面上部が青の背景

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.thirdColor,
        AppColors.strengthcolor,
      ],
    );
    final bluePaint = Paint()
      ..shader = gradient
          .createShader(Rect.fromLTWH(0, 0, size.width, size.height / 2.5));

    final topRadius = 30.0;
    final topRRect = RRect.fromLTRBR(
        0, 0, size.width, size.height / 2.5, Radius.circular(topRadius));
    canvas.drawRRect(topRRect, bluePaint);

    // 画面下部が白の背景
    final whitePaint = Paint()..color = Colors.white;
    final bottomRect =
        Rect.fromLTWH(0, size.height / 2.5, size.width, size.height / 2.5);
    canvas.drawRect(bottomRect, whitePaint);

    // 青は下が角丸で影で浮いているように見える
    final bottomRadius = 30.0;
    final path = Path()
      ..moveTo(0, size.height / 2.5 - bottomRadius)
      ..quadraticBezierTo(size.width / 2.5, size.height / 2.5 + bottomRadius,
          size.width, size.height / 2.5 - bottomRadius)
      ..lineTo(size.width, size.height / 2.5)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, 4.0);

    canvas.drawPath(path, bluePaint);
    canvas.drawPath(path, bluePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
