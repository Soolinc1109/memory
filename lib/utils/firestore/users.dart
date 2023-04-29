import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/utils/authentication.dart';
import 'package:memorys/utils/firestore/shops.dart';

class UserFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static final CollectionReference users =
      _firestoreInstance.collection('users');

  static Future<bool> setUser(Account newAccount) async {
    try {
      await users.doc(newAccount.id).set({
        'name': newAccount.name,
        'user_id': newAccount.userId,
        'shop_id': '',
        'self_introduction': newAccount.selfIntroduction,
        'image_path': newAccount.imagepath,
        'created_time': Timestamp.now(),
        'updated_time': Timestamp.now(),
        'is_stylist': newAccount.is_stylist,
        'is_owner': newAccount.is_owner,
        'favorite_image_0':
            'https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/%E3%81%82%E3%81%AA%E3%81%9F%E3%81%AE%E3%81%8A%E6%B0%97%E3%81%AB%E5%85%A5%E3%82%8A%E3%81%AE%E9%AB%AA%E5%9E%8B%E3%82%92%E7%99%BB%E9%8C%B2%E3%81%97%E3%81%BE%E3%81%97%E3%82%87%E3%81%86.png?alt=media&token=d2d403e4-d4ae-4c9e-a584-1a086cf8c616',
        'favorite_image_1': '',
        'favorite_image_2': '',
        'favorite_image_3': '',
        'favorite_image_4': '',
      });
      print('新規ユーザー作成完了');
      return true;

      //serUserを実行した結果を返している（戻り値）
    } on FirebaseException catch (e) {
      print('新規ユーザー作成エラー');
      return false;
    }
  }

  static Future<Account?> getUser(String uid) async {
    try {
      DocumentSnapshot documentSnapshot = await users.doc(uid).get();
      Map<String, dynamic>? data =
          documentSnapshot.data() as Map<String, dynamic>;
      final myAccount = Account(
        id: uid,
        name: data['name'],
        userId: data['user_id'],
        shopId: data['shop_id'],
        selfIntroduction: data['self_introduction'],
        imagepath: data['image_path'],
        createdTime: data['created_time'],
        updatedTime: data['updated_time'],
        is_stylist: data['is_stylist'],
        is_owner: data['is_owner'],
        menu_id: data['menu_id'] ?? [],
        favorite_image_0: data['favorite_image_0'],
        favorite_image_1: data['favorite_image_1'],
        favorite_image_2: data['favorite_image_2'],
        favorite_image_3: data['favorite_image_3'],
        favorite_image_4: data['favorite_image_4'],
      );

      Authentication.myAccount = myAccount;
      print('ユーザー取得完了');
      return myAccount;
    } on FirebaseException catch (e) {
      print('ユーザー取得エラー: FirebaseException');
      print(e);
      return null;
    } catch (e) {
      print('ユーザー取得エラー: その他の例外');
      print(e);
      return null;
    }
  }

  static Future<dynamic> updateUser(Account updateAccount) async {
    try {
      await users.doc(updateAccount.id).update({
        'name': updateAccount.name,
        'user_id': updateAccount.userId,
        'self_introduction': updateAccount.selfIntroduction,
        'image_path': updateAccount.imagepath,
        'updated_time': Timestamp.now(),
        'is_stylist': updateAccount.is_stylist,
        'favorite_image_0': updateAccount.favorite_image_0,
        'favorite_image_1': updateAccount.favorite_image_1,
        'favorite_image_2': updateAccount.favorite_image_2,
        'favorite_image_3': updateAccount.favorite_image_3,
        'favorite_image_4': updateAccount.favorite_image_4,
        'shop_id': updateAccount.shopId,
        'menu_id': updateAccount.menu_id
      });
      print('ユーザー情報の更新完了');
      return true;
    } on FirebaseException catch (e) {
      print('ユーザー情報の更新エラー: $e');
      print(e);
      return false;
    }
  }

//全員の投稿を表示
  static Future<Map<String, Account>?> getPostUserMap(
      List<String> accountIds) async {
    Map<String, Account> map = {};
    try {
      await Future.forEach(accountIds, (String accountId) async {
        var doc = await users.doc(accountId).get();
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print(data);
        final postAccount = Account(
            id: accountId,
            name: data['name'],
            userId: data['user_id'],
            imagepath: data['image_path'],
            selfIntroduction: data['self_introduction'],
            createdTime: data['created_time'],
            updatedTime: data['updated_time']);
        map[accountId] = postAccount;
      });
      print('投稿ユーザーの情報取得完了');

      return map;
    } on FirebaseException catch (e) {
      print('投稿ユーザーの情報取得失敗: $e');
      return null;
    }
  }

  //ユーザー全員一覧表示
  static Future<List<Account>> getUsersMap(List<String> accountIds) async {
    List<Account> accountList = [];
    try {
      await Future.forEach(accountIds, (String accountId) async {
        var doc = await users.doc(accountId).get();
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Account userAccount = Account(
          id: doc.id,
          name: data['name'],
          userId: data['user_id'],
          shopId: data['shop_id'],
          selfIntroduction: data['self_introduction'],
          imagepath: data['image_path'],
          createdTime: data['created_time'],
          updatedTime: data['updated_time'],
          is_stylist: data['is_stylist'],
          menu_id: data['menu_id'] ?? [],
          is_owner: data['is_owner'],
          favorite_image_0: data['favorite_image_0'],
          favorite_image_1: data['favorite_image_1'],
          favorite_image_2: data['favorite_image_2'],
          favorite_image_3: data['favorite_image_3'],
          favorite_image_4: data['favorite_image_4'],
        );
        accountList.add(userAccount);
      });
      print('投稿ユーザーの情報取得完了');
      return accountList;
    } on FirebaseException catch (e) {
      print('投稿ユーザーの情報取得失敗: $e');
      return [];
    }
  }

  static Future<dynamic> followUser(
      Account followAccount, String myAccountId) async {
    //すでにフォローしている人はできないようにしたい！→　my_followsに存在していいidは一つだけ且つ自分以外
    //followアカウントID　＝　タップしている人のID
    try {
      final CollectionReference _myFollows = _firestoreInstance
          .collection('users')
          .doc(myAccountId)
          .collection('my_follows');
      // if(_myFollows.id != )
      var result = await _myFollows.add({
        'following_id': followAccount.id,
        'created_time': Timestamp.now(),
      });
      print('フォロー完了');
      return true;
    } on FirebaseException catch (e) {
      print('フォローエラー');
      return false;
    }
  }

  static Future<dynamic> removeUser(
      String removeAccountDocumentId, String myAccountId) async {
    //removeアカウント→タップした人のid
    //myAccountid→自分
    try {
      final CollectionReference _myFollows = _firestoreInstance
          .collection('users')
          .doc(myAccountId)
          .collection('my_follows');
      // if(_myFollows.id != )
      var result = await _myFollows.doc(removeAccountDocumentId).delete();
      print('フォロー削除完了');
      return true;
    } on FirebaseException catch (e) {
      print('フォロー削除エラー');
      return false;
    }
  }

  static Future<String> uploadImage(File? imageFile) async {
    if (imageFile != null) {
      try {
        String uid = Authentication.myAccount!.id;
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('favorite_hair_images/$uid/${DateTime.now().toString()}');
        UploadTask uploadTask = ref.putFile(imageFile);
        TaskSnapshot taskSnapshot = await uploadTask;
        String imageUrl = await taskSnapshot.ref.getDownloadURL();
        return imageUrl;
      } catch (e) {
        print('画像アップロードエラー: $e');
        return '';
      }
    } else {
      return '';
    }
  }

  static Future<void> uploadFavoriteHairImage(int index, File imageFile) async {
    try {
      // 画像をアップロードし、ダウンロードURLを取得
      final String uid = FirebaseAuth.instance.currentUser!.uid;
      final String imagePath = 'favorite_images/$uid/image_url_$index';
      final Reference ref = FirebaseStorage.instance.ref().child(imagePath);
      final UploadTask uploadTask = ref.putFile(imageFile);

      // Subscribe to the snapshotEvents stream
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        print(
            'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
      }, onError: (Object e, StackTrace s) {
        print('Error during upload: $e');
        print('Stack trace: $s');
      });

      final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      final String imageUrl = await snapshot.ref.getDownloadURL();

      // ダウンロードURLをFirestoreにアップデート
      await users.doc(uid).update({
        'favorite_image_$index': imageUrl,
      });
    } catch (e, s) {
      print('Error uploading image: $e');
      print('Stack trace: $s');
    }
  }

  static Future<Account> getAccount() async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    final DocumentSnapshot doc = await users.doc(uid).get();

    return Account(
      id: uid,
      name: doc['name'],
      imagepath: doc['imagepath'],
      favorite_image_0: doc['favorite_image_0'],
      favorite_image_1: doc['favorite_image_1'],
      favorite_image_2: doc['favorite_image_2'],
      favorite_image_3: doc['favorite_image_3'],
      favorite_image_4: doc['favorite_image_4'],
      selfIntroduction: doc['selfIntroduction'],
      userId: doc['userId'],
      follow: doc['follow'],
      follower: doc['follower'],
      is_stylist: doc['is_stylist'],
      createdTime: doc['createdTime'],
      updatedTime: doc['updatedTime'],
    );
  }

  static Future<List<Map<String, dynamic>>> getMyStylistPosts(
      Account userAccount) async {
    try {
      final FirebaseFirestore _db = FirebaseFirestore.instance;
      final List<Map<String, dynamic>> myStylistPosts = [];
      final querySnapshot = await _db
          .collection('users')
          .doc(userAccount.id)
          .collection('my_stylist_post')
          .get();

      querySnapshot.docs.forEach((doc) {
        myStylistPosts.add(doc.data());
      });

      return myStylistPosts;
    } catch (e) {
      print(e);
      return [];
    }
  }

  //ショップのカスタマー
  static Stream<List<Account>> getCustomerList(Account myaccount) async* {
    try {
      List<String> customerInfomations =
          await ShopFirestore.getCustomerInformationcustomerid(
              myaccount.shopId);
      if (customerInfomations.isEmpty) {
        yield [];
        return;
      }
      print(customerInfomations);

      final fetchedDocuments = await getDocumentsWithIds(customerInfomations);

      List<Account> accountList = [];

      print(fetchedDocuments);

      fetchedDocuments.forEach((doc) {
        Map<String, dynamic>? data = doc.data();

        Account userAccount = Account(
          id: doc.id,
          name: data!['name'],
          userId: data['user_id'],
          shopId: data['shop_id'],
          selfIntroduction: data['self_introduction'],
          imagepath: data['image_path'],
          createdTime: data['created_time'],
          updatedTime: data['updated_time'],
          is_stylist: data['is_stylist'],
          is_owner: data['is_owner'],
          favorite_image_0: data['favorite_image_0'],
          favorite_image_1: data['favorite_image_1'],
          favorite_image_2: data['favorite_image_2'],
          favorite_image_3: data['favorite_image_3'],
          favorite_image_4: data['favorite_image_4'],
        );
        accountList.add(userAccount);
      });

      print(accountList);

      yield accountList;
    } catch (e) {
      print(e);
      print('エラー￥');
    }
  }

  static Future<List<DocumentSnapshot<Map<String, dynamic>>>>
      getDocumentsWithIds(List<String> ids) async {
    print(ids);
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final customersCollection = _firestore.collection('users');
    final List<DocumentSnapshot<Map<String, dynamic>>> documents = [];
    for (final id in ids) {
      if (id != null && id.isNotEmpty) {
        final docSnapshot = await customersCollection.doc(id).get();
        print('Document ID: $id');
        print('docSnapshot.exists: ${docSnapshot.exists}');
        print('docSnapshot.data(): ${docSnapshot.data()}');
        if (docSnapshot.exists) {
          documents.add(docSnapshot);
        } else {}
      } else {
        print('Invalid or empty document ID: $id');
      }
    }
    return documents;
  }

  static Future<List<String>> getImagePathsByIds(List<String> ids) async {
    List<String> imagePaths = [];
    print(ids);

    for (String id in ids) {
      try {
        DocumentSnapshot documentSnapshot = await users.doc(id).get();
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        String imagePath = data['image_path'] ?? '';
        imagePaths.add(imagePath);
      } catch (e) {
        print('画像パス取得エラー: $e');
      }
    }
    print(imagePaths);

    return imagePaths;
  }
}
