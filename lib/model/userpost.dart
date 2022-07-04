import 'package:cloud_firestore/cloud_firestore.dart';

class UserPost {
  String id;
  String content;
  String postAccountId;
  String Image;
  Timestamp? createdTime;

  UserPost({
    this.id = '1',
    this.Image = '',
    this.content = '1',
    this.postAccountId = '1',
    this.createdTime,
  });
}
