import 'package:flutter/material.dart';
import 'package:memorys/model/account.dart';

class AccountModel extends ChangeNotifier {
  Account _account = Account();

  Account get account => _account;

  void setAccount(Account account) {
    _account = account;
    notifyListeners();
  }
}
