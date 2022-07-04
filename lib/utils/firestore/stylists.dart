import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/utils/authentication.dart';

class StylistFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference users =
      _firestoreInstance.collection('users');

  //スタイリストをfirestoreに追加
  static Future<bool> setUser(Account newAccount) async {
    try {
      await users.doc(newAccount.id).set({
        'name': newAccount.name,
        'user_id': newAccount.userId,
        'self_introduction': newAccount.selfIntroduction,
        'image_path': newAccount.imagepath,
        'created_time': Timestamp.now(),
        'updated_time': Timestamp.now(),
      });
      print('新規スタイリスト作成完了');
      return true;

      //serUserを実行した結果を返している（戻り値）
    } on FirebaseException catch (e) {
      print('新規スタイリスト作成エラー');
      return false;
    }
  }

  static Future<bool> getUser(String uid) async {
    try {
      DocumentSnapshot documentSnapshot = await users.doc(uid).get();
      Map<String, dynamic>? data =
          documentSnapshot.data() as Map<String, dynamic>;
      Account myAccount = Account(
          id: uid,
          name: data['name'],
          userId: data['user_id'],
          selfIntroduction: data['self_introduction'],
          imagepath: data['image_path'],
          createdTime: data['created_time'],
          updatedTime: data['updated_time'],
          is_stylist: data['is_stylist']);
      Authentication.myAccount = myAccount;
      print('スタイリスト取得完了');
      return true;
    } on FirebaseException catch (e) {
      print('スタイリスト取得エラー');
      print(e);
      return false;
    }
  }

  static Future<dynamic> updateStylist(Account updateAccount) async {
    try {
      await users.doc(updateAccount.id).update({
        'name': updateAccount.name,
        'user_id': updateAccount.userId,
        'self_introduction': updateAccount.selfIntroduction,
        'image_path': updateAccount.imagepath,
        'updated_time': Timestamp.now(),
      });
      print('スタイリスト情報の更新完了');
      return true;
    } on FirebaseException catch (e) {
      print('スタイリスト情報の更新エラー: $e');
      print(e);
      return false;
    }
  }

//全員の投稿を表示
  static Future<Map<String, Account>?> getStylistPostUserMap(
      List<String> accountIds) async {
    Map<String, Account> map = {};
    try {
      await Future.forEach(accountIds, (String accountId) async {
        var doc = await users.doc(accountId).get();
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Account postAccount = Account(
            id: accountId,
            name: data['name'],
            userId: data['user_id'],
            imagepath: data['image_path'],
            selfIntroduction: data['self_introduction'],
            createdTime: data['created_time'],
            updatedTime: data['updated_time']);
        map[accountId] = postAccount;
      });
      print('投稿スタイリストの情報取得完了');
      return map;
    } on FirebaseException catch (e) {
      print('投稿スタイリストの情報取得失敗: $e');
      return null;
    }
  }

  //スタイリスト全員一覧表示
  static Future<List<Account>> getUsersMap(List<String> accountIds) async {
    List<Account> accountList = [];
    try {
      await Future.forEach(accountIds, (String accountId) async {
        var doc = await users.doc(accountId).get();
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Account userAccount = Account(
            id: accountId,
            name: data['name'],
            userId: data['user_id'],
            imagepath: data['image_path'],
            selfIntroduction: data['self_introduction'],
            createdTime: data['created_time'],
            updatedTime: data['updated_time']);
        accountList.add(userAccount);
      });
      print('投稿スタイリストの情報取得完了');

      return accountList;
    } on FirebaseException catch (e) {
      print('投稿スタイリストの情報取得失敗: $e');
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

  // static Future<dynamic> getUserFollowing() async {
  //   users.get();
  //   print("${myDocuments.documents.length}");
  // }
}
