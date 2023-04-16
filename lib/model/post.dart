import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String posterId;
  String content;
  String postAccountId;
  String? posterImageUrl;
  String postImageUrl;
  DateTime createdAt;

  Post({
    required this.posterId,
    this.posterImageUrl,
    required this.postImageUrl,
    this.content = '',
    required this.postAccountId,
    required this.createdAt,
  });
}
