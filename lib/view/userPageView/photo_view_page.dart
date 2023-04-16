import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/utils/authentication.dart';

class PhotoViewPage extends StatefulWidget {
  final List<String> imageUrls;
  final List<String> textcontent;
  final List<dynamic> createdAt;

  final int initialIndex;

  PhotoViewPage(
      this.imageUrls, this.textcontent, this.createdAt, this.initialIndex);

  @override
  _PhotoViewPageState createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  Account myAccount = Authentication.myAccount!;
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              myAccount.name,
              style: TextStyle(
                color: Color.fromARGB(255, 143, 143, 143),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "投稿",
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        toolbarHeight: 48,
      ),
      body: ListView.builder(
        controller: _controller,
        itemCount: widget.imageUrls.length,
        itemBuilder: (BuildContext context, int index) {
          return InteractiveViewer(
            child: Column(
              children: [
                Container(
                  height: 350,
                  width: double.infinity,
                  child: Image.network(
                    widget.imageUrls[index],
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.textcontent[index],
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        DateFormat('M月d日 kk:mm')
                            .format(widget.createdAt[index].toDate()),
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
