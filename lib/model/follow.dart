import 'package:cloud_firestore/cloud_firestore.dart';

class Follow {
  String following_id;
  String followed_uid;
  String id;
  Timestamp? followingTime;

  Follow({
    this.id = '',
    this.following_id = '',
    this.followed_uid = '',
    this.followingTime,
  });
}
