import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/model/stylistpost.dart';
import 'package:memorys/utils/authentication.dart';
import 'package:memorys/utils/firestore/stylistposts.dart';
import 'package:memorys/utils/function_utils.dart';

class CreateStylistPostPage extends StatefulWidget {
  const CreateStylistPostPage({Key? key}) : super(key: key);

  @override
  _CreateStylistPostPageState createState() => _CreateStylistPostPageState();
}

class _CreateStylistPostPageState extends State<CreateStylistPostPage> {
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

  Future<String> uploadpostImage(String pid) async {
    final FirebaseStorage storageInstance = FirebaseStorage.instance;
    final Reference ref = storageInstance.ref();
    await ref.child(pid).putFile(imageFile!);
    String downloadUrl = await storageInstance.ref(pid).getDownloadURL();
    return downloadUrl;
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
      body: Stack(
        children: [
          Padding(
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
                    if (is_loading == true) {
                      return;
                    }
                    String generateNonce([int length = 32]) {
                      const charset =
                          '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
                      final random = Random.secure();
                      final randomStr = List.generate(length,
                              (_) => charset[random.nextInt(charset.length)])
                          .join();
                      return randomStr;
                    }

                    final rondom = generateNonce();
                    is_loading = true;
                    setState(() {});
                    if (contentController.text.isNotEmpty &&
                        imageFile != null) {
                      String imagePath = '';
                      var result = await uploadpostImage(rondom);
                      imagePath = result;
                      var uploadImage = await FunctionUtils.addPostImage(
                          myAccount.id, imageFile!);

                      StylistPost newPost = StylistPost(
                          id: uploadImage['randomString']!,
                          poster_image_url: myAccount.imagepath,
                          message_for_customer: contentController.text,
                          customer_id: "kbk0SvvyYOdd6wjNmFbhEgRqUCH3",
                          createdTime: Timestamp.now(),
                          before_image: [
                            uploadImage['imageUrl'],
                            "https://mery.jp/wp-content/uploads/2020/11/thumbnail_1097024-1024x1280.jpg",
                            "https://mery.jp/wp-content/uploads/2020/11/thumbnail_1097024-1024x1280.jpg"
                          ],
                          after_image: [
                            "https://mery.jp/wp-content/uploads/2020/11/thumbnail_1097024-1024x1280.jpg",
                            "https://mery.jp/wp-content/uploads/2020/11/thumbnail_1097024-1024x1280.jpg",
                            "https://mery.jp/wp-content/uploads/2020/11/thumbnail_1097024-1024x1280.jpg"
                          ],
                          postAccountId: Authentication.myAccount!.id);
                      var _result =
                          await StylistPostFirestore.addStylistPost(newPost);
                      if (result == true) {
                        Navigator.pop(context);
                      } else {
                        is_loading = false;
                        setState(() {});
                      }
                    } else {
                      is_loading = false;
                      setState(() {});
                    }
                  },
                  child: Text('投稿'))
            ]),
          ),
          is_loading == true
              ? Center(child: CircularProgressIndicator())
              : Container()
        ],
      ),
    );
  }

  bool is_loading = false;
}
