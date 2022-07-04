import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/model/post.dart';
import 'package:memorys/model/userpost.dart';
import 'package:memorys/utils/authentication.dart';
import 'package:memorys/utils/firestore/posts.dart';
import 'package:memorys/utils/firestore/userpost.dart';
import 'package:memorys/utils/function_utils.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  Account myAccount = Authentication.myAccount!;
  File? imageFile;
  ImagePicker picker = ImagePicker();
  final doc = FirebaseFirestore.instance.collection('posts').doc();

  ImageProvider getImage() {
    if (imageFile == null) {
      return NetworkImage(
          'https://previews.123rf.com/images/hemantraval/hemantraval1203/hemantraval120300011/12634746-%E3%83%97%E3%83%A9%E3%82%B9-%E3%82%A2%E3%82%A4%E3%82%B3%E3%83%B3-%E3%83%9C%E3%82%BF%E3%83%B3.jpg?fj=1');
    } else {
      return FileImage(imageFile!);
    }
  }

//入力された情報を知るために用意]
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '新規投稿',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(children: [
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () async {
              var result = await FunctionUtils.getImageFromGalery();

              if (result != null) {
                setState(() {
                  imageFile = File(result.path);
                });
              }
            },
            child: Container(
              alignment: Alignment.centerLeft,
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: getImage(),
              )),
            ),
          ),
          TextField(
            controller: contentController,
            //contentControllerに入力された情報が入っている
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                if (contentController.text.isNotEmpty && imageFile != null) {
                  var uploadImage = await FunctionUtils.uploadPostImage(
                      myAccount.id, imageFile!);
                  UserPost newPost = UserPost(
                      Image: uploadImage,
                      content: contentController.text,
                      postAccountId: Authentication.myAccount!.id);

                  var result = await UserPostFirestore.addUserPost(newPost);
                  if (result == true) {
                    Navigator.pop(context);
                  }
                }
              },
              child: Text('投稿'))
        ]),
      ),
    );
  }
}
