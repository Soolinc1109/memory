import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memorys/model/book.dart';

class BookFirestore {
  static final CollectionReference books =
      FirebaseFirestore.instance.collection('book');

 static Future<dynamic> getBookinfo() async {
    List<Book> bookList = [];
    try {
      var snapshot = await books.get();
      var docs = snapshot.docs;
      for (int i = 0; i < docs.length; i++) {
        Map<String, dynamic> data = docs[i].data() as Map<String, dynamic>;
        Book book = Book(title: data['title'], author: data['author']);
        bookList.add(book);
      }
      return bookList;
      //futurebuilderのsnapshot.dataに飛んでいく
    } catch (e) {
      return null;
      //futurebuilderのsnapshot.dataに飛んでいく
    }

  
  }

  
}
