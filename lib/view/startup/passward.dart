import 'package:flutter/material.dart';
import 'package:memorys/utils/color.dart';
import 'package:memorys/view/userPageView/bottomnavigationbar/screen.dart';
import 'package:memorys/view/startup/signup_clear.dart';

class PassWardPage extends StatefulWidget {
  const PassWardPage({Key? key}) : super(key: key);

  @override
  _PassWardPageState createState() => _PassWardPageState();
}

class _PassWardPageState extends State<PassWardPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController selfintroductionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(children: [
          SizedBox(
            height: 80,
          ),
          Text(
            'パスワードを作成',
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
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ClearPage()),
                  );
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
    );
  }
}
