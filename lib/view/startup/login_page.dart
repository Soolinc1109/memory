import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/utils/authentication.dart';
import 'package:memorys/utils/firestore/shops.dart';
import 'package:memorys/utils/firestore/users.dart';
import 'package:memorys/view/main_page.dart';
import 'package:memorys/view/startup/create_account_page.dart';
import 'package:memorys/view/startup/createshopaccount/shop_create_account_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              Container(
                  height: 150,
                  child: Image.network(
                      'https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/Memory.png?alt=media&token=cf787396-eaec-4c99-a721-bdd611ba3b78')),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  width: 300,
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        filled: true,
                        hintText: '電話番号、メールアドレス',
                        hintStyle: TextStyle(fontSize: 13),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        )),
                  ),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  controller: passController,
                  decoration: InputDecoration(
                      filled: true,
                      hintText: 'パスワード',
                      hintStyle: TextStyle(fontSize: 13),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      )),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RichText(
                textAlign: TextAlign.end,
                text: TextSpan(
                    text: 'パスワードを忘れた場合',
                    style: TextStyle(
                        color: Color.fromARGB(255, 244, 158, 255),
                        fontSize: 12),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        print('アカウント作成');
                      }),
              ),
              SizedBox(
                height: 30,
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  side: const BorderSide(
                      width: 0.6, color: Color.fromARGB(255, 122, 122, 122)),
                ),
                onPressed: () async {
                  final result = await Authentication().signInWithGoogle();
                  if (result is UserCredential) {
                    final result = await UserFirestore.getUser(
                        Authentication.currentFirebaseUser!.uid);
                    if (result == null) {
                      //エラーの処理
                      return;
                    }
                    await Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MainPage()),
                      ((route) => false),
                    );
                  }
                },
                child: SizedBox(
                  width: 250,
                  height: 47,
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Image(
                            width: 22,
                            height: 22,
                            image: NetworkImage(
                                'https://d1tlzifd8jdoy4.cloudfront.net/wp-content/uploads/2015/03/chrome.png')),
                      ),
                      Text(
                        'Googleのアカウントで始める',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: 280,
                child: ElevatedButton(
                    onPressed: () async {
                      var result = await Authentication.emailSignIn(
                          email: emailController.text,
                          pass: passController.text);
                      if (result is UserCredential) {
                        var _result =
                            await UserFirestore.getUser(result.user!.uid);
                        print(_result);
                        // await ShopFirestore.getShop();
                        if (_result is Account) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => MainPage()),
                          );
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(''),
                              content: Text('メールアドレスまたはパスワードが間違っています'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('もう一度'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 244, 158, 255),
                    ),
                    child: Text(
                      'ログイン',
                    )),
              ),
              Divider(
                color: Colors.black,
                thickness: 0.3,
                height: 60,
                indent: 50,
                endIndent: 50,
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(text: 'アカウントを作成していない方は'),
                    TextSpan(
                      text: 'こちら',
                      style:
                          TextStyle(color: Color.fromARGB(255, 244, 158, 255)),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateAccountPage()),
                          );
                        },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(text: '店舗の方は'),
                    TextSpan(
                      text: 'こちら',
                      style:
                          TextStyle(color: Color.fromARGB(255, 244, 158, 255)),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShopCreateAccountPage()),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
