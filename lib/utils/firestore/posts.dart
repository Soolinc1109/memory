import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memorys/model/post.dart';
import 'package:memorys/model/shop/carte.dart';

class PostFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference posts =
      _firestoreInstance.collection('userposts');
  static final CollectionReference cartes =
      _firestoreInstance.collection('carte');

  // FirebaseFirestore.instance.collection('posts').doc('5XisJiwreAqMtOZKNExb').get();//全部書くとこうなる

  static Future<dynamic> addPost(Post newPost) async {
    try {
      final CollectionReference _userPosts = _firestoreInstance
          .collection('users')
          .doc(newPost.postAccountId)
          .collection('my_posts');

      var result = await posts.add({
        'content': newPost.content,
        'image': newPost.postImageUrl,
        'post_account_id': newPost.postAccountId,
        'created_time': newPost.createdAt,
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

  static Future<String?> addCarte(Carte newPost) async {
    try {
//前回とったafter写真をprofile_imageにする
//前回のdetailcarte更新日をlast_visit_timeにする
      var result = await cartes.add({
        'customer_name': newPost.customer_name,
        'customer_katakana_name': newPost.customer_katakana_name,
        'post_stylist_account_id': newPost.post_stylist_account_id,
        'gender': newPost.gender,
        'shop_id': newPost.shop_id,
        'created_time': newPost.createdAt,
        //後からbeforeafter登録時にマージ
        'customer_id': newPost.customer_id,
        //ここから決め内
        'profile_image': '',
        'last_visit_time': Timestamp.now(),
        'save_count': 0,
      });
      print('カルテ投稿作成完了');
      return result.id;
    } on FirebaseException catch (e) {
      print('カルテ投稿作成エラー');
      return null;
    }
  }

  static Future<bool> updateCarte(String carteId, String image) async {
    try {
      // Update the specified document with new data
      await cartes.doc(carteId).update({
        'profile_image': image, // Update with the new profile_image
        'last_visit_time': Timestamp.now(),
      });
      print('カルテ投稿更新完了');
      return true;
    } on FirebaseException catch (e) {
      print('カルテ投稿更新エラー');
      return false;
    }
  }

  static Future<bool> updateCarteCustomerId(
      String carteId, String cusomerId) async {
    try {
      // Update the specified document with new data
      await cartes.doc(carteId).update({
        'customer_id': cusomerId, // Update with the new profile_image
      });
      print('カルテ投稿更新完了');
      return true;
    } on FirebaseException catch (e) {
      print('カルテ投稿更新エラー');
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
          createdAt: (data['created_time'] as Timestamp).toDate(),
          postImageUrl: data['image'],
        );
        postList.add(post);
        print(postList);
      });
      print('個人の投稿取得完了');
      return postList;
    } on FirebaseException catch (e) {
      print('個人の投稿取得エラー');
      return null;
    }
  }

  static Future<List<String>> getAllPostIds(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestoreInstance
          .collection('users')
          .doc(userId)
          .collection('my_posts')
          .get();
      List<String> postIds = [];

      for (var doc in querySnapshot.docs) {
        String postId = doc.id;
        postIds.add(postId);
      }
      print(postIds);
      return postIds;
    } on FirebaseException catch (e) {
      print('投稿情報の取得エラー: $e');
      return [];
    }
  }

  static Future<Map<DateTime, String>> createImageMap(String userId) async {
    Map<DateTime, String> imageMap = {};

    List<String> ids = await getAllPostIds(userId);
    // List<String> ids = await getAllPostIds();
    List<Post>? posts = await PostFirestore.getPostFromIds(ids);

    if (posts != null) {
      posts.forEach((post) {
        imageMap[post.createdAt] = post.postImageUrl;
      });
    }
    print(posts);
    return imageMap;
  }
}
