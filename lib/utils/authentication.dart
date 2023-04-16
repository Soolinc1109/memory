import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/utils/firestore/users.dart';

class Authentication {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static User? get currentFirebaseUser => _firebaseAuth.currentUser;
  static Account? myAccount;
  static final _firestoreInstance = FirebaseFirestore.instance;

  static final CollectionReference users =
      _firestoreInstance.collection('users');

  static Future<dynamic> signUp(
      //引数に名前を付けられるようになる{}↓
      {required String email,
      required String pass}) async {
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
      final result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: pass);

      // currentFirebaseUser = _result.user;
      print('authサインイン完了');
      return result;
    } on FirebaseAuthException catch (e) {
      print('authサインインエラー');
      return false;
    }
  }

  static Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn(scopes: ['email']).signIn();
      if (googleUser != null) {
        final name = googleUser.displayName ?? '名称未設定';
        final imageUrl = googleUser.photoUrl ?? '';
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
        final userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        await createUserIfNotExist(
            userCredential: userCredential, name: name, imageUrl: imageUrl);
        // currentFirebaseUser = _result.user;

        return userCredential;
      }
    } on FirebaseAuthException {
      return null;
    }
    return null;
  }

  Future<void> createUserIfNotExist({
    required UserCredential userCredential,
    required String name,
    required String imageUrl,
  }) async {
    final result = await existsUser(userCredential.user!.uid);
    if (result) {
      return;
    }
    await UserFirestore.setUser(Account(
      id: userCredential.user!.uid,
      name: name,
      imagepath: imageUrl,
    ));
  }

  static Future<bool> existsUser(String uid) async {
    try {
      final documentSnapshot = await users.doc(uid).get();
      return documentSnapshot.exists;
    } on FirebaseException {
      return false;
      //ログイン時にfirestoreからユーザーの情報を取得
    }
  }
}
