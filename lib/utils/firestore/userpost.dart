import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memorys/model/post.dart';
import 'package:memorys/model/userpost.dart';

class UserPostFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference userposts =
      _firestoreInstance.collection('userposts');

  // FirebaseFirestore.instance.collection('posts').doc('5XisJiwreAqMtOZKNExb').get();//全部書くとこうなる

  static Future<dynamic> addUserPost(UserPost newPost) async {
    try {
      final CollectionReference _userPosts = _firestoreInstance
          .collection('users')
          .doc(newPost.postAccountId)
          .collection('my_user_post');
      var result = await userposts.add({
        'content': newPost.content,
        'image': newPost.Image,
        'post_account_id': newPost.postAccountId,
        'created_time': Timestamp.now(),
      });
      //大きい枠組みのポストに投稿を追加！さらに自分のマイポストにも追加したい！
      _userPosts
          .doc(result.id)
          .set({'post_id': result.id, 'created_time': Timestamp.now()});
      //自分の投稿のみを入れるマイポストに登録！
      print('投稿作成完了');
      return true;
    } on FirebaseException catch (e) {
      print('投稿作成エラー');
      return false;
    }
  }

  static Future<List<UserPost>?> getUserPostFromIds(List<String> ids) async {
    List<UserPost> postList = [];

    try {
      //自分のIDと同じ投稿のIDのやつだけ取ってきたい！
      await Future.forEach(ids, (String id) async {
        var doc = await userposts.doc(id).get();

        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        UserPost post = UserPost(
          id: doc.id,
          content: data['content'],
          postAccountId: data['post_account_id'],
          createdTime: data['created_time'],
          Image: data['image'],
        );
        postList.add(post);
      });
      print('個人の投稿取得完了');
      return postList;
    } on FirebaseException catch (e) {
      print('個人の投稿取得エラー');
      return null;
    }
  }
}
