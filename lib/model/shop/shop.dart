import 'package:cloud_firestore/cloud_firestore.dart';

class Shop {
  String id;
  String ownerId;
  String name;
  String shopIntroduction;
  String logoImage;
  String shop_front_image_0;
  String shop_front_image_1;
  String shop_front_image_2;
  int shopPhone;
  List<String>? snsUrl;
  List<String> staff;

  List<String?> get shopFrontImages => [
        shop_front_image_0,
        shop_front_image_1,
        shop_front_image_2,
      ];

  Shop({
    this.id = '',
    this.ownerId = '',
    this.name = '',
    this.shopPhone = 1,
    this.shopIntroduction = '',
    this.logoImage = '',
    this.shop_front_image_0 = '',
    this.shop_front_image_1 = '',
    this.shop_front_image_2 = '',
    this.snsUrl,
    required this.staff,
  });

  Shop.fromDocumentSnapshot(DocumentSnapshot doc)
      : id = doc.id,
        ownerId = doc['ownerId'] ?? '',
        name = doc['name'] ?? '',
        shopIntroduction = doc['shopIntroduction'] ?? '',
        logoImage = doc['logoImage'] ?? '',
        shop_front_image_0 = doc['shop_front_image_0'] ?? '',
        shop_front_image_1 = doc['shop_front_image_1'] ?? '',
        shop_front_image_2 = doc['shop_front_image_2'] ?? '',
        shopPhone = doc['shopPhone'] ?? 1,
        snsUrl = List<String>.from(doc['snsUrl'] ?? []),
        staff = List<String>.from(doc['staff'] ?? []);
}
