import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  void _goToToday() {
    setState(() {
      _focusedDay = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.today),
            onPressed: _goToToday,
          ),
        ],
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 255, 112, 108),
                      Color.fromARGB(255, 247, 144, 103),
                      Color.fromARGB(255, 255, 188, 108)
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 120,
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
                        rightChevronIcon:
                            Icon(Icons.chevron_right, color: Colors.white),
                      ),
                      calendarStyle: CalendarStyle(
                        defaultTextStyle: TextStyle(color: Colors.white),
                        weekendTextStyle: TextStyle(color: Colors.white),
                        holidayTextStyle: TextStyle(color: Colors.white),
                        outsideTextStyle:
                            TextStyle(color: Colors.white.withOpacity(0.6)),
                        todayDecoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: Color.fromARGB(255, 225, 56, 0),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GridView.builder(
              itemCount: 20, // グリッドに表示する要素の数
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 横に並ぶ要素の数
                mainAxisSpacing: 4.0, // 縦のスペース
                crossAxisSpacing: 4.0, // 横のスペース
                childAspectRatio: 1.0, // 高さと幅の比率
              ),
              itemBuilder: (BuildContext context, int index) {
                return GridTile(
                  child: Container(
                    color: Colors.blue,
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width, // 画面の幅を取得
                    height: MediaQuery.of(context).size.height, // 画面の高さを取得
                    child: Image.network(
                      'https://cdn.job-medley.com/tips/cms/pictures/3825/content_v1-c1665ebf-a90d-40a3-bd11-65788a9e2437.jpg', // 画像のアセットパスを指定
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              },
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            ),
          ],
        ),
      ),
    );
  }
}
