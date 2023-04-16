import 'dart:async';
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

class CreateStylistPostPage extends StatefulWidget {
  final String customer_id;

  const CreateStylistPostPage({Key? key, required this.customer_id})
      : super(key: key);

  @override
  _CreateStylistPostPageState createState() => _CreateStylistPostPageState();
}

class _CreateStylistPostPageState extends State<CreateStylistPostPage> {
  Account myAccount = Authentication.myAccount!;
  final doc = FirebaseFirestore.instance.collection('posts').doc();
  TextEditingController contentController = TextEditingController();
  List<File?> beforeImages = [null, null, null];
  List<File?> afterImages = [null, null, null];
  bool is_loading = false;

  Future<String> uploadImage(File file, String imagePath) async {
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child(imagePath);
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  String generateImageUploadPath(String prefix) {
    return '$prefix-${Random().nextInt(1000000)}.jpg';
  }

  Widget buildImageBox(File? imageFile, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          image: DecorationImage(
            image: (imageFile != null
                ? FileImage(imageFile)
                : AssetImage('assets/plus_icon.png')) as ImageProvider<Object>,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Future<void> showImagePickerOptions(BuildContext context,
      ValueChanged<ImageSource> onImageSourceSelected) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('画像を選択'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('カメラで撮影'),
                  onTap: () {
                    onImageSourceSelected(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text('アルバムから選択'),
                  onTap: () {
                    onImageSourceSelected(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (int i = 0; i < 3; i++)
                    buildImageBox(beforeImages[i], () async {
                      await showImagePickerOptions(context, (source) async {
                        final pickedFile =
                            await ImagePicker().pickImage(source: source);
                        if (pickedFile != null) {
                          setState(() {
                            beforeImages[i] = File(pickedFile.path);
                          });
                        }
                      });
                    }),
                  for (int i = 0; i < 3; i++)
                    buildImageBox(afterImages[i], () async {
                      await showImagePickerOptions(context, (source) async {
                        final pickedFile =
                            await ImagePicker().pickImage(source: source);
                        if (pickedFile != null) {
                          setState(() {
                            afterImages[i] = File(pickedFile.path);
                          });
                        }
                      });
                    }),
                ],
              ),
              TextField(
                controller: contentController,
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (is_loading == true) {
                      return;
                    }
                    bool allImagesSelected =
                        beforeImages.every((element) => element != null) &&
                            afterImages.every((element) => element != null);
                    if (contentController.text.isNotEmpty &&
                        allImagesSelected) {
                      is_loading = true;
                      setState(() {});

                      // 画像をアップロード
                      List<String> beforeImageUrls = [];
                      List<String> afterImageUrls = [];
                      for (int i = 0; i < 3; i++) {
                        final beforeImagePath =
                            generateImageUploadPath('before_image_$i');
                        final afterImagePath =
                            generateImageUploadPath('after_image_$i');
                        final beforeImageUrl = await uploadImage(
                            beforeImages[i]!, beforeImagePath);
                        final afterImageUrl =
                            await uploadImage(afterImages[i]!, afterImagePath);
                        beforeImageUrls.add(beforeImageUrl);
                        afterImageUrls.add(afterImageUrl);
                      }

                      // Firestore に投稿データをアップロード
                      StylistPost newPost = StylistPost(
                          message_for_customer: contentController.text,
                          customer_id: widget.customer_id,
                          before_image: beforeImageUrls,
                          after_image: afterImageUrls,
                          postAccountId: Authentication.myAccount!.id);
                      var _result =
                          await StylistPostFirestore.addStylistPost(newPost);
                      if (_result == true) {
                        Navigator.pop(context);
                      } else {
                        is_loading = false;
                        setState(() {});
                      }
                    }
                  },
                  child: Text('投稿')),

              // プログレスインジケータ
              is_loading == true
                  ? Center(child: CircularProgressIndicator())
                  : Container()
            ]),
          ),
          is_loading == true
              ? Center(child: CircularProgressIndicator())
              : Container()
        ],
      ),
    );
  }
}
