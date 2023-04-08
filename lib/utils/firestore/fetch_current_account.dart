import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/provider/account_model.dart';
import 'package:provider/provider.dart';

Future<void> fetchAccountInfo(BuildContext context, String userId) async {
  final doc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
  final data = doc.data();
  if (data != null) {
    final account = Account(
      id: doc.id,
      name: data['name'],
      imagepath: data['imagepath'],
      selfIntroduction: data['selfIntroduction'],
      userId: data['userId'],
      follow: data['follow'],
      follower: data['follower'],
      is_stylist: data['is_stylist'],
      createdTime: data['createdTime'],
      updatedTime: data['updatedTime'],
    );

// AccountModelにユーザー情報をセット
    final accountModel = Provider.of<AccountModel>(context, listen: false);
    accountModel.setAccount(account);
  }
}
