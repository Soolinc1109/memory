import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/model/shop/detail.dart';
import 'package:memorys/model/shop/stylistpost.dart';
import 'package:memorys/utils/authentication.dart';
import 'package:memorys/utils/color.dart';
import 'package:memorys/utils/firestore/posts.dart';
import 'package:memorys/utils/firestore/shops.dart';
import 'package:memorys/utils/firestore/stylistposts.dart';

class CreateStylistPostPage extends StatefulWidget {
  final String? customer_id;
  final String carteId;

  const CreateStylistPostPage(
      {Key? key, this.customer_id, required this.carteId})
      : super(key: key);

  @override
  _CreateStylistPostPageState createState() => _CreateStylistPostPageState();
}

class _CreateStylistPostPageState extends State<CreateStylistPostPage> {
  Account myAccount = Authentication.myAccount!;
  final doc = FirebaseFirestore.instance.collection('posts').doc();
  TextEditingController contentController = TextEditingController();
  TextEditingController memoController = TextEditingController();
  List<File?> beforeImages = [null, null, null];
  List<File?> afterImages = [null, null, null];
  bool is_loading = false;

  final focusNode = FocusNode();
  final focusNode2 = FocusNode();

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

  final String initialImageUrl =
      'https://firebasestorage.googleapis.com/v0/b/memorys-dbc6f.appspot.com/o/1%3A10.png?alt=media&token=72fb6e60-0148-4889-938e-14b2dc66ac3e';

  @override
  Widget build(BuildContext context) {
    handleKeyboardOverlay(context, focusNode);
    handleKeyboardOverlay(context, focusNode2);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(0, 244, 67, 54),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: SingleChildScrollView(
              child: Column(children: [
                Row(
                  children: [
                    Text(
                      "Create Carte",
                      style: TextStyle(fontSize: 25),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      "Before",
                      style: TextStyle(
                          fontSize: 25,
                          color: AppColors.thirdColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
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
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      "After",
                      style: TextStyle(
                          fontSize: 25,
                          color: AppColors.thirdColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
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
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    focusNode: focusNode,
                    controller: contentController,
                    decoration: InputDecoration(
                      labelText: 'お客さんへのメッセージ',
                      hintText: 'お客さんへのメッセージ',
                      prefixIcon: Icon(Icons.edit),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                    onChanged: (value) {
                      print('Text field value: $value');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    focusNode: focusNode2,
                    controller: memoController,
                    decoration: InputDecoration(
                      labelText: 'カルテのメモ',
                      hintText: 'カルテのメモ',
                      prefixIcon: Icon(Icons.edit),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                    onChanged: (value) {
                      print('Text field value: $value');
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      "あとで修正できます",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: is_loading
                        ? null
                        : () async {
                            if (is_loading == true) {
                              return;
                            }
                            bool allImagesSelected = beforeImages
                                    .every((element) => element != null) &&
                                afterImages.every((element) => element != null);
                            if (contentController.text.isNotEmpty &&
                                allImagesSelected) {
                              is_loading = true;
                              setState(() {});
                              List<String> beforeImageUrls = [];
                              List<String> afterImageUrls = [];
                              for (int i = 0; i < 3; i++) {
                                final beforeImagePath =
                                    generateImageUploadPath('before_image_$i');
                                final afterImagePath =
                                    generateImageUploadPath('after_image_$i');
                                final beforeImageUrl = await uploadImage(
                                    beforeImages[i]!, beforeImagePath);
                                final afterImageUrl = await uploadImage(
                                    afterImages[i]!, afterImagePath);
                                beforeImageUrls.add(beforeImageUrl);
                                afterImageUrls.add(afterImageUrl);
                              }

                              final newPost = StylistPost(
                                  carte_id: widget.carteId,
                                  shop_id: myAccount.shopId,
                                  message_for_customer: contentController.text,
                                  customer_id: widget.customer_id ?? '',
                                  before_image: beforeImageUrls,
                                  after_image: afterImageUrls,
                                  postAccountId: myAccount.id);

                              var _result =
                                  await StylistPostFirestore.addStylistPost(
                                      newPost);
                              if (_result != null) {
                                var _result2 =
                                    await ShopFirestore.addCustomerInformation(
                                        myAccount.shopId,
                                        customerId: widget.customer_id,
                                        postId: _result,
                                        stylistId: myAccount.id,
                                        carteId: widget.carteId);

                                final detail = CarteDetail(
                                  created_at: Timestamp.now().toDate(),
                                  before_after_post_id: _result,
                                  memo: memoController.text,
                                  menu_id: '',
                                  post_stylist_id: myAccount.id,
                                );

                                var updatecarte =
                                    await PostFirestore.updateCarte(
                                        widget.carteId, beforeImageUrls[0]);
                                var resultdetail =
                                    await StylistPostFirestore.addCarteDetail(
                                        widget.carteId, detail);

                                if (_result2 == true &&
                                    resultdetail == true &&
                                    updatecarte == true) {
                                  is_loading = true;
                                  Navigator.pop(context);
                                } else {
                                  is_loading = false;
                                  setState(() {});
                                }
                              } else {
                                is_loading = false;
                                setState(() {});
                              }
                            }
                          },
                    child: Text('投稿')),
              ]),
            ),
          ),
          is_loading == true
              ? Center(child: CircularProgressIndicator())
              : Container()
        ],
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
