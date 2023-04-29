import 'package:cloud_firestore/cloud_firestore.dart';

class StylistPost {
  String id;
  String shop_id;
  String postAccountId;
  String customer_id;
  String carte_id;
  String? poster_image_url;
  String message_for_customer;
  List<dynamic>? before_image;
  List<dynamic>? after_image;
  Timestamp? createdTime;
  bool is_favorite;
  int? favorite_level;

  StylistPost({
    this.id = '',
    this.favorite_level,
    this.is_favorite = false,
    required this.postAccountId,
    required this.shop_id,
    required this.carte_id,
    this.poster_image_url,
    this.before_image,
    required this.customer_id,
    this.after_image,
    this.createdTime,
    this.message_for_customer = '',
  });
}
