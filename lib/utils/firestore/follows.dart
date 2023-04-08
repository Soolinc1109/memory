// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:memorys/model/follow.dart';
// import 'package:memorys/model/post.dart';

// class PostFirestore {
//   static final _firestoreInstance = FirebaseFirestore.instance;
//   static final CollectionReference follows =
//       _firestoreInstance.collection('follows');

//   static Future<dynamic> addFollow(Follow newFollow) async {
//     try {
//       final CollectionReference _userPosts = _firestoreInstance
//           .collection('users')
//           .doc(newFollow.id)
//           .collection('my_follows');
//       var result = await follows.add({
//         'content': newFollow.followed_uid,
//         'post_account_id': newFollow.id,
//         'created_time': Timestamp.now(),
//       });
//       //大きい枠組みのポストに投稿を追加！さらに自分のマイポストにも追加したい！
//       _userPosts
//           .doc(result.id)
//           .set({'post_id': result.id, 'created_time': Timestamp.now()});
//       //自分の投稿のみを入れるマイポストに登録！
//       print('投稿作成完了');
//       return true;
//     } on FirebaseException catch (e) {
//       print('投稿作成エラー');
//       return false;
//     }
//   }

//   static Future<List<Post>?> getPostFromIds(List<String> ids) async {
//     List<Post> postList = [];
//     try {
//       await Future.forEach(ids, (String id) async {
//         var doc = await follows.doc(id).get();

//         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//         Post post = Post(
//           posterId: doc.id,
//           postImageUrl: data.imafe,
//           content: data['content'],
//           postAccountId: data['post_account_id'],
//           createdAt: data['created_time'],
//         );
//         postList.add(post);
//       });
//       print('自分の投稿取得完了');
//       return postList;
//     } on FirebaseException catch (e) {
//       print('自分の投稿取得エラー');
//       return null;
//     }
//   }
// }
