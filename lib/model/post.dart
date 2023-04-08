import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String posterId;
  String content;
  String postAccountId;
  String? posterImageUrl;
  String postImageUrl;
  Timestamp? createdAt;

  Post({
    required this.posterId,
    this.posterImageUrl,
    required this.postImageUrl,
    this.content = '',
    required this.postAccountId,
    this.createdAt,
  });
}
