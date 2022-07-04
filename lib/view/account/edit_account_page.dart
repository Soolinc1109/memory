import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/utils/authentication.dart';
import 'package:memorys/utils/firestore/users.dart';
import 'package:memorys/utils/function_utils.dart';
import 'package:image_picker/image_picker.dart';

class EditAccountPage extends StatefulWidget {
  const EditAccountPage({Key? key}) : super(key: key);

  @override
  _EditAccountPageState createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  Account myAccount = Authentication.myAccount!;
  TextEditingController nameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController selfintroductionController = TextEditingController();
  File? image;

  ImageProvider getImage() {
    if (image == null) {
      return NetworkImage(myAccount.imagepath);
    } else {
      return FileImage(image!);
    }
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: myAccount.name);
    userIdController = TextEditingController(text: myAccount.userId);
    selfintroductionController =
        TextEditingController(text: myAccount.selfIntroduction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black, size: 30),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: Text(
          'プロフィールを編集',
          style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(children: [
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () async {
                var result = await FunctionUtils.getImageFromGalery();
                if (result != null) {
                  setState(() {
                    image = File(result.path);
                  });
                }
              },
              child: CircleAvatar(
                foregroundImage: getImage(),
                radius: 40,
                child: Icon(Icons.add),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Container(width: 80, child: Text('名前')),
                ),
                Container(
                  width: 200,
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: '名前',
                      hintStyle: TextStyle(fontSize: 13),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.black,
              height: 30,
              indent: 20,
              endIndent: 20,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Container(width: 60, child: Text('ユーザーネーム')),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  width: 200,
                  child: TextField(
                    controller: userIdController,
                    decoration: InputDecoration(
                      hintText: 'ユーザーネーム',
                      hintStyle: TextStyle(fontSize: 13),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.black,
              height: 30,
              indent: 20,
              endIndent: 20,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Container(width: 60, child: Text('自己紹介')),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  height: 200,
                  width: 250,
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: selfintroductionController,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 60, horizontal: 10),
                      hintText: '自己紹介',
                      hintStyle: TextStyle(fontSize: 13),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              width: 280,
              child: ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isNotEmpty &&
                        userIdController.text.isNotEmpty &&
                        selfintroductionController.text.isNotEmpty) {
                      String imagePath = '';
                      if (image == null) {
                        imagePath = myAccount.imagepath;
                      } else {
                        var result = await FunctionUtils.uploadImage(
                            myAccount.id, image!);
                        imagePath == result;
                      }
                      print(imagePath);
                      Account updateAccount = Account(
                          id: myAccount.id,
                          name: nameController.text,
                          selfIntroduction: selfintroductionController.text,
                          userId: userIdController.text,
                          imagepath: imagePath);
                      print(updateAccount);
                      var result =
                          await UserFirestore.updateUser(updateAccount);
                      if (result == true) {
                        // Authentication.myAccount = updateAccount;
                        Navigator.pop(context, true);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 255, 184, 77),
                  ),
                  child: Text(
                    '更新',
                  )),
            ),
          ]),
        ),
      ),
    );
  }
}
