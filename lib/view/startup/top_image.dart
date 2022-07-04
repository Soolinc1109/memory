import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/utils/authentication.dart';
import 'package:memorys/utils/firestore/users.dart';
import 'package:memorys/utils/function_utils.dart';
import 'package:memorys/view/account/account_page.dart';
import 'package:memorys/view/bottomnavigationbar/screen.dart';
import 'package:memorys/view/startup/create_account_page.dart';
import 'package:memorys/view/startup/passward.dart';

import 'dart:io';

import 'package:image_picker/image_picker.dart';

class TopImagePage extends StatefulWidget {
  const TopImagePage({Key? key}) : super(key: key);

  @override
  _TopImagePageState createState() => _TopImagePageState();
}

class _TopImagePageState extends State<TopImagePage> {

  Account? myAccount = Authentication.myAccount;
  TextEditingController emailController = TextEditingController();
  File? image;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        child: Column(children: [
          SizedBox(
            height: 50,
          ),
          image == null
              ? Text(
                  'プロフィール写真を追加',
                  style: TextStyle(fontSize: 25),
                )
              : SizedBox(
                  height: 100,
                ),
          Container(
            child: Text(
              'プロフィール写真が追加されました！',
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(width: 310, child: Text('プロフィール写真を追加すると、友達があなたを見つけやすくなる')),
          SizedBox(
            height: 30,
          ),
          Container(
            width: 300,
          ),
          SizedBox(
            height: 60,
          ),
          Container(
              height: 240,
              child: image == null
                  ? Image.asset('images/imageplus.jpg')
                  : CircleAvatar(
                      foregroundImage: FileImage(image!),
                      radius: 90,
                    )),
          image == null
              ? SizedBox(
                  height: 190,
                )
              : SizedBox(
                  height: 40,
                ),
          image == null
              ? Container(
                  width: 280,
                  child: ElevatedButton(
                      onPressed: () async {
                        var result = await FunctionUtils.getImageFromGalery();
                        if (result != null) {
                          setState(() {
                            image = File(result.path);
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 255, 184, 77),
                      ),
                      child: Text(
                        '写真を追加',
                      )),
                )
              : Container(
                  width: 280,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (image != null) {
                          String imagePath = await FunctionUtils.uploadImage(myAccount!.id,image!);
                          Account newAccount = Account(
                            imagepath: imagePath,
                          );
                          var _result = await UserFirestore.setUser(newAccount);
                          if (_result == true) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AccountPage()),
                            );
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
          SizedBox(
            height: 20,
          ),
          RichText(
            text: TextSpan(style: TextStyle(color: Colors.black), children: [
              TextSpan(
                  text: 'スキップ',
                  style: TextStyle(color: Colors.orange),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AccountPage()),
                      );
                    }),
            ]),
          ),
        ]),
      ),
    );
  }
}
