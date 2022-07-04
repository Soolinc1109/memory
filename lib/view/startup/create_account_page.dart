import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/utils/authentication.dart';
import 'package:memorys/utils/firestore/users.dart';
import 'package:memorys/view/bottomnavigationbar/screen.dart';
import 'package:memorys/view/startup/passward.dart';
import 'package:memorys/view/startup/signup_clear.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(children: [
            SizedBox(
              height: 80,
            ),
            Text(
              'メールアドレスを登録',
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                width: 310,
                child: Text('新しいアカウントのユーザーネームを選んでください（ユーザーネームはいつでも作成できます）')),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 300,
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'メールアドレス',
                  filled: true,
                  hintStyle: TextStyle(fontSize: 13),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 300,
              child: TextField(
                controller: passController,
                decoration: InputDecoration(
                  hintText: 'パスワード',
                  filled: true,
                  hintStyle: TextStyle(fontSize: 13),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 280,
              child: ElevatedButton(
                  onPressed: () async {
                    if (emailController.text.isNotEmpty &&
                        passController.text.isNotEmpty) {
                      var result = await Authentication.signUp(
                          email: emailController.text,
                          pass: passController.text);
                      if (result is UserCredential) {
                        // var results =
                        //     await UserFirestore.getUser(result.user!.uid);
                        // print('=========');
                        //resultがusercredential型だったら（ユーザーができてたら）
                        Account newAccount = Account(
                          id: result.user!.uid,

                          //新規登録アカウントのユーザーUIDをとってきている
                        );
                        print(Authentication.myAccount);

                        var _result = await UserFirestore.setUser(newAccount);
                        if (_result == true) {
                          // && results == true
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ClearPage()),
                          );
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 255, 184, 77),
                  ),
                  child: Text(
                    '次へ',
                  )),
            ),
          ]),
        ),
      ),
    );
  }
}
