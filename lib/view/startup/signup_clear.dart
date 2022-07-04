import 'package:flutter/material.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/utils/authentication.dart';
import 'package:memorys/utils/firestore/users.dart';
import 'package:memorys/view/bottomnavigationbar/screen.dart';
import 'package:memorys/view/startup/top_image.dart';

class ClearPage extends StatefulWidget {
  const ClearPage({Key? key}) : super(key: key);

  @override
  _ClearPageState createState() => _ClearPageState();
}

class _ClearPageState extends State<ClearPage> {
  Account myAccount = Authentication.myAccount!;
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(children: [
          SizedBox(
            height: 210,
          ),
          Text(
            'instagramへようこそ！',
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 310,
            child: Text('パスワードを保存すると他のicloudデバイスでパスワードを入力せずにログインできます'),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            width: 300,
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: '名前',
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
                  if (nameController.text.isNotEmpty) {
                    Account updateAccount = Account(
                      id: myAccount.id,
                      name: nameController.text,
                    );

                    var result = await UserFirestore.updateUser(updateAccount);
                    if (result == true) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => TopImagePage()),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 255, 184, 77),
                ),
                child: Text(
                  '登録を完了',
                )),
          ),
        ]),
      ),
    );
  }
}
