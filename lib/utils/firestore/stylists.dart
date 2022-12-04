import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/model/message.dart';
import 'package:memorys/utils/authentication.dart';
import 'package:memorys/view/time_line/talk_room.dart';

class StylistFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference userCollection =
      _firestoreInstance.collection('users');
  static final CollectionReference roomCollection =
      _firestoreInstance.collection('rooms');

  //スタイリストをfirestoreに追加
  static Future<bool> setUser(Account newAccount) async {
    try {
      await userCollection.doc(newAccount.id).set({
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
      DocumentSnapshot documentSnapshot = await userCollection.doc(uid).get();
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
      await userCollection.doc(updateAccount.id).update({
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
        var doc = await userCollection.doc(accountId).get();
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
        var doc = await userCollection.doc(accountId).get();
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

  static Future<List<String>?> getAllUser() async {
    try {
      final snapshot = await userCollection.get();
      List<String> userIds = [];
      snapshot.docs.forEach((user) {
        userIds.add(user.id);
      });
      return userIds;
    } catch (e) {
      print('失敗');
      return null;
    }
  }

  //ルーム作成
  // static Future<List<String>?> getRoom(String myId, String partnerId) async {
  //   try {
  //     final snapshot = await rooms.get();
  //    snapshot.d
  //     print(roomIds);
  //     return roomIds;
  //   } catch (e) {
  //     print('失敗');
  //     return null;
  //   }
  // }

  static Future<dynamic> followUser(
      String followAccountId, String myAccountId) async {
    //すでにフォローしている人はできないようにしたい！→　my_followsに存在していいidは一つだけ且つ自分以外
    //followアカウントID　＝　タップしている人のID
    try {
      final _myFollows = _firestoreInstance
          .collection('users')
          .doc(myAccountId)
          .collection('my_follows')
          .doc(followAccountId);
      // if(_myFollows.id != )
      var result = await _myFollows.set({
        'following_id': followAccountId,
        'created_time': Timestamp.now(),
      });
      print('フォロー完了');
      return true;
    } on FirebaseException catch (e) {
      print('フォローエラー');
      return false;
    }
  }

  static Future<List<String>> getAllFolowingUser(String myId) async {
    final snapshot =
        await userCollection.doc(myId).collection('my_follows').get();
    List<String> FollowingUserIds = [];
    snapshot.docs.forEach((follows) {
      FollowingUserIds.add(follows.id);
    });
    return FollowingUserIds;
  }

  static Future<void> makeRoomAndAddMyFriend(
      String myId, String partnerId) async {
    List<String>? userIds = await getAllUser();
    List<String>? follows = await getAllFolowingUser(myId);

    if (follows.contains(partnerId)) {
    } else
      (roomCollection.add({
        'joined_user_ids': [myId, partnerId],
        'updated_time': Timestamp.now()
      }));
    followUser(partnerId, myId);

//タップした時にjoined_user_idsをみて自分のIDと相手のIDが存在す場合作らない
  }

//メッセージ一覧の取得
  static Stream<List<Message>> subscribeMessages(String roomId, String myId) {
    final messagesStream = roomCollection
        .doc(roomId)
        .collection('message')
        .orderBy('send_time', descending: true)
        .snapshots();
    final messages = messagesStream.map((qs) {
      return qs.docs.map((qds) {
        final data = qds.data();
        final message = Message(
          message: data['message'],
          isMe: data['sender_id'] == myId,
          sendTime: (data['send_time'] as Timestamp).toDate(),
        );
        return message;
      }).toList();
    });
    return messages;
  }

  // リアルタイム　＝　snapshot
  //無限スクロール

  static Future<void> makeMessage(
      String myId, Message messageInfo, String talkRoomId) async {
    List<String>? userIds = await getAllUser();
    List<String>? follows = await getAllFolowingUser(myId);
    print(myId);
    print(messageInfo.message);

    roomCollection.doc(talkRoomId).collection('message').add({
      'message': messageInfo.message,
      'send_time': messageInfo.sendTime,
      'sender_id': myId,
    });

//タップした時にjoined_user_idsをみて自分の
//IDと相手のIDが存在す場合作らない
  }

  static Future<void> fetchJoinedRooms() async {}
}
