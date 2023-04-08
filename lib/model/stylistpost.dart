import 'package:cloud_firestore/cloud_firestore.dart';

class StylistPost {
  String id;

  String postAccountId;
  String customer_id;
  String? poster_image_url;
  String message_for_customer;
  List<dynamic>? before_image;
  List<dynamic>? after_image;
  Timestamp? createdTime;

  StylistPost({
    this.id = '',
    required this.postAccountId,
    this.poster_image_url,
    this.before_image,
    required this.customer_id,
    this.after_image,
    this.createdTime,
    this.message_for_customer = '',
  });
}
