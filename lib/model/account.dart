// Accountクラス(アカウントの設計図)を生成
import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  String id;
  String name;
  String imagepath;
  String? favorite_image_0;
  String? favorite_image_1;
  String? favorite_image_2;
  String? favorite_image_3;
  String? favorite_image_4;
  String selfIntroduction;
  String userId;
  String shopId;
  String follow;
  String follower;
  bool is_stylist;
  bool is_owner;
  List<dynamic>? menu_id;
  Timestamp? createdTime;
  Timestamp? updatedTime;

  List<String?> get favoriteImages => [
        favorite_image_0,
        favorite_image_1,
        favorite_image_2,
        favorite_image_3,
        favorite_image_4,
      ];

  Account(
      {this.id = '',
      this.name = '',
      this.imagepath =
          'https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/noimage.png?alt=media&token=b95c16cf-7ca3-4dc2-9b4f-3fec6cc22bf2',
      this.favorite_image_0 = '',
      this.favorite_image_1 = '',
      this.favorite_image_2 = '',
      this.favorite_image_3 = '',
      this.favorite_image_4 = '',
      this.selfIntroduction = '',
      this.userId = '',
      this.shopId = '',
      this.follow = '',
      this.follower = '',
      this.menu_id,
      this.is_stylist = false,
      this.is_owner = false,
      this.createdTime,
      this.updatedTime});

  factory Account.fromFirestore(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;

    return Account(
      id: documentSnapshot.id,
      name: data['name'],
      imagepath: data['imagepath'],
      favorite_image_0: data['favorite_image_0'],
      favorite_image_1: data['favorite_image_1'],
      favorite_image_2: data['favorite_image_2'],
      favorite_image_3: data['favorite_image_3'],
      favorite_image_4: data['favorite_image_4'],
      selfIntroduction: data['selfIntroduction'],
      menu_id: data['menu_id'],
      userId: data['userId'],
      shopId: data['shopId'],
      follow: data['follow'],
      follower: data['follower'],
      is_stylist: data['is_stylist'],
      is_owner: data['is_owner'],
      createdTime: data['createdTime'],
      updatedTime: data['updatedTime'],
    );
  }
}
