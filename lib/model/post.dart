import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String id;
  String content;
  String postAccountId;
  List<dynamic>? beforeImage;
  List<dynamic>? afterImage;
  Timestamp? createdTime;

  Post({
    this.id = '1',
    this.beforeImage,
    this.afterImage,
    this.content = '1',
    this.postAccountId = '1',
    this.createdTime,
  });
}
