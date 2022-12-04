import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:memorys/utils/authentication.dart';
import 'package:memorys/utils/firestore/shops.dart';
import 'package:memorys/utils/firestore/users.dart';
import 'package:memorys/view/account/account_page.dart';
import 'package:memorys/view/bottomnavigationbar/screen.dart';
import 'package:memorys/view/main_page.dart';
import 'package:memorys/view/startup/create_account_page.dart';

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
                height: 100,
              ),
              Container(
                  height: 150, child: Image.asset('images/instagram.jpeg')),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
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
                    style: TextStyle(color: Colors.orange, fontSize: 12),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        print('アカウント作成');
                      }),
              ),
              SizedBox(
                height: 70,
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
                        await ShopFirestore.getShop();
                        if (_result == true) {
                          //is_stylist = true　だったら　すたいりストページへ
                          // if(Authentication.myAccount!.is_stylist == true){
                          //   Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => MainPage()),
                          // );
                          // }
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => MainPage()),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 255, 184, 77),
                    ),
                    child: Text(
                      'ログイン',
                    )),
              ),
              Divider(
                color: Colors.black,
                thickness: 0.3,
                height: 100,
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
                      style: TextStyle(color: Colors.orange),
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
            ],
          ),
        ),
      ),
    );
  }
}
