import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memorys/model/post.dart';
import 'package:memorys/model/shop/detail.dart';
import 'package:memorys/model/shop/stylistpost.dart';

class StylistPostFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference posts =
      _firestoreInstance.collection('stylistpost');

  // FirebaseFirestore.instance.collection('posts').doc('5XisJiwreAqMtOZKNExb').get();//全部書くとこうなる

  static Future<String?> addStylistPost(StylistPost newPost) async {
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
        'carte_id': newPost.carte_id,
        'is_favorite': false,
        'shop_id': newPost.shop_id,
        'memo': ''
      });
      //大きい枠組みのポストに投稿を追加！さらに自分のマイポストにも追加したい！
      _userPosts
          .doc(result.id)
          .set({'post_id': result.id, 'created_time': Timestamp.now()});
      //自分の投稿のみを入れるマイポストに登録！
      print('スタイリスト個人の投稿作成完了');
      return result.id;
    } on FirebaseException catch (e) {
      print('スタイリスト個人の投稿作成エラー');
      return null;
    }
  }

  static Future<dynamic> updateStylistPost(
      String postId, StylistPost updatedPost) async {
    print(postId);
    try {
      await posts.doc(postId).update(
          {'is_favorite': true, 'favorite_level': updatedPost.favorite_level});

      //自分の投稿のみを入れるマイポストを更新！
      print('スタイリスト個人の投稿更新完了');
      return true;
    } on FirebaseException catch (e) {
      print('スタイリスト個人の投稿更新エラー');
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
            carte_id: data['carte_id'],
            shop_id: data['shop_id'],
            id: doc.id,
            postAccountId: data['post_account_id'],
            message_for_customer: data['message_for_customer'],
            before_image: data['before_image'],
            after_image: data['after_image'],
            createdTime: data['created_time'],
            customer_id: data['customer_id']);
        postList.add(post);
      });
      print('スタイリストの投稿取得完了');
      return postList;
    } on FirebaseException catch (e) {
      print('スタイリストの投稿取得エラー');
      return null;
    }
  }

  static Future<bool> addCarteDetail(String carteId, CarteDetail detail) async {
    try {
      await _firestoreInstance
          .collection('carte')
          .doc(carteId)
          .collection('detail')
          .add({
        'before_after_post_id': detail.before_after_post_id,
        'memo': detail.memo,
        'menu_id': detail.menu_id,
        'post_stylist_id': detail.post_stylist_id,
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<List<StylistPost>> getPostByStaffIds(
      List<String> staffIds) async {
    List<StylistPost> stylistPostList = [];

    try {
      final snapshot =
          await posts.where('post_account_id', whereIn: staffIds).get();
      snapshot.docs.forEach((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final post = StylistPost(
          id: doc.id,
          postAccountId: data['post_account_id'],
          shop_id: data['shop_id'],
          carte_id: data['carte_id'],
          customer_id: data['customer_id'],
          poster_image_url: data['poster_image_url'],
          before_image: data['before_image'],
          after_image: data['after_image'],
          createdTime: data['created_time'],
          is_favorite: data['is_favorite'],
          favorite_level: data['favorite_level'],
          message_for_customer: data['message_for_customer'],
        );
        stylistPostList.add(post);
      });

      print('スタイリスト投稿取得完了');
      return stylistPostList;
    } on FirebaseException catch (e) {
      print('スタイリスト投稿取得エラー: $e');
      return [];
    }
  }
}
