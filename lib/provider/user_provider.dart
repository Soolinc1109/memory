import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memorys/model/account.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  Account? _currentUser;
  Account? get currentUser => _currentUser;

  Future<Account> _getAccountFromFirestore(String uid) async {
    print('=========================');
    print(uid);
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data();

    if (data != null) {
      return Account(
          id: uid,
          name: data['name'],
          imagepath: data['image_path'],
          is_stylist: false,
          selfIntroduction: data['self_introduction'],
          updatedTime: data['updated_time'],
          userId: data["user_id"],
          createdTime: data['created_time']
          // 他のフィールドも必要に応じて追加してください
          );
    } else {
      throw Exception('ユーザーが見つかりません');
    }
  }
}
