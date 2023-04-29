import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/utils/authentication.dart';
import 'package:memorys/utils/color.dart';
import 'package:memorys/utils/firestore/users.dart';
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

  final focusNode = FocusNode();
  final focusNode2 = FocusNode();

  @override
  Widget build(BuildContext context) {
    handleKeyboardOverlay(context, focusNode);
    handleKeyboardOverlay(context, focusNode2);

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
                focusNode: focusNode,
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
                focusNode: focusNode2,
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
                        Account newAccount = Account(
                          id: result.user!.uid,
                          is_stylist: false,
                          is_owner: false,
                        );
                        Authentication.myAccount = newAccount;
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
                    backgroundColor: AppColors.thirdColor,
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

OverlayEntry createCloseKeyboardButton(
    BuildContext context, FocusNode focusNode) {
  return OverlayEntry(
    builder: (BuildContext context) {
      return Positioned(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        right: 0,
        child: Material(
          // この行を追加
          color: Colors.transparent, // この行を追加
          child: IconButton(
            icon: Icon(Icons.keyboard_hide),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              // もしくは
              // focusNode.unfocus();
            },
          ),
        ), // この行を追加
      );
    },
  );
}

void handleKeyboardOverlay(BuildContext context, FocusNode focusNode) {
  final closeButtonOverlay = createCloseKeyboardButton(context, focusNode);

  focusNode.addListener(() {
    if (focusNode.hasFocus) {
      Overlay.of(context)?.insert(closeButtonOverlay);
    } else {
      closeButtonOverlay.remove();
    }
  });
}
