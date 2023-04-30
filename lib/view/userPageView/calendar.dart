import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/utils/authentication.dart';
import 'package:memorys/utils/firestore/posts.dart';
import 'package:memorys/view/userPageView/create_user_post_page.dart';
import 'package:memorys/view/userPageView/image_detail.dart';
import 'package:memorys/view/userPageView/photo_view_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:memorys/utils/color.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  Future<Map<DateTime, String>>? imageMapFuture;

  void initState() {
    super.initState();
    imageMapFuture = PostFirestore.createImageMap(myAccount.id);
  }

  bool _isFirstBuild = true;

  final myAccount = Authentication.myAccount!;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  File? image;

  void _goToToday() {
    setState(() {
      _focusedDay = DateTime.now();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstBuild) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _isFirstBuild = false;
        });
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              child: FutureBuilder<Map<DateTime, String>>(
                  future: imageMapFuture,
                  builder: (BuildContext context,
                      AsyncSnapshot<Map<DateTime, String>> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final imageMap = snapshot.data!;

                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.secondaryColor,
                            AppColors.thirdColor,
                            AppColors.secondaryColor
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 80,
                          ),
                          TableCalendar(
                            firstDay: DateTime.utc(2010, 10, 16),
                            lastDay: DateTime.utc(2030, 3, 14),
                            focusedDay: _focusedDay,
                            calendarFormat: _calendarFormat,
                            selectedDayPredicate: (day) {
                              return isSameDay(_selectedDay, day);
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                              });
                              if (snapshot.hasData) {
                                // _selectedDayの年、月、日が一致するキーを探す
                                DateTime? matchedKey;
                                for (DateTime key in imageMap.keys) {
                                  if (key.year == _selectedDay!.year &&
                                      key.month == _selectedDay!.month &&
                                      key.day == _selectedDay!.day) {
                                    matchedKey = key;
                                    break;
                                  }
                                }
                                if (matchedKey != null) {
                                  String? imageUrl = imageMap[matchedKey];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ImageDetailScreen(
                                        selectedDate: _selectedDay!,
                                        imageUrl: imageUrl!,
                                      ),
                                    ),
                                  );
                                } else {
                                  print('image取得失敗');
                                }
                              } else {
                                print('image取得失敗');
                              }
                            },
                            onFormatChanged: (format) {
                              setState(() {
                                _calendarFormat = format;
                              });
                            },
                            onPageChanged: (focusedDay) {
                              _focusedDay = focusedDay;
                            },
                            headerStyle: HeaderStyle(
                              titleTextStyle: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 255, 255, 255)),
                              leftChevronIcon:
                                  Icon(Icons.chevron_left, color: Colors.white),
                              rightChevronIcon: Icon(Icons.chevron_right,
                                  color: Colors.white),
                            ),
                            calendarBuilders: CalendarBuilders(
                              defaultBuilder: (context, date, focused) {
                                Widget dayWidget;
                                final isImageDate = imageMap.keys.any(
                                    (imageDate) =>
                                        imageDate.year == date.year &&
                                        imageDate.month == date.month &&
                                        imageDate.day == date.day);
                                if (isImageDate) {
                                  final imageUrl = imageMap.entries.firstWhere(
                                      (entry) =>
                                          entry.key.year == date.year &&
                                          entry.key.month == date.month &&
                                          entry.key.day == date.day);
                                  dayWidget = Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(imageUrl.value),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      date.day.toString(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                } else {
                                  dayWidget = Text(date.day.toString());
                                }
                                return Center(child: dayWidget);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    "投稿!",
                    style: TextStyle(
                      fontSize: 18, // 文字サイズを大きくする (例: 24)
                      fontWeight: FontWeight.bold, // 文字を太くする
                    ),
                  ),
                )
              ],
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _isFirstBuild
                  ? FirebaseFirestore.instance
                      .collection('userposts')
                      .where('post_account_id', isEqualTo: myAccount.id)
                      .orderBy('created_time', descending: true)
                      .snapshots()
                  : null,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text(
                          "まだ投稿がありません",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
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
                          "あなたの美容な毎日を投稿しましょう\n美容の記録を保存できます",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                }
                if (snapshot.hasError) {
                  return Center(child: Text('エラー: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final imageUrls = snapshot.data!.docs
                    .map((doc) => doc.get('image') as String)
                    .toList();

                final textcontent = snapshot.data!.docs
                    .map((doc) => doc.get('content') as String)
                    .toList();

                final createdAt = snapshot.data!.docs
                    .map((doc) => doc.get('created_time'))
                    .toList();

                return GridView.builder(
                  padding: EdgeInsets.only(top: 20),
                  itemCount: imageUrls.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          createPinchOutPageRoute(
                            nextScreen: PhotoViewPage(
                              imageUrls,
                              textcontent,
                              createdAt,
                              index,
                            ),
                          ),
                        );
                      },
                      child: GridTile(
                        child: Image.network(
                          imageUrls[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePostPage()),
          );
          if (result == true) {
            setState(() {});
          }
        },
        backgroundColor: AppColors.secondaryColor,
        child: Icon(Icons.add),
      ),
    );
  }
}

PageRouteBuilder createPinchOutPageRoute({required Widget nextScreen}) {
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 200),
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return nextScreen;
    },
    transitionsBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      final beginScale = vector.Vector3(0.0, 0.0, 0.0);
      final endScale = vector.Vector3(1.0, 1.0, 1.0);
      final scaleTween = Tween<vector.Vector3>(begin: beginScale, end: endScale)
          .chain(CurveTween(curve: Curves.easeInOut));

      return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          final scaleValue = scaleTween.evaluate(animation);
          return Transform(
            transform: Matrix4.diagonal3(scaleValue),
            alignment: FractionalOffset.center,
            child: child,
          );
        },
        child: child,
      );
    },
  );
}
