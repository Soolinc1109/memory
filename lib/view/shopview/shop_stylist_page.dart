import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/model/shop/stylistpost.dart';
import 'package:memorys/utils/authentication.dart';
import 'package:memorys/utils/color.dart';
import 'package:memorys/utils/firestore/shops.dart';
import 'package:memorys/utils/firestore/stylistposts.dart';
import 'package:memorys/utils/firestore/users.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:memorys/view/shopview/create_shop_page.dart';

class ShopStylistPage extends StatefulWidget {
  @override
  _ShopStylistPageState createState() => _ShopStylistPageState();
}

class _ShopStylistPageState extends State<ShopStylistPage> {
  Account myAccount = Authentication.myAccount!;

  String _searchKeyword = '';

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('shop_id', isEqualTo: myAccount.shopId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (myAccount.shopId == "") {}
          List<String> accountIds =
              snapshot.data!.docs.map((doc) => doc.id).toList();

          return accountIds.length == 0
              ? Scaffold(
                  body: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 180,
                        ),
                        Container(
                          child: Text(
                            "お店の情報を登録しよう！",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                            height: 200,
                            child: Image(
                              image: NetworkImage(
                                  "https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/undraw_add_friends_re_3xte.png?alt=media&token=f1055f15-a980-4658-ac7c-77bfd76462c2"),
                            )),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          child: Text(
                            "お店の情報を登録することで\n日々の来店数や、来客者の情報が視覚的に\n把握できるようになります",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                            onTap: () async {
                              var result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CreateShopPage()),
                              );
                              if (result == true) {
                                setState(() {});
                              }
                            },
                            child: Container(
                                height: 40,
                                width: screenWidth / 2.3,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(15), // 角丸を追加
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      AppColors.thirdColor, // グラデーションの開始色
                                      AppColors.secondaryColor, // グラデーションの終了色
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Text('お店を登録',
                                      style: TextStyle(
                                        fontSize: 20, // フォントサイズを大きくする
                                        fontWeight:
                                            FontWeight.bold, // フォントを太くする
                                        color: Colors.white, // テキストの色を白にする
                                      )),
                                ))),
                      ],
                    ),
                  ),
                )
              : StreamBuilder<List<String>>(
                  stream: ShopFirestore.getStaffIds(myAccount.shopId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<String> staffIds = snapshot.data!;
                      print(staffIds);
                      return StreamBuilder<List<StylistPost>>(
                          stream:
                              StylistPostFirestore.getPostByStaffIds(staffIds)
                                  .asStream(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }
                            if (snapshot.data == null) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }

                            List<StylistPost> posts = snapshot.data!;
                            print(posts.length);
                            List<double> favoriteLevels = [];
                            List<double> extractFavoriteLevels(
                                List<StylistPost> posts) {
                              print(posts);
                              for (StylistPost post in posts) {
                                if (post.favorite_level != null) {
                                  favoriteLevels
                                      .add(post.favorite_level!.toDouble());
                                }
                              }

                              return favoriteLevels;
                            }

                            extractFavoriteLevels(posts);
                            double favoriteLevelsAverage =
                                averageOfList(favoriteLevels);

                            print(favoriteLevels);
                            return Scaffold(
                              appBar: AppBar(
                                backgroundColor:
                                    Color.fromARGB(0, 255, 255, 255),
                                elevation: 0,
                                title: SizedBox(
                                  height: 45,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(0, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(25.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Color.fromARGB(157, 93, 152, 176)
                                                  .withOpacity(0.16),
                                          spreadRadius: 1,
                                          blurRadius: 3,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          _searchKeyword = value;
                                        });
                                      },
                                      style: TextStyle(
                                          color: AppColors.thirdColor),
                                      decoration: InputDecoration(
                                        labelText: "検索",
                                        hintText: "Search by name",
                                        labelStyle: TextStyle(
                                            color: AppColors.thirdColor),
                                        prefixIcon: Icon(Icons.search,
                                            color: AppColors.thirdColor),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25.0)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.thirdColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25.0)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.thirdColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25.0)),
                                        ),
                                        hintStyle: TextStyle(
                                            color: AppColors.thirdColor),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 15),
                                        filled: true,
                                        fillColor:
                                            Color.fromARGB(208, 255, 255, 255),
                                      ),
                                    ),
                                  ),
                                ),
                                actions: [
                                  IconButton(
                                    icon:
                                        Icon(Icons.search, color: Colors.black),
                                    onPressed: () {
                                      // 検索アイコンがタップされたときの処理
                                    },
                                  ),
                                ],
                              ),
                              body: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        height: 90,
                                        child: FutureBuilder<List<Account>>(
                                          future: UserFirestore.getUsersMap(
                                              accountIds),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              if (snapshot.hasError) {
                                                return Center(
                                                    child: Text(
                                                        'Error: ${snapshot.error}'));
                                              }
                                              List<Account> userList = snapshot
                                                  .data!
                                                  .where((user) => user.name
                                                      .toLowerCase()
                                                      .contains(_searchKeyword
                                                          .toLowerCase()))
                                                  .toList();

                                              return myAccount.shopId == ""
                                                  ? Container(
                                                      child:
                                                          Text("スタイリストがいません"),
                                                    )
                                                  : ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount:
                                                          userList.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 15.0,
                                                                  right: 5.0,
                                                                  bottom: 5.0,
                                                                  top: 5.0),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              image:
                                                                  DecorationImage(
                                                                image: NetworkImage(
                                                                    userList[
                                                                            index]
                                                                        .imagepath),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                            width: 80,
                                                            height: 80,
                                                          ),
                                                        );
                                                      },
                                                    );
                                            }
                                            return Container();
                                          },
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Container(
                                        height: 250,
                                        width: screenWidth / 1.1,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              15), // 角丸を追加
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              AppColors
                                                  .thirdColor, // グラデーションの開始色
                                              AppColors
                                                  .secondaryColor, // グラデーションの終了色
                                            ],
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: LineChartWidget(
                                            data: favoriteLevels,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      height: 30,
                                      child: Container(
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: 4,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            List<String> time = [
                                              '1週間',
                                              '2週間',
                                              '1ヶ月',
                                              '3ヶ月'
                                            ];
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  left:
                                                      index == 0 ? 20.0 : 10.0,
                                                  right: 1.0,
                                                  bottom: 1.0,
                                                  top: 1.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  border: Border.all(
                                                      color:
                                                          AppColors.thirdColor,
                                                      width: 1.0),
                                                ),
                                                width: 80,
                                                height: 20,
                                                child: Center(
                                                  child: Text(
                                                    time[index],
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.thirdColor,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: screenWidth / 23,
                                            ),
                                            Center(
                                              child: Container(
                                                height: 140,
                                                width: screenWidth / 2.3,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15), // 角丸を追加
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      AppColors
                                                          .thirdColor, // グラデーションの開始色
                                                      AppColors
                                                          .secondaryColor, // グラデーションの終了色
                                                    ],
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0,
                                                                top: 8.0),
                                                        child: Text(
                                                          '1week',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      favoriteLevelsAverage
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 39,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 8.0),
                                                        child: Text(
                                                          '平均いいね数',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: screenWidth / 23,
                                            ),
                                            Center(
                                              child: Container(
                                                height: 140,
                                                width: screenWidth / 2.3,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15), // 角丸を追加
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      AppColors
                                                          .thirdColor, // グラデーションの開始色
                                                      AppColors
                                                          .secondaryColor, // グラデーションの終了色
                                                    ],
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0,
                                                                top: 8.0),
                                                        child: Text(
                                                          '1week',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      favoriteLevels.length
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 39,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 8.0),
                                                        child: Text(
                                                          '来店数',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: screenWidth / 23,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    FutureBuilder<List<Account>>(
                                      future:
                                          UserFirestore.getUsersMap(accountIds),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          if (snapshot.hasError) {
                                            return Center(
                                                child: Text(
                                                    'Error: ${snapshot.error}'));
                                          }
                                          List<Account> userList = snapshot
                                              .data!
                                              .where((user) => user.name
                                                  .toLowerCase()
                                                  .contains(_searchKeyword
                                                      .toLowerCase()))
                                              .toList();

                                          return myAccount.shopId == ""
                                              ? Container(
                                                  child: Text("スタイリストがいません"),
                                                )
                                              : ListView.builder(
                                                  itemCount: userList.length,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemBuilder:
                                                      (context, index) {
                                                    Account userAccount =
                                                        userList[index];

                                                    return ListTile(
                                                      leading: CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(
                                                                userAccount
                                                                    .imagepath),
                                                      ),
                                                      title: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              userAccount.name),
                                                          Column(
                                                            children: [
                                                              FutureBuilder<
                                                                      List<
                                                                          Map<String,
                                                                              dynamic>>>(
                                                                  future: UserFirestore
                                                                      .getMyStylistPosts(
                                                                          userAccount),
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    var stylists =
                                                                        snapshot
                                                                            .data;
                                                                    if (snapshot
                                                                            .connectionState ==
                                                                        ConnectionState
                                                                            .waiting) {
                                                                      return Container();
                                                                    }
                                                                    print(stylists!
                                                                        .length
                                                                        .toString());
                                                                    if (stylists ==
                                                                        []) {
                                                                      return Text(
                                                                        '0人',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.red,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      );
                                                                    }
                                                                    return Row(
                                                                      children: [
                                                                        Text(
                                                                          stylists
                                                                              .length
                                                                              .toString(),
                                                                          style: TextStyle(
                                                                              color: Colors.red,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 21),
                                                                        ),
                                                                        Text(
                                                                          "人",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.red,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  }),
                                                              Text(
                                                                '今月の来客数',
                                                                style: TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            168,
                                                                            168,
                                                                            168),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  shrinkWrap: true,
                                                );
                                        } else if (snapshot.hasError) {
                                          return Center(
                                              child: Text(
                                                  'Error: ${snapshot.error}'));
                                        } else {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  });
        });
  }
}

class LineChartWidget extends StatelessWidget {
  final List<double> data;

  LineChartWidget({
    required this.data,
  });
  @override
  Widget build(BuildContext context) {
    List<double> redData = [6];
    double maxY = _findMaxY([data, redData]) + 2;
    print(data);
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: maxY,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(
          show: true,
          border: Border(
            // ここでBorderを設定します
            bottom: BorderSide(
              // ここでx軸の上にバーを追加します
              color: AppColors.primaryColor,
              width: 2, // バーの太さを指定
            ),
            left: BorderSide.none, // y軸のバーを非表示にする
            right: BorderSide.none, // 右のバーを非表示にする
            top: BorderSide.none, // 上のバーを非表示にする
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          topTitles: SideTitles(
            showTitles: true,
            getTextStyles: (BuildContext context, value) => const TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
            getTitles: (value) => value == 3 ? '1week' : '',
            reservedSize: 40,
            margin: 12,
          ),
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            getTextStyles: (BuildContext context, value) => const TextStyle(
              // 修正
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
            getTitles: (value) {
              final today = DateTime.now();
              final dayDifference = (value - 3).toInt();
              final date = today.add(Duration(days: dayDifference));
              final formatter = DateFormat('d');
              return formatter.format(date);
            },
            margin: 5,
          ),
          leftTitles: SideTitles(
            showTitles: true,
            getTextStyles: (BuildContext context, value) => const TextStyle(
              // 修正
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            getTitles: (value) {
              double interval = maxY / 5; // maxYを5等分する
              int intValue = value.toInt();
              if (intValue % interval.toInt() == 0) {
                return intValue.toString();
              }
              return '';
            },
            reservedSize: 23,
            margin: 12,
          ),
        ),
        lineBarsData: [
          _createLine(Color.fromARGB(255, 255, 255, 255), data),
          _createLine(Color.fromARGB(255, 255, 255, 255), redData),
        ],
      ),
    );
  }

  double _findMaxY(List<List<double>> data) {
    double maxValue = 0;
    for (List<double> dataset in data) {
      if (dataset.isNotEmpty) {
        double datasetMax = dataset.reduce((a, b) => a > b ? a : b);
        maxValue = maxValue > datasetMax ? maxValue : datasetMax;
      }
    }
    return maxValue;
  }

  LineChartBarData _createLine(Color color, List<double> data) {
    return LineChartBarData(
      spots: data
          .asMap()
          .map((index, value) =>
              MapEntry(index, FlSpot(index.toDouble(), value)))
          .values
          .toList(),
      isCurved: true, // 曲線を滑らかにする
      curveSmoothness: 0.2, // 曲線の滑らかさを調整する (0から1の範囲内で値を指定)
      colors: [color],
      barWidth: 4, // 線の太さを指定
      isStrokeCapRound: true, // 角丸にする
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }

  List<FlSpot> _createSpots(List<double> values) {
    return List.generate(
      values.length,
      (index) =>
          FlSpot(index.toDouble(), values[index].isNaN ? 0 : values[index]),
    );
  }
}

double averageOfList(List<double> list) {
  if (list.isEmpty) {
    return 0;
  }
  double sum = list.reduce((a, b) => a + b);
  return sum / list.length;
}
