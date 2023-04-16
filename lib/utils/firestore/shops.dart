import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memorys/model/shop/shop.dart';

class ShopFirestore {
  static List<Shop> shopList = [];

  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference shops =
      _firestoreInstance.collection('Shop');

  static Future<List<Shop>> getShop() async {
    List<Shop> _shopList = [];
    try {
      var shopReference = await shops.doc('wfEzj6LB1y5ppZ5gX3yC').get();

      Map<String, dynamic> data = shopReference.data() as Map<String, dynamic>;

      Shop shop = Shop(
          shopPhone: data['shop_phone'],
          name: data['name'],
          shopIntroduction: data['shop_intoroduction'],
          logoImage: data['logoImage'],
          shopImage: List<String>.from(data['image']),
          snsUrl: List<String>.from(data['sns']),
          staff: List<String>.from(data['staff']));
      _shopList.add(shop);

      print('お店の情報取得完了');
    } on FirebaseException catch (e) {
      print('お店の情報取得エラー: $e');
    }
    return _shopList;
  }
}
