import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memorys/model/book.dart';
import 'package:memorys/utils/firestore/books.dart';

class BookPage extends StatefulWidget {
  const BookPage({Key? key}) : super(key: key);

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('本一覧')),
      body: StreamBuilder<QuerySnapshot>(
          //streambuilderはリアルタイムで変更したい時
          stream: FirebaseFirestore.instance
              .collection('book')
              .snapshots(), //streamの値
          //streamに監視する値を入れる→firebaseの監視したいコレクションのsnapshotsを書く
          builder: (context, snapshot) {
            print('IIIIIIIIIIIII');
            print(snapshot.data!.docs);
            print('IIIIIIIIIIIII');

            if (snapshot.hasData) {
              //↑snapshot.data = bookListの時
              List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
              List<Book> bookList = [];
              for (int i = 0; i < docs.length; i++) {
                Map<String, dynamic> data =
                    docs[i].data() as Map<String, dynamic>;
                Book book = Book(title: data['title'], author: data['author']);
                bookList.add(book);
              }

              //オブジェクト型をリスト型に変換

              //Listview = 静的表示

              // return ListView(children: [
              //   ListTile(
              //     title: Text(bookList[0].author ??
              //         '名無し'), //null演算子 ??の左側がnullだったら 右側の値を適用
              //     subtitle: Text(bookList[0].title),
              //   ),
              // ]);
              //ListView.builder = 動的表示
              return ListView.builder(
                  itemCount: bookList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(bookList[index].author ??
                          '名無し'), //null演算子 ??の左側がnullだったら 右側の値を適用
                      subtitle: Text(bookList[index].title),
                    );
                  });
            }
            return Container();
            //streamで監視している値と表示したい内容が違う場合future必要
            // return FutureBuilder(
            //   future: BookFirestore.getBookinfo(),
            //   //future→時間のかかる処理を書くところ→bookの情報を取ってくる→BookFirestore.getBookinfo()
            //   //bookの結果情報を
            //   builder: (context, snapshot) {
            //     //builder → futureに書いてる処理の状況に応じて表示する内容を設定する場所
            //     //snapshot →  状況の判断を行える変数
            //     //snapshot.data　→ futureのリターンしている値 → booklist/null
            //     //snapshot.connectionState　→ 通信状況 →自分で作った動画等が入れられる
            //     if (snapshot.hasData) {
            //       //↑snapshot.data = bookListの時
            //       //↑
            //       List<Book> bookList = snapshot.data! as List<Book>;
            //       //オブジェクト型をリスト型に変換

            //       //Listview = 静的表示

            //       // return ListView(children: [
            //       //   ListTile(
            //       //     title: Text(bookList[0].author ??
            //       //         '名無し'), //null演算子 ??の左側がnullだったら 右側の値を適用
            //       //     subtitle: Text(bookList[0].title),
            //       //   ),
            //       // ]);
            //       //ListView.builder = 動的表示
            //       return ListView.builder(
            //           itemCount: bookList.length,
            //           itemBuilder: (context, index) {
            //             return ListTile(
            //               title: Text(bookList[index].author ??
            //                   '名無し'), //null演算子 ??の左側がnullだったら 右側の値を適用
            //               subtitle: Text(bookList[index].title),
            //             );
            //           });
            //     }
            //     return Container();
            //   },
            // );
          }),
    );
  }
}
