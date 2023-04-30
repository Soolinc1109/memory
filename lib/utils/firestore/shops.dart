import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/model/shop/menu.dart';
import 'package:memorys/model/shop/shop.dart';
import 'package:memorys/utils/firestore/users.dart';

class ShopFirestore {
  static List<Shop> shopList = [];

  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference shops =
      _firestoreInstance.collection('Shop');

  static Stream<List<Shop>> getShops(List<String> shopIds) async* {
    List<Shop> _shopList = [];

    for (int i = 0; i < shopIds.length; i++) {
      if (shopIds[i] == null || shopIds[i].isEmpty) {
        continue;
      }

      try {
        var shopReference = await shops.doc(shopIds[i]).get();

        Map<String, dynamic> data =
            shopReference.data() as Map<String, dynamic>;

        Shop shop = Shop(
            shopPhone: data['shop_phone'],
            name: data['name'],
            ownerId: data['owner_id'],
            shopIntroduction: data['shop_intoroduction'],
            logoImage: data['logoImage'],
            shop_front_image_0: data['shop_front_image_0'],
            shop_front_image_1: data['shop_front_image_1'],
            shop_front_image_2: data['shop_front_image_2'],
            snsUrl: List<String>.from(data['sns']),
            staff: List<String>.from(data['staff']));
        _shopList.add(shop);

        print('お店の情報取得完了');
      } on FirebaseException catch (e) {
        print('お店の情報取得エラー: $e');
      }
    }
    yield _shopList;
  }

  static Stream<Shop> getShop(String shopId) async* {
    try {
      if (shopId.isEmpty) {
        print('エラー: shopIdが空です');
        return;
      }
      var shopReference = await shops.doc(shopId).snapshots();

      await for (var snapshot in shopReference) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        final shop = Shop(
            id: shopId,
            shopPhone: data['shop_phone'],
            ownerId: data['owner_id'],
            name: data['name'],
            shopIntroduction: data['shop_intoroduction'],
            logoImage: data['logoImage'],
            shop_front_image_0: data['shop_front_image_0'],
            shop_front_image_1: data['shop_front_image_1'],
            shop_front_image_2: data['shop_front_image_2'],
            snsUrl: List<String>.from(data['sns']),
            staff: List<String>.from(data['staff']));
        yield shop;

        print('お店の情報取得完了');
      }
    } on FirebaseException catch (e) {
      print('お店の情報取得エラー: $e');
    }
  }

  static Future<bool> addShopToFirebase(Shop shop, Account ownerAccount) async {
    try {
      DocumentReference newShopRef = shops.doc();
      shop.id = newShopRef.id;

      await newShopRef.set({
        'owner_id': shop.ownerId,
        'name': shop.name,
        'shop_phone': shop.shopPhone,
        'shop_intoroduction': shop.shopIntroduction,
        'logoImage': shop.logoImage,
        'shop_front_image_0': shop.shop_front_image_0,
        'shop_front_image_1': shop.shop_front_image_1,
        'shop_front_image_2': shop.shop_front_image_2,
        'sns': shop.snsUrl,
        'staff': shop.staff
      });
      Account updateAccount = Account(
        name: ownerAccount.name,
        selfIntroduction: ownerAccount.selfIntroduction,
        imagepath: ownerAccount.imagepath,
        is_stylist: true,
        is_owner: true,
        favorite_image_0: ownerAccount.favorite_image_0,
        favorite_image_1: ownerAccount.favorite_image_1,
        favorite_image_2: ownerAccount.favorite_image_2,
        favorite_image_3: ownerAccount.favorite_image_3,
        favorite_image_4: ownerAccount.favorite_image_4,
        shopId: shop.id,
      );
      UserFirestore.updateUser(updateAccount);

      print('お店が追加されました');
      return true;
    } on FirebaseException catch (e) {
      print('お店の追加に失敗しました: $e');
      return false;
    }
  }

  static Future<dynamic> updateShop(Shop updateShopAccount) async {
    try {
      await shops.doc(updateShopAccount.id).update({
        'name': updateShopAccount.name,
        'owner_id': updateShopAccount.ownerId,
        'shop_intoroduction': updateShopAccount.shopIntroduction,
        'logoImage': updateShopAccount.logoImage,
        'updated_time': Timestamp.now(),
        'sns': updateShopAccount.snsUrl,
        'shop_front_image_0': updateShopAccount.shop_front_image_0,
        'shop_front_image_1': updateShopAccount.shop_front_image_1,
        'shop_front_image_2': updateShopAccount.shop_front_image_2,
      });
      print('ショップ情報の更新完了');
      return true;
    } on FirebaseException catch (e) {
      print('ショップ情報の更新エラー: $e');
      print(e);
      return false;
    }
  }

  static Future<bool> addStaffToShop(String shopId, String staffId) async {
    try {
      DocumentReference shopRef = shops.doc(shopId);
      await shopRef.update({
        'staff': FieldValue.arrayUnion([staffId])
      });
      print('スタッフIDが追加されました');
      return true;
    } on FirebaseException catch (e) {
      print('スタッフIDの追加に失敗しました: $e');
      return false;
    }
  }

  static Future<bool> removeStaffFromShop(String shopId, String staffId) async {
    try {
      DocumentReference shopRef = shops.doc(shopId);
      await shopRef.update({
        'staff': FieldValue.arrayRemove([staffId])
      });
      print('スタッフIDが削除されました');
      return true;
    } on FirebaseException catch (e) {
      print('スタッフIDの削除に失敗しました: $e');
      return false;
    }
  }

  static Future<bool> addCustomerInformation(String shopId,
      {String? customerId,
      String? postId,
      String? stylistId,
      String? carteId}) async {
    try {
      CollectionReference customerInfoRef =
          shops.doc(shopId).collection('customer_information');
      await customerInfoRef.add({
        'carte_id': carteId ?? '',
        'customer_id': customerId ?? '',
        'post_id': postId ?? '',
        'stylist_id': stylistId ?? '',
      });
      print('顧客情報が追加されました');
      return true;
    } on FirebaseException catch (e) {
      print('顧客情報の追加に失敗しました: $e');
      return false;
    }
  }

  // customer_informationのデータを更新する関数
  static Future<bool> updateCustomerInformation(
    String shopId,
    String customerInfoId, {
    String? customerId,
  }) async {
    try {
      CollectionReference customerInfoRef =
          shops.doc(shopId).collection('customer_information');
      await customerInfoRef.doc(customerInfoId).update({
        if (customerId != null) 'customer_id': customerId,
      });
      print('顧客情報が更新されました');
      return true;
    } on FirebaseException catch (e) {
      print('顧客情報の更新に失敗しました: $e');
      return false;
    }
  }

  // customer_informationのデータを取得する関数
  static Future<List<String>> getCustomerInformationcustomerid(
      String shopId) async {
    // customer_informationのデータを取得し、customer_idだけを含むリストを返す関数
    List<String> customerIdList = [];

    try {
      if (shopId.isEmpty) {
        print('エラー: shopIdが空です');
        return [];
      }
      CollectionReference customerInfoRef =
          shops.doc(shopId).collection('customer_information');
      QuerySnapshot querySnapshot = await customerInfoRef.get();

      querySnapshot.docs.forEach((doc) {
        customerIdList.add((doc.data() as Map<String, dynamic>)['customer_id']);
      });

      print('顧客ID情報が取得されました');
      return customerIdList;
    } on FirebaseException catch (e) {
      print('顧客ID情報の取得に失敗しました: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getCustomerInformation(
      String shopId) async {
    List<Map<String, dynamic>> customerInformationList = [];

    try {
      CollectionReference customerInfoRef =
          shops.doc(shopId).collection('customer_information');
      QuerySnapshot querySnapshot = await customerInfoRef.get();

      querySnapshot.docs.forEach((doc) {
        customerInformationList.add(doc.data() as Map<String, dynamic>);
      });

      print('顧客情報が取得されました');
      return customerInformationList;
    } on FirebaseException catch (e) {
      print('顧客情報の取得に失敗しました: $e');
      return [];
    }
  }

  static Future<bool> addMenu(String shopId, Menu newMenu) async {
    try {
      CollectionReference shopRef =
          FirebaseFirestore.instance.collection('Shop');

      CollectionReference servicesRef =
          shopRef.doc(shopId).collection('service');
      Map<String, dynamic> menuData = {
        'description': newMenu.description,
        'duration': newMenu.duration,
        'name': newMenu.name,
        'menu_image': newMenu.menu_image,
        'price': newMenu.price,
        'stylist_ids': newMenu.stylist_ids,
      };
      await servicesRef.add(menuData);
      return true;
    } catch (e) {
      throw Exception('メニュー登録失敗: $e');
    }
  }

  static Future<bool> updateMenu(
      String shopId, String menuId, Menu updatedMenu) async {
    try {
      CollectionReference shopRef =
          FirebaseFirestore.instance.collection('Shop');

      CollectionReference servicesRef =
          shopRef.doc(shopId).collection('service');
      Map<String, dynamic> updatedMenuData = {
        'description': updatedMenu.description,
        'duration': updatedMenu.duration,
        'name': updatedMenu.name,
        'menu_image': updatedMenu.menu_image,
        'price': updatedMenu.price,
        'stylist_ids': updatedMenu.stylist_ids,
      };
      await servicesRef.doc(menuId).update(updatedMenuData);
      return true;
    } catch (e) {
      throw Exception('メニュー更新失敗: $e');
    }
  }

  static Stream<List<String>> getStaffIds(String shopId) async* {
    if (shopId.isEmpty) {
      print('エラー: shopIdが空です');
      return;
    }

    try {
      var shopReference = shops.doc(shopId).snapshots();

      await for (var snapshot in shopReference) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        List<String> staff = List<String>.from(data['staff']);
        yield staff;
      }
    } on FirebaseException catch (e) {
      print('スタッフID取得エラー: $e');
    }
  }
}
