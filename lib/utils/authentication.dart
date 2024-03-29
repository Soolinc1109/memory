import 'package:firebase_auth/firebase_auth.dart';
import 'package:memorys/model/account.dart';

class Authentication {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static User? currentFirebaseUser;
  static Account? myAccount;

  static Future<dynamic> signUp(
      //引数に名前を付けられるようになる{}↓
      {required String email,required String pass}) async {
    try {
      UserCredential newAccount = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: pass);
      print('auth登録完了');
      return newAccount;
    } on FirebaseAuthException catch (e) {
      print('auth登録エラー');
      return false;
    }
  }

  static Future<dynamic> emailSignIn(
      {required String email, required String pass}) async {
    try {
      final UserCredential _result = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: pass);

      currentFirebaseUser = _result.user;
      print('authサインイン完了');
      return _result;
    } on FirebaseAuthException catch (e) {
      print('authサインインエラー');
      return false;
    }
  }
}
