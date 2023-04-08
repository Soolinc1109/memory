import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memorys/model/post.dart';

class PostFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference posts =
      _firestoreInstance.collection('userposts');

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
        'created_time': Timestamp.now(),
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
}
