// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:memorys/model/account.dart';
// import 'package:memorys/model/post.dart';
// import 'package:intl/intl.dart';

// class ActivityPage extends StatefulWidget {
//   const ActivityPage({Key? key}) : super(key: key);

//   @override
//   _ActivityPageState createState() => _ActivityPageState();
// }

// class _ActivityPageState extends State<ActivityPage> {
//   Account myAccount = Account(
//       //引数として変数に値を入れることができる
//       id: '1',
//       name: ' Ohana直島',
//       selfIntroduction: '',
//       userId: 'ohana.naoshima',
//       imagepath: '',
//       createdTime: Timestamp.now());

// //ポストのインスタンスを格納したリスト型の変数、を定義
//   // List<Post> postList = [
//   //   Post(
//   //       id: '1',
//   //       content: '海賊王に俺はなる',
//   //       postAccountId: '1',
//   //       createdTime: Timestamp.now()),
//   //   Post(
//   //       id: '2',
//   //       content: '上場する',
//   //       postAccountId: '2',
//   //       createdTime: Timestamp.now()),
//   // ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           myAccount.name,
//           style: TextStyle(color: Colors.black),
//         ),
//         backgroundColor: Theme.of(context).canvasColor,
//         elevation: 2,
//       ),
//       body:

//           //同じようなものを何回も使うときに使う
//           ListView.builder(
//               itemCount: postList.length,
//               itemBuilder: (context, index) {
//                 return Container(
//                   decoration: BoxDecoration(
//                       border: index == 0
//                           ? Border(
//                               top: BorderSide(color: Colors.grey, width: 0),
//                               bottom: BorderSide(color: Colors.grey, width: 0),
//                             )
//                           : Border(
//                               bottom: BorderSide(color: Colors.grey, width: 0),
//                             )),
//                   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//                   child: Row(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(right: 8.0),
//                         child: CircleAvatar(
//                           radius: 22,
//                           foregroundImage: NetworkImage(myAccount.imagepath),
//                         ),
//                       ),
//                       Expanded(
//                         child: Container(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         myAccount.userId,
//                                         style: TextStyle(
//                                             color:
//                                                 Color.fromARGB(255, 0, 0, 0)),
//                                       ),
//                                       Text(
//                                         'があなたの投稿にいいね！しました',
//                                         style: TextStyle(color: Colors.grey),
//                                       ),
//                                     ],
//                                   ),
//                                   Text(DateFormat('M/d/yy')
//                                       .format(postList[index].createdTime!.toDate()))
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 );
//               }),
//     );
//   }
// }
