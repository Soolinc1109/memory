import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memorys/model/post.dart';
import 'package:memorys/model/stylistpost.dart';

class StylistPostFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference posts =
      _firestoreInstance.collection('stylistpost');

  // FirebaseFirestore.instance.collection('posts').doc('5XisJiwreAqMtOZKNExb').get();//全部書くとこうなる

  static Future<dynamic> addStylistPost(StylistPost newPost) async {
    try {
      final CollectionReference _userPosts = _firestoreInstance
          .collection('users')
          .doc(newPost.postAccountId)
          .collection('my_stylist_post');

      var result = await posts.add({
        'message_for_customer': newPost.message_for_customer,
        'before_image': newPost.before_image,
        'after_image': newPost.after_image,
        'post_account_id': newPost.postAccountId,
        'created_at': Timestamp.now(),
        'customer_id': newPost.customer_id,
      });
      //大きい枠組みのポストに投稿を追加！さらに自分のマイポストにも追加したい！
      _userPosts
          .doc(result.id)
          .set({'post_id': result.id, 'created_time': Timestamp.now()});
      //自分の投稿のみを入れるマイポストに登録！
      print('スタイリスト個人の投稿作成完了');
      return true;
    } on FirebaseException catch (e) {
      print('スタイリスト個人の投稿作成エラー');
      return false;
    }
  }

  static Future<List<Post>?> getPostFromIds(List<String> ids) async {
    List<Post> postList = [];

    try {
      //自分のIDと同じ投稿のIDのやつだけ取ってきたい！
      await Future.forEach(ids, (String id) async {
        var doc = await posts.doc(id).get();
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Post post = Post(
          posterId: doc.id,
          content: data['content'],
          postAccountId: data['post_account_id'],
          createdAt: data['created_time'],
          postImageUrl: data['image'],
        );
        postList.add(post);
      });
      print('スタイリスト個人の投稿取得完了');
      return postList;
    } on FirebaseException catch (e) {
      print('スタイリスト個人の投稿取得エラー');
      return null;
    }
  }

  static Future<List<StylistPost>?> getUserPosts(String userId) async {
    List<StylistPost> postList = [];

    try {
      QuerySnapshot querySnapshot = await _firestoreInstance
          .collection('users')
          .doc(userId)
          .collection('my_posts')
          .get();

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        StylistPost post = StylistPost(
            id: doc.id,
            postAccountId: data['post_account_id'],
            message_for_customer: data['message_for_customer'],
            before_image: data['before_image'],
            after_image: data['after_image'],
            createdTime: data['created_time'],
            customer_id: data['customer_id']);
        postList.add(post);
      });
      print('ユーザーの投稿取得完了');
      return postList;
    } on FirebaseException catch (e) {
      print('ユーザーの投稿取得エラー');
      return null;
    }
  }
}
