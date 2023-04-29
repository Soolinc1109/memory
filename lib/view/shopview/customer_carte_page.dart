import 'package:flutter/material.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/utils/authentication.dart';
import 'package:memorys/utils/color.dart';
import 'package:memorys/utils/firestore/users.dart';
import 'package:memorys/view/stylistView/user_account_detail.dart';

class CustomerCartePage extends StatefulWidget {
  @override
  _CustomerCartePageState createState() => _CustomerCartePageState();
}

class _CustomerCartePageState extends State<CustomerCartePage> {
  String _searchKeyword = '';
  Account myAccount = Authentication.myAccount!;

  void _onSearchKeywordChanged(String keyword) {
    setState(() {
      _searchKeyword = keyword;
    });
  }

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
                child: StreamBuilder<List<Account>>(
                    stream: UserFirestore.getCustomerList(myAccount),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.data == null) {
                        return Column(
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
                        );
                      }

                      List<Account> accountData = snapshot.data!
                          .where((user) => user.name
                              .toLowerCase()
                              .contains(_searchKeyword.toLowerCase()))
                          .toList();

                      return accountData.length == 0
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
                              itemCount: accountData.length,
                              itemBuilder: (context, index) {
                                Account userAccount = accountData[index];
                                return InkWell(
                                  onTap: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => AccountDetailsPage(
                                    //       account: userAccount,
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0,
                                        right: 22.0,
                                        bottom: 8.0,
                                        left: 22.0),
                                    child: Container(
                                      height: 120,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 6,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            right: 12.0,
                                            bottom: 8.0,
                                            left: 12.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 25.0, // 半径を50に設定

                                                      backgroundImage:
                                                          NetworkImage(
                                                              userAccount
                                                                  .imagepath),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: Text(
                                                        userAccount.name,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20,
                                                          color: AppColors
                                                              .thirdColor,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Text(userAccount.name),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                    })),
          ],
        ),
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
