import 'package:cloud_firestore/cloud_firestore.dart';

class Carte {
  String id;
  String customer_name;
  String customer_katakana_name;
  int gender;
  int save_count;
  String customer_id;
  String post_stylist_account_id;
  String profile_image;
  String shop_id;
  Timestamp? createdAt;
  Timestamp? lastVisitAt;

  Carte({
    this.id = '',
    required this.customer_name,
    required this.customer_katakana_name,
    required this.gender,
    required this.shop_id,
    required this.customer_id,
    required this.post_stylist_account_id,
    this.createdAt,
    this.profile_image = '',
    this.save_count = 0,
    this.lastVisitAt,
  });

  factory Carte.fromFirestore(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;

    return Carte(
      id: documentSnapshot.id,
      customer_name: data['customer_name'],
      customer_katakana_name: data['customer_katakana_name'],
      gender: data['gender'],
      shop_id: data['shop_id'],
      customer_id: data['customer_id'],
      post_stylist_account_id: data['post_stylist_account_id'],
      createdAt: data['created_time'],
      profile_image: data['profile_image'],
      save_count: data['save_count'],
      lastVisitAt: data['last_visit_time'],
    );
  }
}
